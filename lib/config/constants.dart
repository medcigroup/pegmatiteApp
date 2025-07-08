// Configuration et constantes de l'application de télédétection des pegmatites

class AppConstants {
  // =============================================
  // INFORMATIONS DE L'APPLICATION
  // =============================================

  static const String appName = 'SODEMI Pegmatites Detection';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Application de télédétection pour l\'exploration des pegmatites en Côte d\'Ivoire';

  // Organisation
  static const String organizationName = 'SODEMI';
  static const String organizationFullName = 'Société pour le Développement Minier de la Côte d\'Ivoire';
  static const String organizationWebsite = 'https://sodemi.ci';

  // Contact et support
  static const String supportEmail = 'support@sodemi.ci';
  static const String technicalEmail = 'tech@sodemi.ci';
  static const String documentationUrl = 'https://docs.sodemi.ci/pegmatites';

  // =============================================
  // CONFIGURATION SUPABASE
  // =============================================

  // URLs Supabase (à remplacer par vos vraies URLs)
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';

  // Buckets de stockage
  static const String satelliteDataBucket = 'satellite-data';
  static const String reportsBucket = 'reports';
  static const String avatarsBucket = 'avatars';

  // =============================================
  // PARAMÈTRES GÉOGRAPHIQUES - CÔTE D'IVOIRE
  // =============================================

  // Emprise géographique de la Côte d'Ivoire
  static const double ivoireCenterLat = 7.5;
  static const double ivoireCenterLng = -5.5;
  static const double ivoireMinLat = 4.3;
  static const double ivoireMaxLat = 10.7;
  static const double ivoireMinLng = -8.6;
  static const double ivoireMaxLng = -2.5;

  // Régions prioritaires pour l'exploration
  static const List<String> priorityRegions = [
    'Bondoukou',
    'Séguéla',
    'Nassian',
    'Katiola',
    'Ferkessédougou',
    'Korhogo',
    'Bouaké',
  ];

  // Zones géologiques importantes
  static const Map<String, Map<String, double>> geologicalZones = {
    'Craton Ouest-Africain': {
      'centerLat': 8.0,
      'centerLng': -3.0,
      'importance': 5.0,
    },
    'Ceinture de roches vertes de Bondoukou': {
      'centerLat': 8.2,
      'centerLng': -2.8,
      'importance': 4.5,
    },
    'Complexe de Séguéla': {
      'centerLat': 7.96,
      'centerLng': -6.67,
      'importance': 4.0,
    },
  };

  // =============================================
  // PARAMÈTRES DE TÉLÉDÉTECTION
  // =============================================

  // Capteurs satellitaires supportés
  static const Map<String, Map<String, dynamic>> supportedSensors = {
    'Landsat-8': {
      'displayName': 'Landsat 8 OLI',
      'resolution': 30.0, // mètres
      'bands': ['Coastal', 'Blue', 'Green', 'Red', 'NIR', 'SWIR1', 'SWIR2', 'Pan', 'Cirrus'],
      'spectralRange': '430-2290 nm',
      'temporalResolution': 16, // jours
      'launchDate': '2013-02-11',
    },
    'Landsat-9': {
      'displayName': 'Landsat 9 OLI-2',
      'resolution': 30.0,
      'bands': ['Coastal', 'Blue', 'Green', 'Red', 'NIR', 'SWIR1', 'SWIR2', 'Pan', 'Cirrus'],
      'spectralRange': '430-2290 nm',
      'temporalResolution': 16,
      'launchDate': '2021-09-27',
    },
    'Sentinel-2': {
      'displayName': 'Sentinel-2 MSI',
      'resolution': 10.0, // mètres (bandes visibles/NIR)
      'bands': ['B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B9', 'B10', 'B11', 'B12'],
      'spectralRange': '443-2190 nm',
      'temporalResolution': 5, // jours
      'launchDate': '2015-06-23',
    },
    'ASTER': {
      'displayName': 'ASTER VNIR/SWIR',
      'resolution': 15.0, // mètres (VNIR)
      'bands': ['B1', 'B2', 'B3N', 'B4', 'B5', 'B6', 'B7', 'B8', 'B9'],
      'spectralRange': '520-2430 nm',
      'temporalResolution': 16,
      'launchDate': '1999-12-18',
    },
  };

