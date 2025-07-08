import 'package:latlong2/latlong.dart';

// =============================================
// MODÈLES UTILISATEURS ET PROFILS
// =============================================

class UserProfile {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String organization;
  final String role;
  final String? department;
  final String preferredLanguage;
  final String themePreference;
  final Map<String, dynamic> notificationPreferences;
  final DateTime? lastLogin;
  final bool isActive;

  UserProfile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.organization,
    required this.role,
    this.department,
    this.preferredLanguage = 'fr',
    this.themePreference = 'light',
    this.notificationPreferences = const {'email': true, 'analysis': true, 'system': false},
    this.lastLogin,
    this.isActive = true,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      organization: json['organization'],
      role: json['role'],
      department: json['department'],
      preferredLanguage: json['preferred_language'] ?? 'fr',
      themePreference: json['theme_preference'] ?? 'light',
      notificationPreferences: json['notification_preferences'] ?? {'email': true, 'analysis': true, 'system': false},
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'organization': organization,
      'role': role,
      'department': department,
      'preferred_language': preferredLanguage,
      'theme_preference': themePreference,
      'notification_preferences': notificationPreferences,
      'last_login': lastLogin?.toIso8601String(),
      'is_active': isActive,
    };
  }
}

// =============================================
// MODÈLES GÉOSPATIALES
// =============================================

class StudyArea {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String name;
  final String? description;
  final String region;
  final List<LatLng> coordinates;
  final double areaKm2;
  final PegmatiteType targetPegmatiteType;
  final ExplorationStatus explorationStatus;
  final int priorityLevel;
  final String? geologicalContext;
  final AccessDifficulty accessDifficulty;

  StudyArea({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.name,
    this.description,
    required this.region,
    required this.coordinates,
    required this.areaKm2,
    required this.targetPegmatiteType,
    required this.explorationStatus,
    required this.priorityLevel,
    this.geologicalContext,
    required this.accessDifficulty,
  });

  factory StudyArea.fromJson(Map<String, dynamic> json) {
    List<LatLng> parseCoordinates(dynamic geometryJson) {
      if (geometryJson == null) return [];

      // Si c'est déjà un Map (GeoJSON)
      if (geometryJson is Map) {
        final coordinates = geometryJson['coordinates'][0] as List;
        return coordinates.map((coord) =>
            LatLng(coord[1].toDouble(), coord[0].toDouble())
        ).toList();
      }

      // Si c'est une string GeoJSON
      if (geometryJson is String) {
        // Parser le GeoJSON string ici
        // Pour la simplicité, retourner une liste vide
        return [];
      }

      return [];
    }

    return StudyArea(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
      name: json['name'],
      description: json['description'],
      region: json['region'],
      coordinates: parseCoordinates(json['geometry']),
      areaKm2: double.parse(json['area_km2'].toString()),
      targetPegmatiteType: PegmatiteType.values.firstWhere(
            (e) => e.name == json['target_pegmatite_type'],
        orElse: () => PegmatiteType.feldspathiques,
      ),
      explorationStatus: ExplorationStatus.values.firstWhere(
            (e) => e.name == json['exploration_status'],
        orElse: () => ExplorationStatus.pending,
      ),
      priorityLevel: json['priority_level'],
      geologicalContext: json['geological_context'],
      accessDifficulty: AccessDifficulty.values.firstWhere(
            (e) => e.name == json['access_difficulty'],
        orElse: () => AccessDifficulty.medium,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'name': name,
      'description': description,
      'region': region,
      'area_km2': areaKm2,
      'target_pegmatite_type': targetPegmatiteType.name,
      'exploration_status': explorationStatus.name,
      'priority_level': priorityLevel,
      'geological_context': geologicalContext,
      'access_difficulty': accessDifficulty.name,
    };
  }

  LatLng get center {
    if (coordinates.isEmpty) return LatLng(0, 0);

    double lat = coordinates.map((c) => c.latitude).reduce((a, b) => a + b) / coordinates.length;
    double lng = coordinates.map((c) => c.longitude).reduce((a, b) => a + b) / coordinates.length;

    return LatLng(lat, lng);
  }
}

// =============================================
// MODÈLES IMAGES SATELLITAIRES
// =============================================

class SatelliteImage {
  final String id;
  final DateTime createdAt;
  final String uploadedBy;
  final SensorType sensor;
  final String? mission;
  final String? productId;
  final DateTime acquisitionDate;
  final DateTime processingDate;
  final List<LatLng> bounds;
  final double? cloudCoverage;
  final ImageQuality imageQuality;
  final String filePath;
  final double? fileSizeMb;
  final String storageBucket;
  final List<String> availableBands;
  final double? spectralResolution;
  final ProcessingStatus processingStatus;
  final Map<String, dynamic>? preprocessingParameters;
  final Map<String, dynamic> metadata;

