import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec salutation
            _buildHeader(userProfile),

            const SizedBox(height: 32),

            // Statistiques principales
            _buildStatsCards(),

            const SizedBox(height: 32),

            // Contenu principal en deux colonnes
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colonne gauche (2/3)
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildRecentAnalyses(),
                      const SizedBox(height: 24),
                      _buildActiveProjects(),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Colonne droite (1/3)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildSystemStatus(),
                      const SizedBox(height: 24),
                      _buildRecentActivity(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue<Map<String, dynamic>?> userProfile) {
    return userProfile.when(
      data: (profile) {
        final name = profile?['full_name'] ?? 'Utilisateur';
        final organization = profile?['organization'] ?? 'SODEMI';
        final role = profile?['role'] ?? 'Géologue';

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, ${name.split(' ').first}! 👋',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$role - $organization',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Indicateur météo (important pour l'acquisition satellite)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud,
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conditions satellite',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Optimales (12% nuages)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Erreur de chargement du profil'),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Zones Analysées',
            value: '12',
            subtitle: '+3 ce mois',
            icon: Icons.map,
            color: AppTheme.primaryColor,
            trend: 0.25,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Pegmatites Détectées',
            value: '47',
            subtitle: '85% précision',
            icon: Icons.location_on,
            color: AppTheme.secondaryColor,
            trend: 0.15,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Images Traitées',
            value: '156',
            subtitle: 'Cette semaine',
            icon: Icons.satellite_alt,
            color: AppTheme.accentColor,
            trend: -0.05,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Temps Gagné',
            value: '89%',
            subtitle: 'vs méthodes traditionnelles',
            icon: Icons.speed,
            color: Colors.green,
            trend: 0.35,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double trend,
  }) {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trend > 0 ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trend > 0 ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: trend > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${(trend * 100).abs().toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: trend > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
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

  Widget _buildRecentAnalyses() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Analyses Récentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {}, // Navigate to full analysis page
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Liste des analyses récentes
          ...List.generate(3, (index) {
            final analyses = [
              {
                'zone': 'Bondoukou-Nord',
                'type': 'Pegmatites feldspathiques',
                'date': '2025-01-15',
                'status': 'Complétée',
                'confidence': 89,
                'detections': 12,
              },
              {
                'zone': 'Séguéla-Est',
                'type': 'Pegmatites biotite-magnétite',
                'date': '2025-01-14',
                'status': 'En cours',
                'confidence': 76,
                'detections': 8,
              },
              {
                'zone': 'Nassian-Ouest',
                'type': 'Pegmatites feldspathiques',
                'date': '2025-01-13',
                'status': 'Complétée',
                'confidence': 92,
                'detections': 15,
              },
            ];

            return _buildAnalysisItem(analyses[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildAnalysisItem(Map<String, dynamic> analysis) {
    Color statusColor;
    switch (analysis['status']) {
      case 'Complétée':
        statusColor = Colors.green;
        break;
      case 'En cours':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icône du type de pegmatite
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: analysis['type'].contains('feldspathiques')
                  ? AppTheme.feldspathColor.withOpacity(0.1)
                  : AppTheme.biotiteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              analysis['type'].contains('feldspathiques')
                  ? Icons.diamond_outlined
                  : Icons.grain,
              color: analysis['type'].contains('feldspathiques')
                  ? AppTheme.feldspathColor
                  : AppTheme.biotiteColor,
            ),
          ),

          const SizedBox(width: 12),

          // Informations de l'analyse
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis['zone'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  analysis['type'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${analysis['date']}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Métriques
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  analysis['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${analysis['confidence']}% confiance',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${analysis['detections']} détections',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProjects() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Projets Actifs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildProjectItem(
            'Exploration Bondoukou-Nassian',
            'Phase 2: Validation terrain',
            75,
            AppTheme.primaryColor,
          ),
          const SizedBox(height: 12),
          _buildProjectItem(
            'Cartographie Séguéla',
            'Acquisition données Sentinel-2',
            45,
            AppTheme.accentColor,
          ),
          const SizedBox(height: 12),
          _buildProjectItem(
            'Formation équipes SODEMI',
            'Module télédétection avancée',
            90,
            AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(String title, String subtitle, int progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$progress%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions Rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildActionButton(
            icon: Icons.add_location_alt,
            title: 'Nouvelle Analyse',
            subtitle: 'Démarrer une analyse spectrale',
            color: AppTheme.primaryColor,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.upload_file,
            title: 'Importer Images',
            subtitle: 'Ajouter des données satellite',
            color: AppTheme.accentColor,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.assessment,
            title: 'Générer Rapport',
            subtitle: 'Exporter les résultats',
            color: AppTheme.secondaryColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
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
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'État du Système',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildStatusItem('Base de données', true),
          _buildStatusItem('API Supabase', true),
          _buildStatusItem('Serveur de calcul', true),
          _buildStatusItem('Acquisition satellite', false),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String service, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              service,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            isOnline ? 'En ligne' : 'Hors ligne',
            style: TextStyle(
              fontSize: 11,
              color: isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activité Récente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildActivityItem(
            'Analyse terminée',
            'Bondoukou-Nord',
            '2h',
            Icons.check_circle,
            Colors.green,
          ),
          _buildActivityItem(
            'Images importées',
            'Sentinel-2 - Séguéla',
            '4h',
            Icons.cloud_download,
            AppTheme.accentColor,
          ),
          _buildActivityItem(
            'Rapport généré',
            'Pegmatites Q4 2024',
            '6h',
            Icons.description,
            AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String action,
      String details,
      String time,
      IconData icon,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}