  // Indices spectraux pour l'exploration des pegmatites
  static const Map<String, Map<String, dynamic>> spectralIndices = {
    'feldspath_index': {
      'displayName': 'Indice Feldspath',
      'formula': 'SWIR1 / SWIR2',
      'description': 'Détection des feldspaths dans les pegmatites feldspathiques',
      'pegmatiteType': 'feldspathiques',
      'threshold': 1.1,
      'bands': ['SWIR1', 'SWIR2'],
    },
    'iron_ratio': {
      'displayName': 'Ratio Fer',
      'formula': 'RED / NIR',
      'description': 'Identification des oxydes de fer dans les pegmatites à biotite-magnétite',
      'pegmatiteType': 'biotite-magnetite',
      'threshold': 1.3,
      'bands': ['RED', 'NIR'],
    },
    'bright_index': {
      'displayName': 'Indice de Brillance',
      'formula': '(SWIR1 + SWIR2) / 2',
      'description': 'Détection des surfaces claires et altérées',
      'pegmatiteType': 'feldspathiques',
      'threshold': 0.25,
      'bands': ['SWIR1', 'SWIR2'],
    },
    'magnetic_index': {
      'displayName': 'Indice Magnétique',
      'formula': '(RED + NIR) / (GREEN + BLUE)',
      'description': 'Identification des minéraux magnétiques',
      'pegmatiteType': 'biotite-magnetite',
      'threshold': 2.0,
      'bands': ['RED', 'NIR', 'GREEN', 'BLUE'],
    },
    'clay_index': {
      'displayName': 'Indice Argile',
      'formula': 'SWIR1 / SWIR2',
      'description': 'Détection de l\'altération argileuse',
      'pegmatiteType': 'mixte',
      'threshold': 0.9,
      'bands': ['SWIR1', 'SWIR2'],
    },
    'ndvi': {
      'displayName': 'NDVI',
      'formula': '(NIR - RED) / (NIR + RED)',
      'description': 'Indice de végétation normalisé (masquage)',
      'pegmatiteType': 'masque',
      'threshold': 0.3,
      'bands': ['NIR', 'RED'],
    },
  };

  // =============================================
  // PARAMÈTRES D'ANALYSE
  // =============================================

  // Algorithmes de classification supportés
  static const Map<String, Map<String, dynamic>> classificationAlgorithms = {
    'k-means': {
      'displayName': 'K-means',
      'description': 'Classification non supervisée par regroupement',
      'recommendedFor': 'feldspathiques',
      'parameters': {
        'k': 8,
        'maxIterations': 100,
        'tolerance': 0.01,
      },
      'processingTime': 'Rapide',
      'accuracy': 'Moyenne',
    },
    'random-forest': {
      'displayName': 'Random Forest',
      'description': 'Classification supervisée par forêts aléatoires',
      'recommendedFor': 'biotite-magnetite',
      'parameters': {
        'nTrees': 100,
        'maxDepth': 10,
        'minSamplesLeaf': 1,
      },
      'processingTime': 'Moyen',
      'accuracy': 'Élevée',
    },
    'svm': {
      'displayName': 'SVM',
      'description': 'Machine à vecteurs de support',
      'recommendedFor': 'mixte',
      'parameters': {
        'kernel': 'rbf',
        'C': 1.0,
        'gamma': 'scale',
      },
      'processingTime': 'Lent',
      'accuracy': 'Très élevée',
    },
  };

  // Seuils de confiance par défaut
  static const Map<String, double> defaultConfidenceThresholds = {
    'k-means': 0.70,
    'random-forest': 0.75,
    'svm': 0.80,
  };

  // Paramètres de prétraitement
  static const Map<String, dynamic> defaultProcessingParameters = {
    'atmospheric_correction': 'DOS1',
    'spatial_filter': '3x3_median',
    'ndvi_threshold': 0.3,
    'cloud_threshold': 20.0, // Pourcentage maximum de nuages
    'resolution_target': 30.0, // Résolution cible en mètres
  };

  // =============================================
  // LIMITES ET QUOTAS
  // =============================================

  // Limites de fichiers
  static const int maxFileSizeMB = 500;
  static const int maxImagesPerAnalysis = 5;
  static const int maxDetectionsPerAnalysis = 1000;