  SatelliteImage({
    required this.id,
    required this.createdAt,
    required this.uploadedBy,
    required this.sensor,
    this.mission,
    this.productId,
    required this.acquisitionDate,
    required this.processingDate,
    required this.bounds,
    this.cloudCoverage,
    required this.imageQuality,
    required this.filePath,
    this.fileSizeMb,
    required this.storageBucket,
    required this.availableBands,
    this.spectralResolution,
    required this.processingStatus,
    this.preprocessingParameters,
    this.metadata = const {},
  });

  factory SatelliteImage.fromJson(Map<String, dynamic> json) {
    return SatelliteImage(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      uploadedBy: json['uploaded_by'],
      sensor: SensorType.values.firstWhere(
            (e) => e.name == json['sensor'].toString().replaceAll('-', ''),
        orElse: () => SensorType.Landsat8,
      ),
      mission: json['mission'],
      productId: json['product_id'],
      acquisitionDate: DateTime.parse(json['acquisition_date']),
      processingDate: DateTime.parse(json['processing_date']),
      bounds: [], // TODO: Parser la géométrie bounds
      cloudCoverage: json['cloud_coverage']?.toDouble(),
      imageQuality: ImageQuality.values.firstWhere(
            (e) => e.name == json['image_quality'],
        orElse: () => ImageQuality.good,
      ),
      filePath: json['file_path'],
      fileSizeMb: json['file_size_mb']?.toDouble(),
      storageBucket: json['storage_bucket'],
      availableBands: List<String>.from(json['available_bands'] ?? []),
      spectralResolution: json['spectral_resolution']?.toDouble(),
      processingStatus: ProcessingStatus.values.firstWhere(
            (e) => e.name == json['processing_status'],
        orElse: () => ProcessingStatus.raw,
      ),
      preprocessingParameters: json['preprocessing_parameters'],
      metadata: json['metadata'] ?? {},
    );
  }
}

// =============================================
// MODÈLES ANALYSES ET RÉSULTATS
// =============================================

class SpectralAnalysis {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String studyAreaId;
  final String primaryImageId;
  final List<String> secondaryImages;
  final PegmatiteType pegmatiteType;
  final AnalysisAlgorithm algorithm;
  final double confidenceThreshold;
  final Map<String, dynamic> processingParameters;
  final int totalDetections;
  final int highConfidenceDetections;
  final double? averageConfidence;
  final int? analysisDurationSeconds;
  final AnalysisStatus status;
  final ValidationStatus validationStatus;
  final String? validatedBy;
  final DateTime? validatedAt;
  final String? validationNotes;
  final Map<String, dynamic> performanceMetrics;
  final String? notes;
  final List<String> tags;

  SpectralAnalysis({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.studyAreaId,
    required this.primaryImageId,
    this.secondaryImages = const [],
    required this.pegmatiteType,
    required this.algorithm,
    required this.confidenceThreshold,
    this.processingParameters = const {},
    this.totalDetections = 0,
    this.highConfidenceDetections = 0,
    this.averageConfidence,
    this.analysisDurationSeconds,
    required this.status,
    required this.validationStatus,
    this.validatedBy,
    this.validatedAt,
    this.validationNotes,
    this.performanceMetrics = const {},
    this.notes,
    this.tags = const [],
  });

