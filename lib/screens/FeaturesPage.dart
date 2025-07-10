import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({Key? key}) : super(key: key);

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 768 && size.width <= 1200;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Row(
          children: [
            // Logo SODEMI responsive
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Taille du logo basée sur la taille du container
                  final logoSize = (constraints.maxWidth - 16).clamp(
                    16.0,
                    32.0,
                  );

                  return Image.asset(
                    'assets/images/logo.gif',
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.terrain,
                        color: Colors.white,
                        size: logoSize,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'SODEMI Pegmatites APP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('Accueil'),
          ),
          TextButton(
            onPressed: () => context.go('/auth/login'),
            child: const Text('Connexion'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.go('/auth/register'),
            child: const Text('Inscription'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(context, isDesktop),

            // Main Features Section
            _buildMainFeaturesSection(context, isDesktop),

            // Technical Features Section
            _buildTechnicalFeaturesSection(context, isDesktop),

            // Workflow Section
            _buildWorkflowSection(context, isDesktop),

            // Benefits Section
            _buildBenefitsSection(context, isDesktop),

            // CTA Section
            _buildCTASection(context, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24,
          vertical: 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fonctionnalités Avancées',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Text(
                'Découvrez les outils de pointe qui révolutionnent l\'exploration géologique des pegmatites en Côte d\'Ivoire',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFeaturesSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Capacités Principales',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 64),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 3 : 1,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: isDesktop ? 1.1 : 2.2,
            children: [
              _buildFeatureCard(
                icon: Icons.satellite_alt,
                title: 'Télédétection Multi-Capteurs',
                description:
                    'Analyse simultanée des données Landsat 8-9, Sentinel-2 et ASTER pour une couverture spectrale complète de 0.4 à 12 μm.',
                features: [
                  'Résolution spatiale : 30m à 10m',
                  'Couverture temporelle : 2013-2024',
                  'Indices spectraux optimisés',
                ],
                color: AppTheme.accentColor,
              ),
              _buildFeatureCard(
                icon: Icons.psychology,
                title: 'Intelligence Artificielle',
                description:
                    'Algorithmes d\'apprentissage automatique spécialisés pour la détection des pegmatites feldspathiques et à biotite-magnétite.',
                features: [
                  'K-means clustering adaptatif',
                  'Random Forest optimisé',
                  'Validation croisée robuste',
                ],
                color: AppTheme.secondaryColor,
              ),
              _buildFeatureCard(
                icon: Icons.map,
                title: 'Cartographie Interactive',
                description:
                    'Visualisation en temps réel des résultats d\'analyse avec des outils de cartographie avancés.',
                features: [
                  'Cartes interactives haute résolution',
                  'Superposition de couches',
                  'Export en formats multiples',
                ],
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalFeaturesSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Spécifications Techniques',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 64),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 2 : 1,
            crossAxisSpacing: 48,
            mainAxisSpacing: 48,
            childAspectRatio: isDesktop ? 1.5 : 2.5,
            children: [
              _buildTechnicalCard(
                title: 'Indices Spectraux',
                items: [
                  'NDVI : Végétation et couverture',
                  'NDWI : Humidité du sol',
                  'Clay Index : Minéraux argileux',
                  'Iron Oxide Index : Oxydes de fer',
                  'Alteration Index : Zones d\'altération',
                ],
                icon: Icons.analytics,
              ),
              _buildTechnicalCard(
                title: 'Algorithmes ML',
                items: [
                  'K-means : Classification non supervisée',
                  'Random Forest : Prédiction supervisée',
                  'Support Vector Machine : Classification',
                  'Neural Networks : Reconnaissance de patterns',
                  'Ensemble Methods : Amélioration des performances',
                ],
                icon: Icons.smart_toy,
              ),
              _buildTechnicalCard(
                title: 'Formats de Données',
                items: [
                  'GeoTIFF : Images géoréférencées',
                  'Shapefile : Données vectorielles',
                  'KML/KMZ : Visualisation Google Earth',
                  'CSV : Données tabulaires',
                  'JSON : Métadonnées et résultats',
                ],
                icon: Icons.folder,
              ),
              _buildTechnicalCard(
                title: 'Métriques de Performance',
                items: [
                  'Précision globale : 85%',
                  'Rappel : 82%',
                  'Score F1 : 0.83',
                  'Temps de traitement : 5-6 jours/500km²',
                  'Validation terrain : 78%',
                ],
                icon: Icons.assessment,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Processus d\'Analyse',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 64),

          if (isDesktop)
            Row(
              children: [
                Expanded(
                  child: _buildWorkflowStep(
                    1,
                    'Acquisition',
                    'Téléchargement automatique des données satellitaires multi-temporelles',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildWorkflowStep(
                    2,
                    'Prétraitement',
                    'Corrections atmosphériques et géométriques',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildWorkflowStep(
                    3,
                    'Analyse',
                    'Application des algorithmes d\'IA',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildWorkflowStep(
                    4,
                    'Résultats',
                    'Génération de cartes et rapports',
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildWorkflowStep(
                  1,
                  'Acquisition',
                  'Téléchargement automatique des données satellitaires multi-temporelles',
                ),
                const SizedBox(height: 24),
                _buildWorkflowStep(
                  2,
                  'Prétraitement',
                  'Corrections atmosphériques et géométriques',
                ),
                const SizedBox(height: 24),
                _buildWorkflowStep(
                  3,
                  'Analyse',
                  'Application des algorithmes d\'IA',
                ),
                const SizedBox(height: 24),
                _buildWorkflowStep(
                  4,
                  'Résultats',
                  'Génération de cartes et rapports',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Avantages Concurrentiels',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 64),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 2 : 1,
            crossAxisSpacing: 48,
            mainAxisSpacing: 32,
            childAspectRatio: isDesktop ? 2.5 : 3.5,
            children: [
              _buildBenefitCard(
                icon: Icons.speed,
                title: 'Rapidité d\'Exécution',
                description:
                    'Analyse de 500 km² en 5-6 jours contre plusieurs mois avec les méthodes traditionnelles.',
              ),
              _buildBenefitCard(
                icon: Icons.savings,
                title: 'Réduction des Coûts',
                description:
                    'Diminution des coûts d\'exploration jusqu\'à 70% grâce à l\'optimisation des campagnes terrain.',
              ),
              _buildBenefitCard(
                icon: Icons.precision_manufacturing,
                title: 'Précision Améliorée',
                description:
                    'Précision de détection de 85% avec validation terrain continue.',
              ),
              _buildBenefitCard(
                icon: Icons.eco,
                title: 'Impact Environnemental',
                description:
                    'Réduction de l\'empreinte écologique grâce à l\'optimisation des zones d\'intervention.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, bool isDesktop) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Prêt à Révolutionner votre Exploration ?',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Rejoignez la nouvelle génération d\'exploration géologique avec nos outils d\'intelligence artificielle.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.go('/auth/register'),
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Commencer maintenant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => context.go('/landing/technology'),
                icon: const Icon(Icons.info_outline),
                label: const Text('En savoir plus'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: color),
          ),

          const SizedBox(height: 24),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),

          const SizedBox(height: 20),

          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalCard({
    required String title,
    required List<String> items,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowStep(int step, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: AppTheme.secondaryColor),
          ),

          const SizedBox(width: 24),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
