import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'tous';
  String _sortBy = 'date_desc';

  // Données simulées des résultats d'analyses
  final List<AnalysisResult> _results = [
    AnalysisResult(
      id: '1',
      zoneName: 'Bondoukou-Nord',
      pegmatiteType: 'Feldspathiques',
      analysisDate: DateTime(2025, 1, 15),
      algorithm: 'K-means',
      confidence: 89.2,
      detectionsCount: 23,
      area: 125.5,
      status: 'Validé',
      operator: 'Dr. Kouassi Jean',
    ),
    AnalysisResult(
      id: '2',
      zoneName: 'Séguéla-Est',
      pegmatiteType: 'Biotite-Magnétite',
      analysisDate: DateTime(2025, 1, 14),
      algorithm: 'Random Forest',
      confidence: 76.8,
      detectionsCount: 18,
      area: 89.3,
      status: 'En révision',
      operator: 'Dr. Touré Awa',
    ),
    AnalysisResult(
      id: '3',
      zoneName: 'Nassian-Ouest',
      pegmatiteType: 'Feldspathiques',
      analysisDate: DateTime(2025, 1, 13),
      algorithm: 'K-means',
      confidence: 92.1,
      detectionsCount: 31,
      area: 156.7,
      status: 'Validé',
      operator: 'Dr. Kouassi Jean',
    ),
    AnalysisResult(
      id: '4',
      zoneName: 'Bondoukou-Sud',
      pegmatiteType: 'Feldspathiques',
      analysisDate: DateTime(2025, 1, 12),
      algorithm: 'K-means',
      confidence: 68.4,
      detectionsCount: 12,
      area: 78.2,
      status: 'Rejeté',
      operator: 'Dr. Traoré Moussa',
    ),
    AnalysisResult(
      id: '5',
      zoneName: 'Katiola-Nord',
      pegmatiteType: 'Biotite-Magnétite',
      analysisDate: DateTime(2025, 1, 11),
      algorithm: 'Random Forest',
      confidence: 84.6,
      detectionsCount: 27,
      area: 134.8,
      status: 'Validé',
      operator: 'Dr. Touré Awa',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header avec titre et actions
          _buildHeader(),

          // Onglets
          _buildTabBar(),

          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResultsList(),
                _buildStatisticsView(),
                _buildExportsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assessment,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résultats d\'Analyses',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_getFilteredResults().length} analyses trouvées',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          // Actions rapides
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _exportResults,
                icon: const Icon(Icons.download),
                label: const Text('Exporter'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _createNewAnalysis,
                icon: const Icon(Icons.add),
                label: const Text('Nouvelle Analyse'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: AppTheme.primaryColor,
        tabs: const [
          Tab(text: 'Liste des Résultats'),
          Tab(text: 'Statistiques'),
          Tab(text: 'Exports & Rapports'),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        // Filtres et tri
        _buildFiltersSection(),

        // Liste des résultats
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _getFilteredResults().length,
            itemBuilder: (context, index) {
              final result = _getFilteredResults()[index];
              return _buildResultCard(result);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Filtre par type
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Filtrer par type',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'tous', child: Text('Tous les types')),
                DropdownMenuItem(value: 'feldspathiques', child: Text('Pegmatites Feldspathiques')),
                DropdownMenuItem(value: 'biotite-magnetite', child: Text('Biotite-Magnétite')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value ?? 'tous';
                });
              },
            ),
          ),

          const SizedBox(width: 16),

          // Tri
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Trier par',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'date_desc', child: Text('Date (récent)')),
                DropdownMenuItem(value: 'date_asc', child: Text('Date (ancien)')),
                DropdownMenuItem(value: 'confidence_desc', child: Text('Confiance (élevée)')),
                DropdownMenuItem(value: 'confidence_asc', child: Text('Confiance (faible)')),
                DropdownMenuItem(value: 'detections_desc', child: Text('Détections (plus)')),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value ?? 'date_desc';
                });
              },
            ),
          ),

          const SizedBox(width: 16),

          // Recherche
          SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher une zone...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Implémenter la recherche
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(AnalysisResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Header de la carte
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icône du type de pegmatite
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPegmatiteColor(result.pegmatiteType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    result.pegmatiteType.contains('Feldspathiques')
                        ? Icons.diamond_outlined
                        : Icons.grain,
                    color: _getPegmatiteColor(result.pegmatiteType),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Informations principales
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            result.zoneName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildStatusChip(result.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.pegmatiteType,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Analysé le ${_formatDate(result.analysisDate)} par ${result.operator}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Score de confiance
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(result.confidence).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${result.confidence.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _getConfidenceColor(result.confidence),
                        ),
                      ),
                      const Text(
                        'Confiance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Métriques
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                _buildMetric('Détections', '${result.detectionsCount}', Icons.location_on),
                const SizedBox(width: 32),
                _buildMetric('Superficie', '${result.area.toStringAsFixed(1)} km²', Icons.map),
                const SizedBox(width: 32),
                _buildMetric('Algorithme', result.algorithm, Icons.psychology),
                const Spacer(),
                Text(
                  'ID: ${result.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _viewDetails(result),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Voir détails'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _viewOnMap(result),
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Voir sur carte'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _exportResult(result),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Exporter'),
                ),
                const Spacer(),
                if (result.status != 'Validé')
                  ElevatedButton.icon(
                    onPressed: () => _validateResult(result),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Valider'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Validé':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'En révision':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'Rejeté':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vue d'ensemble
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Analyses',
                  '${_results.length}',
                  'Ce mois',
                  Icons.analytics,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Détections Totales',
                  '${_results.map((r) => r.detectionsCount).reduce((a, b) => a + b)}',
                  'Toutes zones',
                  Icons.location_on,
                  AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Confiance Moyenne',
                  '${(_results.map((r) => r.confidence).reduce((a, b) => a + b) / _results.length).toStringAsFixed(1)}%',
                  'Toutes analyses',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Zone Totale',
                  '${_results.map((r) => r.area).reduce((a, b) => a + b).toStringAsFixed(0)} km²',
                  'Analysée',
                  Icons.map,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Graphiques
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Répartition par type
              Expanded(
                child: _buildChartCard(
                  'Répartition par Type de Pegmatite',
                  _buildPieChart(),
                ),
              ),
              const SizedBox(width: 24),
              // Évolution temporelle
              Expanded(
                child: _buildChartCard(
                  'Évolution des Analyses',
                  _buildLineChart(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Performance par algorithme
          _buildPerformanceTable(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Graphique en secteurs\n(Feldspathiques vs Biotite-Magnétite)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Graphique temporel\n(Nombre d\'analyses par jour)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPerformanceTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance par Algorithme',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Table(
            border: TableBorder.all(color: Colors.grey.shade200),
            children: [
              const TableRow(
                decoration: BoxDecoration(color: AppTheme.backgroundColor),
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Algorithme', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Analyses', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Confiance Moy.', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Détections', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('K-means'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${_results.where((r) => r.algorithm == 'K-means').length}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${_getAverageConfidence('K-means').toStringAsFixed(1)}%'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${_getTotalDetections('K-means')}'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Random Forest'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${_results.where((r) => r.algorithm == 'Random Forest').length}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${_getAverageConfidence('Random Forest').toStringAsFixed(1)}%'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${_getTotalDetections('Random Forest')}'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exports rapides
          const Text(
            'Exports Rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildExportCard(
                  'Rapport Mensuel',
                  'Export complet des analyses du mois',
                  Icons.description,
                  AppTheme.primaryColor,
                      () => _exportMonthlyReport(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildExportCard(
                  'Données GIS',
                  'Shapefile des zones et détections',
                  Icons.map,
                  AppTheme.accentColor,
                      () => _exportGISData(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildExportCard(
                  'Base de Données',
                  'Export CSV de toutes les analyses',
                  Icons.table_chart,
                  AppTheme.secondaryColor,
                      () => _exportDatabase(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Rapports personnalisés
          const Text(
            'Rapports Personnalisés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Générateur de Rapports',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Configuration du rapport
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Période'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            items: const [
                              DropdownMenuItem(value: 'week', child: Text('Cette semaine')),
                              DropdownMenuItem(value: 'month', child: Text('Ce mois')),
                              DropdownMenuItem(value: 'quarter', child: Text('Ce trimestre')),
                              DropdownMenuItem(value: 'custom', child: Text('Période personnalisée')),
                            ],
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Format'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            items: const [
                              DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                              DropdownMenuItem(value: 'docx', child: Text('Word')),
                              DropdownMenuItem(value: 'xlsx', child: Text('Excel')),
                            ],
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sections à inclure
                const Text('Sections à inclure'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildCheckboxChip('Résumé exécutif', true),
                    _buildCheckboxChip('Statistiques détaillées', true),
                    _buildCheckboxChip('Cartographie', true),
                    _buildCheckboxChip('Recommandations', false),
                    _buildCheckboxChip('Annexes techniques', false),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _generateCustomReport,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Générer le Rapport'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Gérer la sélection
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  // Méthodes utilitaires
  List<AnalysisResult> _getFilteredResults() {
    var filtered = _results.where((result) {
      if (_selectedFilter == 'tous') return true;
      if (_selectedFilter == 'feldspathiques') {
        return result.pegmatiteType.contains('Feldspathiques');
      }
      if (_selectedFilter == 'biotite-magnetite') {
        return result.pegmatiteType.contains('Biotite');
      }
      return true;
    }).toList();

    // Appliquer le tri
    switch (_sortBy) {
      case 'date_desc':
        filtered.sort((a, b) => b.analysisDate.compareTo(a.analysisDate));
        break;
      case 'date_asc':
        filtered.sort((a, b) => a.analysisDate.compareTo(b.analysisDate));
        break;
      case 'confidence_desc':
        filtered.sort((a, b) => b.confidence.compareTo(a.confidence));
        break;
      case 'confidence_asc':
        filtered.sort((a, b) => a.confidence.compareTo(b.confidence));
        break;
      case 'detections_desc':
        filtered.sort((a, b) => b.detectionsCount.compareTo(a.detectionsCount));
        break;
    }

    return filtered;
  }

  Color _getPegmatiteColor(String type) {
    return type.contains('Feldspathiques') ? AppTheme.feldspathColor : AppTheme.biotiteColor;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 85) return Colors.green;
    if (confidence >= 70) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  double _getAverageConfidence(String algorithm) {
    final filtered = _results.where((r) => r.algorithm == algorithm);
    if (filtered.isEmpty) return 0;
    return filtered.map((r) => r.confidence).reduce((a, b) => a + b) / filtered.length;
  }

  int _getTotalDetections(String algorithm) {
    return _results
        .where((r) => r.algorithm == algorithm)
        .map((r) => r.detectionsCount)
        .fold(0, (a, b) => a + b);
  }

  // Actions
  void _viewDetails(AnalysisResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails - ${result.zoneName}'),
        content: Text('Affichage des détails complets de l\'analyse ${result.id}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _viewOnMap(AnalysisResult result) {
    // Navigation vers la page d'analyse avec cette zone
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ouverture de ${result.zoneName} sur la carte')),
    );
  }

  void _exportResult(AnalysisResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export de l\'analyse ${result.id} en cours...')),
    );
  }

  void _validateResult(AnalysisResult result) {
    setState(() {
      result.status = 'Validé';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analyse ${result.id} validée avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export global en cours...')),
    );
  }

  void _createNewAnalysis() {
    // Navigation vers la page d'analyse
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirection vers nouvelle analyse...')),
    );
  }

  void _exportMonthlyReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Génération du rapport mensuel...')),
    );
  }

  void _exportGISData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export des données GIS...')),
    );
  }

  void _exportDatabase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export de la base de données...')),
    );
  }

  void _generateCustomReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Génération du rapport personnalisé...')),
    );
  }
}

// Modèle pour les résultats d'analyse
class AnalysisResult {
  final String id;
  final String zoneName;
  final String pegmatiteType;
  final DateTime analysisDate;
  final String algorithm;
  final double confidence;
  final int detectionsCount;
  final double area;
  String status;
  final String operator;

  AnalysisResult({
    required this.id,
    required this.zoneName,
    required this.pegmatiteType,
    required this.analysisDate,
    required this.algorithm,
    required this.confidence,
    required this.detectionsCount,
    required this.area,
    required this.status,
    required this.operator,
  });
}