  factory SpectralAnalysis.fromJson(Map<String, dynamic> json) {
    return SpectralAnalysis(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
      studyAreaId: json['study_area_id'],
      primaryImageId: json['primary_image_id'],
      secondaryImages: List<String>.from(json['secondary_images'] ?? []),
      pegmatiteType: PegmatiteType.values.firstWhere(
            (e) => e.name == json['pegmatite_type'],
        orElse: () => PegmatiteType.feldspathiques,
      ),
      algorithm: AnalysisAlgorithm.values.firstWhere(
            (e) => e.name == json['algorithm'].toString().replaceAll('-', ''),
        orElse: () => AnalysisAlgorithm.kmeans,
      ),
      confidenceThreshold: double.parse(json['confidence_threshold'].toString()),
      processingParameters: json['processing_parameters'] ?? {},
      totalDetections: json['total_detections'] ?? 0,
      highConfidenceDetections: json['high_confidence_detections'] ?? 0,
      averageConfidence: json['average_confidence']?.toDouble(),
      analysisDurationSeconds: json['analysis_duration_seconds'],
      status: AnalysisStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => AnalysisStatus.pending,
      ),
      validationStatus: ValidationStatus.values.firstWhere(
            (e) => e.name == json['validation_status'],
        orElse: () => ValidationStatus.pending,
      ),
      validatedBy: json['validated_by'],
      validatedAt: json['validated_at'] != null ? DateTime.parse(json['validated_at']) : null,
      validationNotes: json['validation_notes'],
      performanceMetrics: json['performance_metrics'] ?? {},
      notes: json['notes'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  String get statusDisplayText {
    switch (status) {
      case AnalysisStatus.pending:
        return 'En attente';
      case AnalysisStatus.running:
        return 'En cours';
      case AnalysisStatus.completed:
        return 'Terminée';
      case AnalysisStatus.failed:
        return 'Échouée';
      case AnalysisStatus.cancelled:
        return 'Annulée';
    }
  }

  String get validationStatusDisplayText {
    switch (validationStatus) {
      case ValidationStatus.pending:
        return 'En attente';
      case ValidationStatus.validated:
        return 'Validé';
      case ValidationStatus.rejected:
        return 'Rejeté';
      case ValidationStatus.needsReview:
        return 'À réviser';
    }
  }
}

class PegmatiteDetection {
  final String id;
  final DateTime createdAt;
  final String analysisId;
  final List<List<LatLng>> geometry; // MultiPolygon
  final LatLng centroid;
  final double areaM2;
  final PegmatiteType pegmatiteType;
  final double confidenceScore;
  final String classificationMethod;
  final Map<String, dynamic> spectralIndices;
  final bool fieldValidated;
  final DateTime? fieldValidationDate;
  final FieldValidationResult? fieldValidationResult;
  final String? fieldNotes;
  final int? detectionRank;
  final int? pixelCount;
  final double? mixedPixelsPercentage;

  PegmatiteDetection({
    required this.id,
    required this.createdAt,
    required this.analysisId,
    required this.geometry,
    required this.centroid,
    required this.areaM2,
    required this.pegmatiteType,
    required this.confidenceScore,
    required this.classificationMethod,
    this.spectralIndices = const {},
    this.fieldValidated = false,
    this.fieldValidationDate,
    this.fieldValidationResult,
    this.fieldNotes,
    this.detectionRank,
    this.pixelCount,
    this.mixedPixelsPercentage,
  });

  factory PegmatiteDetection.fromJson(Map<String, dynamic> json) {
    return PegmatiteDetection(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      analysisId: json['analysis_id'],
      geometry: [], // TODO: Parser MultiPolygon
      centroid: LatLng(0, 0), // TODO: Parser Point
      areaM2: double.parse(json['area_m2'].toString()),
      pegmatiteType: PegmatiteType.values.firstWhere(
            (e) => e.name == json['pegmatite_type'],
        orElse: () => PegmatiteType.feldspathiques,
      ),
      confidenceScore: double.parse(json['confidence_score'].toString()),
      classificationMethod: json['classification_method'],
      spectralIndices: json['spectral_indices'] ?? {},
      fieldValidated: json['field_validated'] ?? false,
      fieldValidationDate: json['field_validation_date'] != null
          ? DateTime.parse(json['field_validation_date'])
          : null,
      fieldValidationResult: json['field_validation_result'] != null
          ? FieldValidationResult.values.firstWhere(
            (e) => e.name == json['field_validation_result'],
        orElse: () => FieldValidationResult.unknown,
      )
          : null,
      fieldNotes: json['field_notes'],
      detectionRank: json['detection_rank'],
      pixelCount: json['pixel_count'],
      mixedPixelsPercentage: json['mixed_pixels_percentage']?.toDouble(),
    );
  }

  bool get isHighConfidence => confidenceScore >= 85.0;

  String get confidenceLevel {
    if (confidenceScore >= 90) return 'Très élevée';
    if (confidenceScore >= 80) return 'Élevée';
    if (confidenceScore >= 70) return 'Moyenne';
    if (confidenceScore >= 60) return 'Faible';
    return 'Très faible';
  }
}

// =============================================
// MODÈLES INDICES SPECTRAUX
// =============================================

class SpectralIndex {
  final String id;
  final DateTime createdAt;
  final String imageId;
  final String? analysisId;
  final SpectralIndexType indexType;
  final List<LatLng> samplePoints;
  final List<double> indexValues;
  final Map<String, dynamic> statistics;
  final Map<String, dynamic> calculationParameters;
  final List<String> bandsUsed;
  final IndexQuality qualityFlag;
  final String? processingNotes;

  SpectralIndex({
    required this.id,
    required this.createdAt,
    required this.imageId,
    this.analysisId,
    required this.indexType,
    required this.samplePoints,
    required this.indexValues,
    this.statistics = const {},
    this.calculationParameters = const {},
    required this.bandsUsed,
    required this.qualityFlag,
    this.processingNotes,
  });

  factory SpectralIndex.fromJson(Map<String, dynamic> json) {
    return SpectralIndex(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      imageId: json['image_id'],
      analysisId: json['analysis_id'],
      indexType: SpectralIndexType.values.firstWhere(
            (e) => e.name == json['index_type'],
        orElse: () => SpectralIndexType.feldspathIndex,
      ),
      samplePoints: [], // TODO: Parser MultiPoint
      indexValues: List<double>.from(json['index_values'].map((v) => v.toDouble())),
      statistics: json['statistics'] ?? {},
      calculationParameters: json['calculation_parameters'] ?? {},
      bandsUsed: List<String>.from(json['bands_used'] ?? []),
      qualityFlag: IndexQuality.values.firstWhere(
            (e) => e.name == json['quality_flag'],
        orElse: () => IndexQuality.good,
      ),
      processingNotes: json['processing_notes'],
    );
  }

  double? get meanValue => statistics['mean']?.toDouble();
  double? get stdValue => statistics['std']?.toDouble();
  double? get minValue => statistics['min']?.toDouble();
  double? get maxValue => statistics['max']?.toDouble();
}

// =============================================
// MODÈLES SYSTÈME
// =============================================

class UserActivity {
  final String id;
  final DateTime timestamp;
  final String userId;
  final ActivityType activityType;
  final String? resourceType;
  final String? resourceId;
  final Map<String, dynamic> actionDetails;
  final String? ipAddress;
  final String? userAgent;
  final String? sessionId;

  UserActivity({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.activityType,
    this.resourceType,
    this.resourceId,
    this.actionDetails = const {},
    this.ipAddress,
    this.userAgent,
    this.sessionId,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user_id'],
      activityType: ActivityType.values.firstWhere(
            (e) => e.name == json['activity_type'],
        orElse: () => ActivityType.login,
      ),
      resourceType: json['resource_type'],
      resourceId: json['resource_id'],
      actionDetails: json['action_details'] ?? {},
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      sessionId: json['session_id'],
    );
  }
}

class SystemSetting {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String updatedBy;
  final String settingKey;
  final dynamic settingValue;
  final SettingType settingType;
  final String? description;
  final bool isPublic;
  final Map<String, dynamic>? validationSchema;

  SystemSetting({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.settingKey,
    required this.settingValue,
    required this.settingType,
    this.description,
    this.isPublic = false,
    this.validationSchema,
  });

  factory SystemSetting.fromJson(Map<String, dynamic> json) {
    return SystemSetting(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      updatedBy: json['updated_by'],
      settingKey: json['setting_key'],
      settingValue: json['setting_value'],
      settingType: SettingType.values.firstWhere(
            (e) => e.name == json['setting_type'],
        orElse: () => SettingType.string,
      ),
      description: json['description'],
      isPublic: json['is_public'] ?? false,
      validationSchema: json['validation_schema'],
    );
  }
}

// =============================================
// ÉNUMÉRATIONS
// =============================================

enum PegmatiteType {
  feldspathiques,
  biotiteMagnetite,
  mixte;

  String get displayName {
    switch (this) {
      case PegmatiteType.feldspathiques:
        return 'Pegmatites Feldspathiques';
      case PegmatiteType.biotiteMagnetite:
        return 'Pegmatites Biotite-Magnétite';
      case PegmatiteType.mixte:
        return 'Pegmatites Mixtes';
    }
  }
}

enum ExplorationStatus {
  pending,
  active,
  completed,
  suspended;

  String get displayName {
    switch (this) {
      case ExplorationStatus.pending:
        return 'En attente';
      case ExplorationStatus.active:
        return 'Active';
      case ExplorationStatus.completed:
        return 'Terminée';
      case ExplorationStatus.suspended:
        return 'Suspendue';
    }
  }
}

enum AccessDifficulty {
  easy,
  medium,
  hard;

  String get displayName {
    switch (this) {
      case AccessDifficulty.easy:
        return 'Facile';
      case AccessDifficulty.medium:
        return 'Moyen';
      case AccessDifficulty.hard:
        return 'Difficile';
    }
  }
}

enum SensorType {
  Landsat8,
  Landsat9,
  Sentinel2,
  ASTER;

  String get displayName {
    switch (this) {
      case SensorType.Landsat8:
        return 'Landsat-8';
      case SensorType.Landsat9:
        return 'Landsat-9';
      case SensorType.Sentinel2:
        return 'Sentinel-2';
      case SensorType.ASTER:
        return 'ASTER';
    }
  }
}

enum ImageQuality {
  poor,
  fair,
  good,
  excellent;

  String get displayName {
    switch (this) {
      case ImageQuality.poor:
        return 'Médiocre';
      case ImageQuality.fair:
        return 'Correcte';
      case ImageQuality.good:
        return 'Bonne';
      case ImageQuality.excellent:
        return 'Excellente';
    }
  }
}

enum ProcessingStatus {
  raw,
  preprocessed,
  processed,
  failed;

  String get displayName {
    switch (this) {
      case ProcessingStatus.raw:
        return 'Brute';
      case ProcessingStatus.preprocessed:
        return 'Prétraitée';
      case ProcessingStatus.processed:
        return 'Traitée';
      case ProcessingStatus.failed:
        return 'Échec';
    }
  }
}

enum AnalysisAlgorithm {
  kmeans,
  randomForest,
  svm;

  String get displayName {
    switch (this) {
      case AnalysisAlgorithm.kmeans:
        return 'K-means';
      case AnalysisAlgorithm.randomForest:
        return 'Random Forest';
      case AnalysisAlgorithm.svm:
        return 'SVM';
    }
  }
}

enum AnalysisStatus {
  pending,
  running,
  completed,
  failed,
  cancelled;

  String get displayName {
    switch (this) {
      case AnalysisStatus.pending:
        return 'En attente';
      case AnalysisStatus.running:
        return 'En cours';
      case AnalysisStatus.completed:
        return 'Terminée';
      case AnalysisStatus.failed:
        return 'Échouée';
      case AnalysisStatus.cancelled:
        return 'Annulée';
    }
  }
}

enum ValidationStatus {
  pending,
  validated,
  rejected,
  needsReview;

  String get displayName {
    switch (this) {
      case ValidationStatus.pending:
        return 'En attente';
      case ValidationStatus.validated:
        return 'Validé';
      case ValidationStatus.rejected:
        return 'Rejeté';
      case ValidationStatus.needsReview:
        return 'À réviser';
    }
  }
}

enum FieldValidationResult {
  confirmed,
  rejected,
  partial,
  unknown;

  String get displayName {
    switch (this) {
      case FieldValidationResult.confirmed:
        return 'Confirmé';
      case FieldValidationResult.rejected:
        return 'Rejeté';
      case FieldValidationResult.partial:
        return 'Partiel';
      case FieldValidationResult.unknown:
        return 'Inconnu';
    }
  }
}

enum SpectralIndexType {
  feldspathIndex,
  ironRatio,
  brightIndex,
  magneticIndex,
  clayIndex,
  ndvi,
  ndwi,
  custom;

  String get displayName {
    switch (this) {
      case SpectralIndexType.feldspathIndex:
        return 'Indice Feldspath';
      case SpectralIndexType.ironRatio:
        return 'Ratio Fer';
      case SpectralIndexType.brightIndex:
        return 'Indice Brillance';
      case SpectralIndexType.magneticIndex:
        return 'Indice Magnétique';
      case SpectralIndexType.clayIndex:
        return 'Indice Argile';
      case SpectralIndexType.ndvi:
        return 'NDVI';
      case SpectralIndexType.ndwi:
        return 'NDWI';
      case SpectralIndexType.custom:
        return 'Personnalisé';
    }
  }
}

enum IndexQuality {
  poor,
  fair,
  good,
  excellent;

  String get displayName {
    switch (this) {
      case IndexQuality.poor:
        return 'Médiocre';
      case IndexQuality.fair:
        return 'Correcte';
      case IndexQuality.good:
        return 'Bonne';
      case IndexQuality.excellent:
        return 'Excellente';
    }
  }
}

enum ActivityType {
  login,
  logout,
  analysisCreated,
  analysisCompleted,
  dataExported,
  settingsChanged,
  validationPerformed;

  String get displayName {
    switch (this) {
      case ActivityType.login:
        return 'Connexion';
      case ActivityType.logout:
        return 'Déconnexion';
      case ActivityType.analysisCreated:
        return 'Analyse créée';
      case ActivityType.analysisCompleted:
        return 'Analyse terminée';
      case ActivityType.dataExported:
        return 'Données exportées';
      case ActivityType.settingsChanged:
        return 'Paramètres modifiés';
      case ActivityType.validationPerformed:
        return 'Validation effectuée';
    }
  }
}

enum SettingType {
  string,
  number,
  boolean,
  object,
  array;
}

// =============================================
// CLASSES UTILITAIRES
// =============================================

class AnalysisStatistics {
  final int totalAnalyses;
  final int completedAnalyses;
  final int totalDetections;
  final double? avgConfidence;
  final double areaAnalyzedKm2;
  final DateTime? lastAnalysisDate;

  AnalysisStatistics({
    required this.totalAnalyses,
    required this.completedAnalyses,
    required this.totalDetections,
    this.avgConfidence,
    required this.areaAnalyzedKm2,
    this.lastAnalysisDate,
  });

  factory AnalysisStatistics.fromJson(Map<String, dynamic> json) {
    return AnalysisStatistics(
      totalAnalyses: json['total_analyses'] ?? 0,
      completedAnalyses: json['completed_analyses'] ?? 0,
      totalDetections: json['total_detections'] ?? 0,
      avgConfidence: json['avg_confidence']?.toDouble(),
      areaAnalyzedKm2: double.parse(json['area_analyzed_km2']?.toString() ?? '0'),
      lastAnalysisDate: json['last_analysis_date'] != null
          ? DateTime.parse(json['last_analysis_date'])
          : null,
    );
  }

  double get completionRate => totalAnalyses > 0 ? completedAnalyses / totalAnalyses : 0;
  double get avgDetectionsPerAnalysis => completedAnalyses > 0 ? totalDetections / completedAnalyses : 0;
}

class AlgorithmPerformance {
  final String algorithm;
  final int totalAnalyses;
  final double? avgConfidence;
  final double? avgDetections;
  final double successRate;

  AlgorithmPerformance({
    required this.algorithm,
    required this.totalAnalyses,
    this.avgConfidence,
    this.avgDetections,
    required this.successRate,
  });

  factory AlgorithmPerformance.fromJson(Map<String, dynamic> json) {
    return AlgorithmPerformance(
      algorithm: json['algorithm'],
      totalAnalyses: json['total_analyses'] ?? 0,
      avgConfidence: json['avg_confidence']?.toDouble(),
      avgDetections: json['avg_detections']?.toDouble(),
      successRate: double.parse(json['success_rate']?.toString() ?? '0'),
    );
  }
}