  // Limites de performance
  static const int maxAnalysisTimeMinutes = 30;
  static const int maxConcurrentAnalyses = 3;
  static const int maxStorageGB = 10;

  // Limites d'interface
  static const int maxResultsPerPage = 50;
  static const int maxRecentActivities = 100;
  static const int maxMapZoomLevel = 18;
  static const int minMapZoomLevel = 5;

  // =============================================
  // PARAMÈTRES D'INTERFACE
  // =============================================

  // Durées d'animation
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration analysisTimeout = Duration(minutes: 30);

  // Intervalles de mise à jour
  static const Duration statusUpdateInterval = Duration(seconds: 5);
  static const Duration mapRefreshInterval = Duration(seconds: 30);
  static const Duration activityRefreshInterval = Duration(minutes: 1);

  // =============================================
  // MESSAGES ET TEXTES
  // =============================================

  // Messages d'erreur
  static const Map<String, String> errorMessages = {
    'network_error': 'Erreur de connexion réseau. Vérifiez votre connexion internet.',
    'auth_error': 'Erreur d\'authentification. Veuillez vous reconnecter.',
    'file_too_large': 'Le fichier est trop volumineux. Taille maximum: ${maxFileSizeMB}MB.',
    'invalid_file_format': 'Format de fichier non supporté.',
    'analysis_timeout': 'L\'analyse a pris trop de temps. Réessayez avec une zone plus petite.',
    'insufficient_data': 'Données insuffisantes pour effectuer l\'analyse.',
    'processing_error': 'Erreur lors du traitement. Contactez le support technique.',
  };

  // Messages de succès
  static const Map<String, String> successMessages = {
    'analysis_completed': 'Analyse terminée avec succès!',
    'data_exported': 'Données exportées avec succès.',
    'settings_saved': 'Paramètres sauvegardés.',
    'validation_completed': 'Validation effectuée.',
    'upload_completed': 'Upload terminé avec succès.',
  };

  // =============================================
  // FORMATS ET UNITÉS
  // =============================================

  // Formats de fichiers supportés
  static const List<String> supportedImageFormats = [
    'GeoTIFF',
    'TIFF',
    'IMG',
    'HDF',
    'NetCDF',
  ];

  static const List<String> supportedExportFormats = [
    'Shapefile',
    'GeoJSON',
    'KML',
    'CSV',
    'Excel',
    'PDF',
  ];

  // Unités de mesure
  static const Map<String, String> units = {
    'area': 'km²',
    'distance': 'm',
    'resolution': 'm/pixel',
    'confidence': '%',
    'coverage': '%',
    'file_size': 'MB',
  };

  // Formats de date
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // =============================================
  // COULEURS ET STYLES
  // =============================================

  // Couleurs des types de pegmatites
  static const Map<String, int> pegmatiteColors = {
    'feldspathiques': 0xFF795548, // Brun
    'biotite-magnetite': 0xFF424242, // Gris foncé
    'mixte': 0xFF9C27B0, // Violet
  };

  // Couleurs des statuts
  static const Map<String, int> statusColors = {
    'pending': 0xFFFFC107, // Amber
    'active': 0xFF2196F3, // Blue
    'running': 0xFF4CAF50, // Green
    'completed': 0xFF4CAF50, // Green
    'failed': 0xFFF44336, // Red
    'cancelled': 0xFF9E9E9E, // Grey
    'suspended': 0xFFFF9800, // Orange
  };

  // Couleurs de confiance
  static const Map<String, int> confidenceColors = {
    'very_high': 0xFF4CAF50, // Vert
    'high': 0xFF8BC34A, // Vert clair
    'medium': 0xFFFFC107, // Jaune
    'low': 0xFFFF9800, // Orange
    'very_low': 0xFFF44336, // Rouge
  };

  // =============================================
  // MÉTADONNÉES DE DÉVELOPPEMENT
  // =============================================

  // Informations de build
  static const String buildDate = '2025-01-15';
  static const String minFlutterVersion = '3.10.0';
  static const String targetPlatform = 'web';

