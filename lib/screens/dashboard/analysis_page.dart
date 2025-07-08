import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../config/theme.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  final MapController _mapController = MapController();
  String _selectedPegmatiteType = 'feldspathiques';
  String _selectedAlgorithm = 'k-means';
  bool _isAnalyzing = false;
  double _confidenceThreshold = 0.75;

  // Données simulées pour les zones d'étude
  final List<StudyZone> _studyZones = [
    StudyZone(
      name: 'Bondoukou-Nord',
      bounds: LatLngBounds(
        LatLng(8.0, -2.5),
        LatLng(8.5, -2.0),
      ),
      pegmatiteType: 'feldspathiques',
      status: 'active',
    ),
    StudyZone(
      name: 'Séguéla-Est',
      bounds: LatLngBounds(
        LatLng(7.8, -6.8),
        LatLng(8.2, -6.2),
      ),
      pegmatiteType: 'biotite-magnétite',
      status: 'pending',
    ),
    StudyZone(
      name: 'Nassian-Ouest',
      bounds: LatLngBounds(
        LatLng(9.2, -3.2),
        LatLng(9.6, -2.8),
      ),
      pegmatiteType: 'feldspathiques',
      status: 'completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Panneau de contrôle gauche
          Container(
            width: 350,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: _buildControlPanel(),
          ),

          // Vue carte principale
          Expanded(
            child: Column(
              children: [
                // Toolbar de la carte
                _buildMapToolbar(),

                // Carte interactive
                Expanded(
                  child: _buildInteractiveMap(),
                ),
              ],
            ),
          ),

          // Panneau des résultats droite
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(-2, 0),
                ),
              ],
            ),
            child: _buildResultsPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Analyse Spectrale',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Configuration du type de pegmatite
          _buildSection(
            title: 'Type de Pegmatite',
            child: Column(
              children: [
                _buildRadioOption(
                  'feldspathiques',
                  'Pegmatites Feldspathiques',
                  'Li-Cs-Ta-Nb, indices: Feldspath + Bright',
                  AppTheme.feldspathColor,
                ),
                const SizedBox(height: 8),
                _buildRadioOption(
                  'biotite-magnétite',
                  'Pegmatites Biotite-Magnétite',
                  'REE-Ti-P, indices: Iron Ratio + Magnetic',
                  AppTheme.biotiteColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Configuration de l'algorithme
          _buildSection(
            title: 'Algorithme de Classification',
            child: DropdownButtonFormField<String>(
              value: _selectedAlgorithm,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'k-means',
                  child: Text('K-means (Pegmatites feldspathiques)'),
                ),
                DropdownMenuItem(
                  value: 'random-forest',
                  child: Text('Random Forest (Biotite-magnétite)'),
                ),
                DropdownMenuItem(
                  value: 'svm',
                  child: Text('SVM (Expérimental)'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedAlgorithm = value ?? 'k-means';
                });
              },
            ),
          ),

          const SizedBox(height: 24),

          // Seuil de confiance
          _buildSection(
            title: 'Seuil de Confiance',
            child: Column(
              children: [
                Slider(
                  value: _confidenceThreshold,
                  min: 0.5,
                  max: 0.95,
                  divisions: 9,
                  label: '${(_confidenceThreshold * 100).toInt()}%',
                  onChanged: (value) {
                    setState(() {
                      _confidenceThreshold = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '50%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${(_confidenceThreshold * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '95%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Paramètres avancés
          _buildSection(
            title: 'Paramètres Avancés',
            child: Column(
              children: [
                _buildParameterRow('Masquage végétation', 'NDVI > 0.3'),
                _buildParameterRow('Correction atmosphérique', 'DOS1'),
                _buildParameterRow('Filtrage spatial', '3x3 médian'),
                _buildParameterRow('Résolution analyse', '30m/pixel'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Bouton d'analyse
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _startAnalysis,
              icon: _isAnalyzing
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Icon(Icons.play_arrow),
              label: Text(_isAnalyzing ? 'Analyse en cours...' : 'Démarrer l\'Analyse'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),

          if (_isAnalyzing) ...[
            const SizedBox(height: 16),
            _buildAnalysisProgress(),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildRadioOption(
      String value,
      String title,
      String description,
      Color color,
      ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPegmatiteType = value;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedPegmatiteType == value
                ? AppTheme.primaryColor
                : Colors.grey.shade300,
            width: _selectedPegmatiteType == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _selectedPegmatiteType == value
              ? AppTheme.primaryColor.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPegmatiteType,
              onChanged: (newValue) {
                setState(() {
                  _selectedPegmatiteType = newValue ?? value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progression de l\'analyse',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            value: 0.65,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Étape 3/5: Classification des pixels',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapToolbar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Cartographie Interactive',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Couches de base
          DropdownButton<String>(
            value: 'satellite',
            items: const [
              DropdownMenuItem(value: 'satellite', child: Text('Vue satellite')),
              DropdownMenuItem(value: 'terrain', child: Text('Terrain')),
              DropdownMenuItem(value: 'osm', child: Text('OpenStreetMap')),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(width: 16),

          // Outils de carte
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: () {
              _mapController.move(LatLng(8.0, -5.0), 7.0);
            },
            tooltip: 'Centrer sur la Côte d\'Ivoire',
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showLayersDialog,
            tooltip: 'Gestion des couches',
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {},
            tooltip: 'Plein écran',
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(8.0, -5.0), // Centré sur la Côte d'Ivoire
        initialZoom: 7.0,
        minZoom: 5.0,
        maxZoom: 15.0,
        onTap: (tapPosition, point) {
          // Gérer les clics sur la carte pour ajouter des zones d'intérêt
        },
      ),
      children: [
        // Couche de base
        TileLayer(
          urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.sodemi.pegmatites_detection',
        ),

        // Zones d'étude
        PolygonLayer(
          polygons: _studyZones.map((zone) => Polygon(
            points: [
              zone.bounds.southWest,
              LatLng(zone.bounds.southWest.latitude, zone.bounds.northEast.longitude),
              zone.bounds.northEast,
              LatLng(zone.bounds.northEast.latitude, zone.bounds.southWest.longitude),
            ],
            color: _getZoneColor(zone).withOpacity(0.3),
            borderColor: _getZoneColor(zone),
            borderStrokeWidth: 2,
          )).toList(),
        ),

        // Marqueurs des zones
        MarkerLayer(
          markers: _studyZones.map((zone) => Marker(
            point: zone.bounds.center,
            child: _buildZoneMarker(zone),
          )).toList(),
        ),

        // Couche d'indices spectraux (simulée)
        if (_isAnalyzing)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.transparent.withOpacity(0.7),
              BlendMode.multiply,
            ),
            child: TileLayer(
              urlTemplate: 'https://example.com/spectral-indices/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.sodemi.pegmatites_detection',
            ),
          ),
      ],
    );
  }

  Widget _buildZoneMarker(StudyZone zone) {
    return GestureDetector(
      onTap: () {
        _showZoneDetails(zone);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getZoneColor(zone), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          zone.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _getZoneColor(zone),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Résultats de l\'Analyse',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Métriques de performance
          _buildMetricCard('Précision Globale', '87.5%', Icons.settings_remote, Colors.green),
          const SizedBox(height: 12),
          _buildMetricCard('Zones Détectées', '23', Icons.location_on, AppTheme.primaryColor),
          const SizedBox(height: 12),
          _buildMetricCard('Confiance Moy.', '82.1%', Icons.trending_up, AppTheme.accentColor),
          const SizedBox(height: 12),
          _buildMetricCard('Temps Traitement', '4m 32s', Icons.timer, AppTheme.secondaryColor),

          const SizedBox(height: 24),

          // Histogramme des indices spectraux
          _buildSpectralChart(),

          const SizedBox(height: 24),

          // Liste des détections
          _buildDetectionsList(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpectralChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Indices Spectraux',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Graphique des indices spectraux\n(Feldspath Index, Iron Ratio, etc.)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détections Récentes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Liste des détections simulées
          ...List.generate(5, (index) {
            final detections = [
              {'lat': 8.234, 'lon': -2.456, 'confidence': 0.89, 'type': 'Feldspathique'},
              {'lat': 8.187, 'lon': -2.378, 'confidence': 0.76, 'type': 'Biotite-Magnétite'},
              {'lat': 8.298, 'lon': -2.512, 'confidence': 0.92, 'type': 'Feldspathique'},
              {'lat': 8.156, 'lon': -2.334, 'confidence': 0.68, 'type': 'Biotite-Magnétite'},
              {'lat': 8.267, 'lon': -2.445, 'confidence': 0.84, 'type': 'Feldspathique'},
            ];

            return _buildDetectionItem(detections[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildDetectionItem(Map<String, dynamic> detection) {
    final confidence = detection['confidence'] as double;
    final isHighConfidence = confidence > 0.8;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isHighConfidence ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${detection['lat']}, ${detection['lon']}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detection['type'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(confidence * 100).toInt()}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isHighConfidence ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Color _getZoneColor(StudyZone zone) {
    switch (zone.status) {
      case 'active':
        return AppTheme.primaryColor;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _startAnalysis() {
    setState(() {
      _isAnalyzing = true;
    });

    // Simuler l'analyse
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analyse terminée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _showLayersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gestion des Couches'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Zones d\'étude'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Indices spectraux'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Résultats classification'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Masque végétation'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showZoneDetails(StudyZone zone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(zone.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${zone.pegmatiteType}'),
            Text('Statut: ${zone.status}'),
            Text('Superficie: ${_calculateArea(zone.bounds).toStringAsFixed(1)} km²'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _fitBounds(zone.bounds);
            },
            child: const Text('Zoomer'),
          ),
        ],
      ),
    );
  }

  void _fitBounds(LatLngBounds bounds) {
    // Nouvelle méthode pour ajuster la vue de la carte aux limites
    final center = bounds.center;
    final zoom = _calculateZoomLevel(bounds);
    _mapController.move(center, zoom);
  }

  double _calculateZoomLevel(LatLngBounds bounds) {
    // Calcul simple du niveau de zoom basé sur les dimensions
    final latDiff = bounds.northEast.latitude - bounds.southWest.latitude;
    final lonDiff = bounds.northEast.longitude - bounds.southWest.longitude;
    final maxDiff = latDiff > lonDiff ? latDiff : lonDiff;

    if (maxDiff > 2) return 6;
    if (maxDiff > 1) return 7;
    if (maxDiff > 0.5) return 8;
    if (maxDiff > 0.2) return 9;
    return 10;
  }

  double _calculateArea(LatLngBounds bounds) {
    // Calcul approximatif de la superficie en km²
    final latDiff = bounds.northEast.latitude - bounds.southWest.latitude;
    final lonDiff = bounds.northEast.longitude - bounds.southWest.longitude;
    return latDiff * lonDiff * 111 * 111; // Approximation
  }
}

// Modèle pour les zones d'étude
class StudyZone {
  final String name;
  final LatLngBounds bounds;
  final String pegmatiteType;
  final String status;

  StudyZone({
    required this.name,
    required this.bounds,
    required this.pegmatiteType,
    required this.status,
  });
}