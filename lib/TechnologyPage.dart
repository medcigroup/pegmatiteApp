import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';

class TechnologyPage extends StatefulWidget {
  const TechnologyPage({Key? key}) : super(key: key);

  @override
  State<TechnologyPage> createState() => _TechnologyPageState();
}

class _TechnologyPageState extends State<TechnologyPage> {
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
                  final logoSize = (constraints.maxWidth - 16).clamp(16.0, 32.0);

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
            onPressed: () => context.go('/landing/features'),
            child: const Text('Fonctionnalités'),
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

            // Architecture Section
            _buildArchitectureSection(context, isDesktop),

            // Tech Stack Section
            _buildTechStackSection(context, isDesktop),

            // AI & ML Section
            _buildAIMLSection(context, isDesktop),

            // Data Processing Section
            _buildDataProcessingSection(context, isDesktop),

            // Security Section
            _buildSecuritySection(context, isDesktop),

            // Performance Section
            _buildPerformanceSection(context, isDesktop),

            // Future Section
            _buildFutureSection(context, isDesktop),

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
          colors: [
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.settings,
                size: 40,
                color: Colors.white,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            Text(
              'Technologies de Pointe',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 24),

            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Text(
                'Une architecture moderne et scalable pour l\'exploration géologique du futur',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectureSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Architecture du Système',
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
                  child: _buildArchitectureDescription(),
                ),
                const SizedBox(width: 64),
                Expanded(
                  child: _buildArchitectureDiagram(),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildArchitectureDescription(),
                const SizedBox(height: 48),
                _buildArchitectureDiagram(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildArchitectureDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Architecture Cloud-Native',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Notre plateforme utilise une architecture microservices moderne, déployée sur le cloud pour garantir haute disponibilité, scalabilité et performance.',
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.6,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 32),

        ...['Microservices découplés', 'Auto-scaling dynamique', 'Haute disponibilité 99.9%', 'Sécurité multi-niveaux'].map((feature) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    feature,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildArchitectureDiagram() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildArchitectureLayer('Interface Utilisateur', 'Flutter Web', AppTheme.primaryColor),
          const SizedBox(height: 16),
          _buildArchitectureLayer('API Gateway', 'Supabase Auth', AppTheme.accentColor),
          const SizedBox(height: 16),
          _buildArchitectureLayer('Services Métier', 'Traitement IA', AppTheme.secondaryColor),
          const SizedBox(height: 16),
          _buildArchitectureLayer('Base de Données', 'PostgreSQL + PostGIS', AppTheme.primaryColor),
          const SizedBox(height: 16),
          _buildArchitectureLayer('Storage', 'Cloud Storage', Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildArchitectureLayer(String title, String subtitle, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildTechStackSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Stack Technologique',
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
            crossAxisCount: isDesktop ? 4 : 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
            children: [
              _buildTechCard('Flutter', 'Framework UI cross-platform', 'assets/tech/flutter.png', AppTheme.primaryColor),
              _buildTechCard('Supabase', 'Backend-as-a-Service', 'assets/tech/supabase.png', AppTheme.accentColor),
              _buildTechCard('PostgreSQL', 'Base de données relationnelle', 'assets/tech/postgresql.png', AppTheme.secondaryColor),
              _buildTechCard('PostGIS', 'Extension géospatiale', 'assets/tech/postgis.png', AppTheme.primaryColor),
              _buildTechCard('Python', 'Traitement de données', 'assets/tech/python.png', AppTheme.accentColor),
              _buildTechCard('TensorFlow', 'Machine Learning', 'assets/tech/tensorflow.png', AppTheme.secondaryColor),
              _buildTechCard('GDAL', 'Traitement géospatial', 'assets/tech/gdal.png', AppTheme.primaryColor),
              _buildTechCard('Docker', 'Conteneurisation', 'assets/tech/docker.png', AppTheme.accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechCard(String name, String description, String imagePath, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.code,
              size: 24,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAIMLSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Intelligence Artificielle & Machine Learning',
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
            childAspectRatio: isDesktop ? 1.3 : 2.5,
            children: [
              _buildAICard(
                icon: Icons.scatter_plot,
                title: 'K-means Clustering',
                description: 'Classification non supervisée pour l\'identification des groupes spectraux homogènes',
                features: ['Initialisation K-means++', 'Optimisation itérative', 'Validation silhouette'],
                color: AppTheme.primaryColor,
              ),
              _buildAICard(
                icon: Icons.account_tree,
                title: 'Random Forest',
                description: 'Ensemble d\'arbres de décision pour la classification supervisée des pegmatites',
                features: ['500 arbres par défaut', 'Sélection de features', 'Validation croisée'],
                color: AppTheme.accentColor,
              ),
              _buildAICard(
                icon: Icons.network_check,
                title: 'Réseaux de Neurones',
                description: 'Deep Learning pour la reconnaissance de patterns complexes',
                features: ['Architecture CNN', 'Transfer Learning', 'Augmentation de données'],
                color: AppTheme.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAICard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          ...features.map((feature) => Padding(
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
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDataProcessingSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Traitement des Données',
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
                Expanded(child: _buildDataFlowDiagram()),
                const SizedBox(width: 64),
                Expanded(child: _buildDataSpecs()),
              ],
            )
          else
            Column(
              children: [
                _buildDataSpecs(),
                const SizedBox(height: 48),
                _buildDataFlowDiagram(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDataFlowDiagram() {
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
        children: [
          Text(
            'Pipeline de Traitement',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: 32),

          _buildFlowStep('Acquisition', 'Données satellitaires', Icons.satellite_alt),
          _buildFlowArrow(),
          _buildFlowStep('Prétraitement', 'Corrections & filtrage', Icons.tune),
          _buildFlowArrow(),
          _buildFlowStep('Extraction', 'Indices spectraux', Icons.analytics),
          _buildFlowArrow(),
          _buildFlowStep('Classification', 'Algorithmes ML', Icons.psychology),
          _buildFlowArrow(),
          _buildFlowStep('Validation', 'Contrôle qualité', Icons.verified),
        ],
      ),
    );
  }

  Widget _buildFlowStep(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
          ),
        ],
      ),
    );
  }

  Widget _buildFlowArrow() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Icon(
        Icons.keyboard_arrow_down,
        color: AppTheme.primaryColor,
        size: 24,
      ),
    );
  }

  Widget _buildDataSpecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spécifications Données',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),

        const SizedBox(height: 32),

        _buildSpecItem('Volume de données', '500 km² / 6 jours', Icons.storage),
        _buildSpecItem('Résolution spatiale', '10m - 30m', Icons.grid_on),
        _buildSpecItem('Bandes spectrales', '11 bandes (0.4-12 μm)', Icons.add_chart_rounded),
        _buildSpecItem('Précision géométrique', '< 15m CE90', Icons.gps_fixed),
        _buildSpecItem('Couverture temporelle', '2013-2024', Icons.calendar_today),
        _buildSpecItem('Format de sortie', 'GeoTIFF, Shapefile', Icons.file_present),
      ],
    );
  }

  Widget _buildSpecItem(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.accentColor,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Sécurité & Conformité',
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
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: isDesktop ? 2 : 3,
            children: [
              _buildSecurityCard(
                icon: Icons.security,
                title: 'Chiffrement End-to-End',
                description: 'Toutes les données sont chiffrées en transit et au repos avec AES-256',
                color: AppTheme.primaryColor,
              ),
              _buildSecurityCard(
                icon: Icons.verified_user,
                title: 'Authentification Multi-Facteurs',
                description: 'Protection renforcée avec 2FA et authentification biométrique',
                color: AppTheme.accentColor,
              ),
              _buildSecurityCard(
                icon: Icons.policy,
                title: 'Conformité RGPD',
                description: 'Respect total des réglementations sur la protection des données',
                color: AppTheme.secondaryColor,
              ),
              _buildSecurityCard(
                icon: Icons.monitor_heart,
                title: 'Surveillance Continue',
                description: 'Monitoring 24/7 avec détection automatique des anomalies',
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
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

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Performance & Scalabilité',
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
            crossAxisCount: isDesktop ? 4 : 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
            children: [
              _buildMetricCard('99.9%', 'Disponibilité', Icons.double_arrow),
              _buildMetricCard('< 2s', 'Temps de réponse', Icons.speed),
              _buildMetricCard('500 km²', 'Traitement / 6 jours', Icons.analytics),
              _buildMetricCard('Auto', 'Scaling', Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: AppTheme.primaryColor,
          ),

          const SizedBox(height: 16),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFutureSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Roadmap Technologique',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          Text(
            'Innovations à venir dans les prochaines versions',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
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
            childAspectRatio: isDesktop ? 1.2 : 2.5,
            children: [
              _buildFutureCard(
                icon: Icons.architecture,
                title: 'Edge Computing',
                description: 'Traitement local pour réduire la latence et améliorer les performances',
                timeline: 'Q2 2026',
                color: AppTheme.primaryColor,
              ),
              _buildFutureCard(
                icon: Icons.view_in_ar,
                title: 'Réalité Augmentée',
                description: 'Visualisation 3D immersive des données géologiques sur le terrain',
                timeline: 'Q3 2026',
                color: AppTheme.accentColor,
              ),
              _buildFutureCard(
                icon: Icons.smart_toy,
                title: 'IA Générative',
                description: 'Génération automatique de rapports et recommandations d\'exploration',
                timeline: 'Q4 2026',
                color: AppTheme.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFutureCard({
    required IconData icon,
    required String title,
    required String description,
    required String timeline,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeline,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
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
          colors: [
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Prêt à Explorer le Futur ?',
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
              'Découvrez comment notre stack technologique peut révolutionner votre approche de l\'exploration géologique.',
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
                onPressed: () => context.go('/landing/AboutPage'),
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
}