  // URLs de développement
  static const String githubRepository = 'https://github.com/sodemi/pegmatites-detection';
  static const String issueTracker = 'https://github.com/sodemi/pegmatites-detection/issues';
  static const String apiDocumentation = 'https://api.sodemi.ci/docs';

  // Environnements
  static const Map<String, Map<String, String>> environments = {
    'development': {
      'name': 'Développement',
      'supabaseUrl': 'https://dev-project.supabase.co',
      'apiUrl': 'https://dev-api.sodemi.ci',
    },
    'staging': {
      'name': 'Test',
      'supabaseUrl': 'https://staging-project.supabase.co',
      'apiUrl': 'https://staging-api.sodemi.ci',
    },
    'production': {
      'name': 'Production',
      'supabaseUrl': 'https://prod-project.supabase.co',
      'apiUrl': 'https://api.sodemi.ci',
    },
  };

  // =============================================
  // MÉTHODES UTILITAIRES
  // =============================================

  /// Obtenir la couleur d'un type de pegmatite
  static int getPegmatiteColor(String type) {
    return pegmatiteColors[type] ?? pegmatiteColors['mixte']!;
  }

  /// Obtenir la couleur d'un statut
  static int getStatusColor(String status) {
    return statusColors[status] ?? statusColors['pending']!;
  }

  /// Obtenir la couleur basée sur la confiance
  static int getConfidenceColor(double confidence) {
    if (confidence >= 90) return confidenceColors['very_high']!;
    if (confidence >= 80) return confidenceColors['high']!;
    if (confidence >= 70) return confidenceColors['medium']!;
    if (confidence >= 60) return confidenceColors['low']!;
    return confidenceColors['very_low']!;
  }

  /// Vérifier si un fichier est supporté
  static bool isSupportedImageFormat(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return supportedImageFormats.any(
            (format) => format.toLowerCase().contains(extension)
    );
  }

  /// Obtenir l'algorithme recommandé pour un type de pegmatite
  static String getRecommendedAlgorithm(String pegmatiteType) {
    for (final entry in classificationAlgorithms.entries) {
      if (entry.value['recommendedFor'] == pegmatiteType) {
        return entry.key;
      }
    }
    return 'k-means'; // Défaut
  }

  /// Vérifier si une position est en Côte d'Ivoire
  static bool isInIvoryCoast(double lat, double lng) {
    return lat >= ivoireMinLat &&
        lat <= ivoireMaxLat &&
        lng >= ivoireMinLng &&
        lng <= ivoireMaxLng;
  }

  /// Obtenir la région la plus proche d'une position
  static String? getNearestRegion(double lat, double lng) {
    if (!isInIvoryCoast(lat, lng)) return null;

    // Logique simplifiée - dans une vraie app, utiliser une base de données spatiale
    if (lat > 8.5 && lng > -3.5) return 'Bondoukou';
    if (lat > 7.5 && lat < 8.5 && lng < -6.0) return 'Séguéla';
    if (lat > 9.0 && lng > -3.5) return 'Nassian';
    if (lat > 7.5 && lat < 8.5 && lng > -5.0 && lng < -4.0) return 'Katiola';

    return priorityRegions.first; // Défaut
  }
}

// =============================================
// ÉNUMÉRATIONS DE CONSTANTES
// =============================================

enum AppEnvironment {
  development,
  staging,
  production;

  String get name {
    switch (this) {
      case AppEnvironment.development:
        return 'Développement';
      case AppEnvironment.staging:
        return 'Test';
      case AppEnvironment.production:
        return 'Production';
    }
  }
}

enum SupportedLanguage {
  french('fr', 'Français'),
  english('en', 'English');

  const SupportedLanguage(this.code, this.displayName);

  final String code;
  final String displayName;
}

enum ExportFormat {
  shapefile('shp', 'Shapefile'),
  geojson('json', 'GeoJSON'),
  kml('kml', 'KML'),
  csv('csv', 'CSV'),
  excel('xlsx', 'Excel'),
  pdf('pdf', 'PDF');

  const ExportFormat(this.extension, this.displayName);

  final String extension;
  final String displayName;
}

enum MapProvider {
  openStreetMap('OpenStreetMap'),
  satelliteImagery('Imagerie Satellite'),
  topographic('Topographique'),
  hybrid('Hybride');

  const MapProvider(this.displayName);

  final String displayName;
}