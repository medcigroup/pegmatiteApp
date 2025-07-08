import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/data_model.dart';

class PegmatiteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =============================================
  // GESTION DES ZONES D'ÉTUDE
  // =============================================

  /// Récupérer toutes les zones d'étude
  Future<List<StudyArea>> getStudyAreas({
    String? region,
    ExplorationStatus? status,
    PegmatiteType? pegmatiteType,
  }) async {
    try {
      var query = _supabase.from('study_areas').select('''
        id, created_at, updated_at, created_by, name, description, region,
        geometry, area_km2, target_pegmatite_type, exploration_status,
        priority_level, geological_context, access_difficulty
      ''');

      if (region != null) {
        query = query.eq('region', region);
      }

      if (status != null) {
        query = query.eq('exploration_status', status.name);
      }

      if (pegmatiteType != null) {
        query = query.eq('target_pegmatite_type', pegmatiteType.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => StudyArea.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des zones d\'étude: $e');
    }
  }

  /// Rechercher les zones d'étude dans une emprise géographique
  Future<List<StudyArea>> getStudyAreasWithinBounds(
      double minLat,
      double maxLat,
      double minLng,
      double maxLng,
      ) async {
    try {
      final response = await _supabase.rpc('get_study_areas_within_bounds', params: {
        'min_lat': minLat,
        'max_lat': maxLat,
        'min_lng': minLng,
        'max_lng': maxLng,
      });

      return (response as List)
          .map((json) => StudyArea.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche géospatiale: $e');
    }
  }

  /// Créer une nouvelle zone d'étude
  Future<StudyArea> createStudyArea({
    required String name,
    String? description,
    required String region,
    required List<List<double>> coordinates, // [[lng, lat], ...]
    required PegmatiteType targetPegmatiteType,
    int priorityLevel = 1,
    String? geologicalContext,
    AccessDifficulty accessDifficulty = AccessDifficulty.medium,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non connecté');

      // Construire la géométrie PostgreSQL
      final polygonWKT = _buildPolygonWKT(coordinates);

      final response = await _supabase.rpc('create_study_area_with_geometry', params: {
        'p_name': name,
        'p_description': description,
        'p_region': region,
        'p_geometry_wkt': polygonWKT,
        'p_target_pegmatite_type': targetPegmatiteType.name,
        'p_priority_level': priorityLevel,
        'p_geological_context': geologicalContext,
        'p_access_difficulty': accessDifficulty.name,
        'p_created_by': user.id,
      });

      return StudyArea.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la création de la zone d\'étude: $e');
    }
  }

  /// Mettre à jour une zone d'étude
  Future<StudyArea> updateStudyArea(
      String id,
      Map<String, dynamic> updates,
      ) async {
    try {
      final response = await _supabase
          .from('study_areas')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return StudyArea.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la zone d\'étude: $e');
    }
  }

  /// Supprimer une zone d'étude
  Future<void> deleteStudyArea(String id) async {
    try {
      await _supabase.from('study_areas').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la zone d\'étude: $e');
    }
  }

  // =============================================
  // GESTION DES IMAGES SATELLITAIRES
  // =============================================

  /// Récupérer les images satellitaires
  Future<List<SatelliteImage>> getSatelliteImages({
    SensorType? sensor,
    DateTime? fromDate,
    DateTime? toDate,
    ProcessingStatus? status,
    double? maxCloudCoverage,
  }) async {
    try {
      var query = _supabase.from('satellite_images').select('''
        id, created_at, uploaded_by, sensor, mission, product_id,
        acquisition_date, processing_date, bounds, cloud_coverage,
        image_quality, file_path, file_size_mb, storage_bucket,
        available_bands, spectral_resolution, processing_status,
        preprocessing_parameters, metadata
      ''');

      if (sensor != null) {
        query = query.eq('sensor', sensor.displayName);
      }

      if (fromDate != null) {
        query = query.gte('acquisition_date', fromDate.toIso8601String());
      }

      if (toDate != null) {
        query = query.lte('acquisition_date', toDate.toIso8601String());
      }

      if (status != null) {
        query = query.eq('processing_status', status.name);
      }

      if (maxCloudCoverage != null) {
        query = query.lte('cloud_coverage', maxCloudCoverage);
      }

      final response = await query.order('acquisition_date', ascending: false);

      return (response as List)
          .map((json) => SatelliteImage.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des images satellitaires: $e');
    }
  }

  /// Uploader les métadonnées d'une image satellitaire
  Future<SatelliteImage> uploadSatelliteImageMetadata({
    required SensorType sensor,
    String? mission,
    String? productId,
    required DateTime acquisitionDate,
    required List<List<double>> bounds,
    double? cloudCoverage,
    required ImageQuality imageQuality,
    required String filePath,
    double? fileSizeMb,
    required List<String> availableBands,
    double? spectralResolution,
    Map<String, dynamic>? preprocessingParameters,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non connecté');

      final boundsWKT = _buildPolygonWKT(bounds);

      final response = await _supabase.rpc('create_satellite_image', params: {
        'p_sensor': sensor.displayName,
        'p_mission': mission,
        'p_product_id': productId,
        'p_acquisition_date': acquisitionDate.toIso8601String(),
        'p_bounds_wkt': boundsWKT,
        'p_cloud_coverage': cloudCoverage,
        'p_image_quality': imageQuality.name,
        'p_file_path': filePath,
        'p_file_size_mb': fileSizeMb,
        'p_available_bands': availableBands,
        'p_spectral_resolution': spectralResolution,
        'p_preprocessing_parameters': preprocessingParameters,
        'p_metadata': metadata,
        'p_uploaded_by': user.id,
      });

      return SatelliteImage.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de l\'upload des métadonnées: $e');
    }
  }

  /// Uploader un fichier image vers le storage Supabase
  Future<String> uploadImageFile(String filePath, Uint8List fileBytes) async {
    try {
      final fileName = 'satellite_images/${DateTime.now().millisecondsSinceEpoch}_${filePath.split('/').last}';

      await _supabase.storage
          .from('satellite-data')
          .uploadBinary(fileName, fileBytes);

      return _supabase.storage
          .from('satellite-data')
          .getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Erreur lors de l\'upload du fichier: $e');
    }
  }

  // =============================================
  // GESTION DES ANALYSES SPECTRALES
  // =============================================

  /// Récupérer les analyses spectrales
  Future<List<SpectralAnalysis>> getSpectralAnalyses({
    String? studyAreaId,
    String? createdBy,
    AnalysisStatus? status,
    ValidationStatus? validationStatus,
    PegmatiteType? pegmatiteType,
    AnalysisAlgorithm? algorithm,
    int? limit,
  }) async {
    try {
      var query = _supabase.from('spectral_analyses').select('''
        id, created_at, updated_at, created_by, study_area_id,
        primary_image_id, secondary_images, pegmatite_type, algorithm,
        confidence_threshold, processing_parameters, total_detections,
        high_confidence_detections, average_confidence, analysis_duration_seconds,
        status, validation_status, validated_by, validated_at,
        validation_notes, performance_metrics, notes, tags
      ''');

      if (studyAreaId != null) {
        query = query.eq('study_area_id', studyAreaId);
      }

      if (createdBy != null) {
        query = query.eq('created_by', createdBy);
      }

      if (status != null) {
        query = query.eq('status', status.name);
      }

      if (validationStatus != null) {
        query = query.eq('validation_status', validationStatus.name);
      }

      if (pegmatiteType != null) {
        query = query.eq('pegmatite_type', pegmatiteType.name);
      }

      if (algorithm != null) {
        query = query.eq('algorithm', algorithm.name);
      }

      if (limit != null) {

      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => SpectralAnalysis.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des analyses: $e');
    }
  }

  /// Créer une nouvelle analyse spectrale
  Future<SpectralAnalysis> createSpectralAnalysis({
    required String studyAreaId,
    required String primaryImageId,
    List<String> secondaryImages = const [],
    required PegmatiteType pegmatiteType,
    required AnalysisAlgorithm algorithm,
    double confidenceThreshold = 0.75,
    Map<String, dynamic>? processingParameters,
    String? notes,
    List<String> tags = const [],
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non connecté');

      final defaultParameters = {
        'ndvi_threshold': 0.3,
        'atmospheric_correction': 'DOS1',
        'spatial_filter': '3x3_median',
        'spectral_indices': pegmatiteType == PegmatiteType.feldspathiques
            ? ['feldspath_index', 'bright_index']
            : ['iron_ratio', 'magnetic_index'],
      };

      final finalParameters = {...defaultParameters, ...?processingParameters};

      final response = await _supabase.from('spectral_analyses').insert({
        'study_area_id': studyAreaId,
        'primary_image_id': primaryImageId,
        'secondary_images': secondaryImages,
        'pegmatite_type': pegmatiteType.name,
        'algorithm': algorithm.name,
        'confidence_threshold': confidenceThreshold,
        'processing_parameters': finalParameters,
        'notes': notes,
        'tags': tags,
        'created_by': user.id,
      }).select().single();

      return SpectralAnalysis.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'analyse: $e');
    }
  }

  /// Mettre à jour le statut d'une analyse
  Future<SpectralAnalysis> updateAnalysisStatus(
      String analysisId,
      AnalysisStatus status, {
        int? totalDetections,
        int? highConfidenceDetections,
        double? averageConfidence,
        int? analysisDurationSeconds,
        Map<String, dynamic>? performanceMetrics,
      }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (totalDetections != null) updates['total_detections'] = totalDetections;
      if (highConfidenceDetections != null) updates['high_confidence_detections'] = highConfidenceDetections;
      if (averageConfidence != null) updates['average_confidence'] = averageConfidence;
      if (analysisDurationSeconds != null) updates['analysis_duration_seconds'] = analysisDurationSeconds;
      if (performanceMetrics != null) updates['performance_metrics'] = performanceMetrics;

      final response = await _supabase
          .from('spectral_analyses')
          .update(updates)
          .eq('id', analysisId)
          .select()
          .single();

      return SpectralAnalysis.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'analyse: $e');
    }
  }

  /// Valider une analyse
  Future<SpectralAnalysis> validateAnalysis(
      String analysisId,
      ValidationStatus validationStatus, {
        String? validationNotes,
      }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Utilisateur non connecté');

      final response = await _supabase
          .from('spectral_analyses')
          .update({
        'validation_status': validationStatus.name,
        'validated_by': user.id,
        'validated_at': DateTime.now().toIso8601String(),
        'validation_notes': validationNotes,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', analysisId)
          .select()
          .single();

      return SpectralAnalysis.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la validation de l\'analyse: $e');
    }
  }

  // =============================================
  // GESTION DES DÉTECTIONS DE PEGMATITES
  // =============================================

  /// Récupérer les détections de pegmatites
  Future<List<PegmatiteDetection>> getPegmatiteDetections({
    String? analysisId,
    PegmatiteType? pegmatiteType,
    double? minConfidence,
    bool? fieldValidated,
    FieldValidationResult? fieldValidationResult,
  }) async {
    try {
      var query = _supabase.from('pegmatite_detections').select('''
        id, created_at, analysis_id, geometry, centroid, area_m2,
        pegmatite_type, confidence_score, classification_method,
        spectral_indices, field_validated, field_validation_date,
        field_validation_result, field_notes, detection_rank,
        pixel_count, mixed_pixels_percentage
      ''');

      if (analysisId != null) {
        query = query.eq('analysis_id', analysisId);
      }

      if (pegmatiteType != null) {
        query = query.eq('pegmatite_type', pegmatiteType.name);
      }

      if (minConfidence != null) {
        query = query.gte('confidence_score', minConfidence);
      }

      if (fieldValidated != null) {
        query = query.eq('field_validated', fieldValidated);
      }

      if (fieldValidationResult != null) {
        query = query.eq('field_validation_result', fieldValidationResult.name);
      }

      final response = await query.order('confidence_score', ascending: false);

      return (response as List)
          .map((json) => PegmatiteDetection.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des détections: $e');
    }
  }

  /// Sauvegarder des détections de pegmatites
  Future<List<PegmatiteDetection>> savePegmatiteDetections(
      String analysisId,
      List<Map<String, dynamic>> detections,
      ) async {
    try {
      final detectionsData = detections.map((detection) => {
        ...detection,
        'analysis_id': analysisId,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      final response = await _supabase
          .from('pegmatite_detections')
          .insert(detectionsData)
          .select();

      return (response as List)
          .map((json) => PegmatiteDetection.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde des détections: $e');
    }
  }

  /// Mettre à jour la validation terrain d'une détection
  Future<PegmatiteDetection> updateFieldValidation(
      String detectionId, {
        required bool fieldValidated,
        DateTime? fieldValidationDate,
        FieldValidationResult? fieldValidationResult,
        String? fieldNotes,
      }) async {
    try {
      final response = await _supabase
          .from('pegmatite_detections')
          .update({
        'field_validated': fieldValidated,
        'field_validation_date': fieldValidationDate?.toIso8601String(),
        'field_validation_result': fieldValidationResult?.name,
        'field_notes': fieldNotes,
      })
          .eq('id', detectionId)
          .select()
          .single();

      return PegmatiteDetection.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la validation: $e');
    }
  }

  // =============================================
  // GESTION DES INDICES SPECTRAUX
  // =============================================

  /// Récupérer les indices spectraux
  Future<List<SpectralIndex>> getSpectralIndices({
    String? imageId,
    String? analysisId,
    SpectralIndexType? indexType,
  }) async {
    try {
      var query = _supabase.from('spectral_indices').select('''
        id, created_at, image_id, analysis_id, index_type,
        sample_points, index_values, statistics, calculation_parameters,
        bands_used, quality_flag, processing_notes
      ''');

      if (imageId != null) {
        query = query.eq('image_id', imageId);
      }

      if (analysisId != null) {
        query = query.eq('analysis_id', analysisId);
      }

      if (indexType != null) {
        query = query.eq('index_type', indexType.name);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => SpectralIndex.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des indices spectraux: $e');
    }
  }

  /// Sauvegarder des indices spectraux calculés
  Future<SpectralIndex> saveSpectralIndex({
    required String imageId,
    String? analysisId,
    required SpectralIndexType indexType,
    required List<List<double>> samplePoints, // [[lng, lat], ...]
    required List<double> indexValues,
    required Map<String, dynamic> statistics,
    required Map<String, dynamic> calculationParameters,
    required List<String> bandsUsed,
    IndexQuality qualityFlag = IndexQuality.good,
    String? processingNotes,
  }) async {
    try {
      final samplePointsWKT = _buildMultiPointWKT(samplePoints);

      final response = await _supabase.rpc('create_spectral_index', params: {
        'p_image_id': imageId,
        'p_analysis_id': analysisId,
        'p_index_type': indexType.name,
        'p_sample_points_wkt': samplePointsWKT,
        'p_index_values': indexValues,
        'p_statistics': statistics,
        'p_calculation_parameters': calculationParameters,
        'p_bands_used': bandsUsed,
        'p_quality_flag': qualityFlag.name,
        'p_processing_notes': processingNotes,
      });

      return SpectralIndex.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de l\'indice spectral: $e');
    }
  }

  // =============================================
  // STATISTIQUES ET RAPPORTS
  // =============================================

  /// Obtenir les statistiques d'analyse pour une zone
  Future<AnalysisStatistics> getAnalysisStatistics(String studyAreaId) async {
    try {
      final response = await _supabase.rpc('get_analysis_statistics', params: {
        'area_id_param': studyAreaId,
      });

      if (response.isEmpty) {
        return AnalysisStatistics(
          totalAnalyses: 0,
          completedAnalyses: 0,
          totalDetections: 0,
          areaAnalyzedKm2: 0,
        );
      }

      return AnalysisStatistics.fromJson(response[0]);
    } catch (e) {
      throw Exception('Erreur lors du calcul des statistiques: $e');
    }
  }

  /// Obtenir la performance des algorithmes
  Future<List<AlgorithmPerformance>> getAlgorithmPerformance() async {
    try {
      final response = await _supabase.rpc('get_algorithm_performance');

      return (response as List)
          .map((json) => AlgorithmPerformance.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du calcul de la performance: $e');
    }
  }

  /// Obtenir un résumé des activités récentes
  Future<Map<String, dynamic>> getActivitySummary({
    Duration? period,
  }) async {
    try {
      final fromDate = period != null
          ? DateTime.now().subtract(period)
          : DateTime.now().subtract(const Duration(days: 30));

      final analyses = await getSpectralAnalyses(limit: 100);
      final recentAnalyses = analyses.where(
              (a) => a.createdAt.isAfter(fromDate)
      ).toList();

      final completedAnalyses = recentAnalyses.where(
              (a) => a.status == AnalysisStatus.completed
      ).length;

      final totalDetections = recentAnalyses
          .map((a) => a.totalDetections)
          .fold(0, (sum, count) => sum + count);

      final avgConfidence = recentAnalyses
          .where((a) => a.averageConfidence != null)
          .map((a) => a.averageConfidence!)
          .fold(0.0, (sum, conf) => sum + conf) /
          recentAnalyses.where((a) => a.averageConfidence != null).length;

      return {
        'period_days': period?.inDays ?? 30,
        'total_analyses': recentAnalyses.length,
        'completed_analyses': completedAnalyses,
        'total_detections': totalDetections,
        'average_confidence': avgConfidence.isNaN ? 0.0 : avgConfidence,
        'completion_rate': recentAnalyses.isNotEmpty
            ? completedAnalyses / recentAnalyses.length
            : 0.0,
      };
    } catch (e) {
      throw Exception('Erreur lors du calcul du résumé d\'activité: $e');
    }
  }

  // =============================================
  // GESTION DES ACTIVITÉS UTILISATEUR
  // =============================================

  /// Enregistrer une activité utilisateur
  Future<void> logUserActivity(
      ActivityType activityType, {
        String? resourceType,
        String? resourceId,
        Map<String, dynamic>? actionDetails,
      }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('user_activities').insert({
        'user_id': user.id,
        'activity_type': activityType.name,
        'resource_type': resourceType,
        'resource_id': resourceId,
        'action_details': actionDetails ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log silencieusement les erreurs d'activité pour ne pas interrompre le flux
      print('Erreur lors de l\'enregistrement de l\'activité: $e');
    }
  }

  /// Récupérer les activités récentes d'un utilisateur
  Future<List<UserActivity>> getUserActivities({
    String? userId,
    ActivityType? activityType,
    int limit = 50,
  }) async {
    try {
      var query = _supabase.from('user_activities').select('''
        id, timestamp, user_id, activity_type, resource_type,
        resource_id, action_details, ip_address, user_agent, session_id
      ''');

      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      if (activityType != null) {
        query = query.eq('activity_type', activityType.name);
      }

      final response = await query
          .order('timestamp', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => UserActivity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des activités: $e');
    }
  }

  // =============================================
  // MÉTHODES UTILITAIRES PRIVÉES
  // =============================================

  /// Construire une géométrie Polygon WKT à partir de coordonnées
  String _buildPolygonWKT(List<List<double>> coordinates) {
    if (coordinates.isEmpty) throw Exception('Coordonnées vides');

    // S'assurer que le polygon est fermé
    if (coordinates.first[0] != coordinates.last[0] ||
        coordinates.first[1] != coordinates.last[1]) {
      coordinates.add(coordinates.first);
    }

    final coordsStr = coordinates
        .map((coord) => '${coord[0]} ${coord[1]}')
        .join(', ');

    return 'POLYGON(($coordsStr))';
  }

  /// Construire une géométrie MultiPoint WKT à partir de points
  String _buildMultiPointWKT(List<List<double>> points) {
    if (points.isEmpty) throw Exception('Points vides');

    final pointsStr = points
        .map((point) => '(${point[0]} ${point[1]})')
        .join(', ');

    return 'MULTIPOINT($pointsStr)';
  }

  /// Nettoyer les données anciennes
  Future<String> cleanupOldData({int retentionMonths = 12}) async {
    try {
      final response = await _supabase.rpc('cleanup_old_data', params: {
        'retention_months': retentionMonths,
      });

      return response as String;
    } catch (e) {
      throw Exception('Erreur lors du nettoyage des données: $e');
    }
  }
}