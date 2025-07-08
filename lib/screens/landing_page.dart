import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isTablet = size.width > 768 && size.width <= 1200;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar moderne
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryColor,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 80 : 24,
                ),
                child: Row(
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
                    Text(
                      'SODEMI Pegmatites APP',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    const Spacer(),

                    // Navigation buttons
                    if (isDesktop) ...[
                      TextButton(
                        onPressed: () => _scrollToSection('features'),
                        child: const Text('Fonctionnalités'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection('technology'),
                        child: const Text('Technologie'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection('about'),
                        child: const Text('À propos'),
                      ),
                      const SizedBox(width: 16),
                    ],

                    // Auth buttons
                    TextButton(
                      onPressed: () => context.go('/auth/login'),
                      child: const Text('Connexion'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => context.go('/auth/register'),
                      child: const Text('Inscription'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: _buildHeroSection(context, isDesktop, isTablet),
          ),

          // Features Section
          SliverToBoxAdapter(
            child: _buildFeaturesSection(context, isDesktop),
          ),

          // Technology Section
          SliverToBoxAdapter(
            child: _buildTechnologySection(context, isDesktop),
          ),

          // About Section
          SliverToBoxAdapter(
            child: _buildAboutSection(context, isDesktop),
          ),

          // Footer
          SliverToBoxAdapter(
            child: _buildFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop, bool isTablet) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
          vertical: 40,
        ),
        child: Row(
          children: [
            // Contenu textuel
            Expanded(
              flex: isDesktop ? 1 : 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exploration Intelligente des Pegmatites',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 24),

                  Text(
                    'Optimisez l\'exploration des minéraux critiques en Côte d\'Ivoire grâce à la télédétection satellitaire et l\'intelligence artificielle.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go('/auth/register'),
                        icon: const Icon(Icons.rocket_launch),
                        label: const Text('Commencer l\'exploration'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(width: 16),

                      OutlinedButton.icon(
                        onPressed: () => _scrollToSection('features'),
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          'Voir la démo',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Stats
                  if (isDesktop)
                    Row(
                      children: [
                        _buildStatItem('500 km²', 'Analysés en 5-6 jours'),
                        const SizedBox(width: 48),
                        _buildStatItem('85%', 'Précision de détection'),
                        const SizedBox(width: 48),
                        _buildStatItem('3 Types', 'Pegmatites identifiées'),
                      ],
                    ).animate().fadeIn(delay: 1000.ms),
                ],
              ),
            ),

            // Illustration (seulement sur desktop)
            if (isDesktop)
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 48),
                  child: _buildHeroIllustration(),
                ).animate().fadeIn(delay: 600.ms),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroIllustration() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône satellite
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.satellite_alt,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          // Flèche vers le bas
          Container(
            width: 2,
            height: 40,
            color: Colors.white.withOpacity(0.5),
          ),

          const SizedBox(height: 24),

          // Carte/terrain
          // Carte/terrain avec image et overlay
          Container(
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Image de fond
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/RST2023_Watineetal_Poster.PNG',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withOpacity(0.1),
                          child: const Center(
                            child: Icon(
                              Icons.terrain,
                              size: 48,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Overlay coloré pour maintenir le thème
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.3),
                            AppTheme.accentColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Optionnel : icône ou texte par-dessus
                  const Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.layers_outlined,
                        size: 32,
                        color: Colors.white70,
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

  Widget _buildFeaturesSection(BuildContext context, bool isDesktop) {
    return Container(
      key: const Key('features'),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Fonctionnalités Avancées',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'Des outils de pointe pour l\'exploration géologique moderne',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade600,
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
              _buildFeatureCard(
                icon: Icons.satellite_alt,
                title: 'Télédétection Multi-Capteurs',
                description: 'Analyse des données Landsat 8-9, Sentinel-2 et ASTER pour une couverture spectrale optimale.',
                color: AppTheme.accentColor,
              ),
              _buildFeatureCard(
                icon: Icons.psychology,
                title: 'Intelligence Artificielle',
                description: 'Algorithmes K-means et Random Forest adaptés aux pegmatites feldspathiques et biotite-magnétite.',
                color: AppTheme.secondaryColor,
              ),
              _buildFeatureCard(
                icon: Icons.map,
                title: 'Cartographie Interactive',
                description: 'Visualisation en temps réel des indices spectraux et des zones à fort potentiel pegmatitique.',
                color: AppTheme.primaryColor,
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
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
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
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnologySection(BuildContext context, bool isDesktop) {
    return Container(
      key: const Key('technology'),
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Technologies de Pointe',
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
                  child: _buildTechStack(),
                ),
                const SizedBox(width: 64),
                Expanded(
                  child: _buildTechDescription(),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildTechDescription(),
                const SizedBox(height: 32),
                _buildTechStack(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTechStack() {
    return Column(
      children: [
        _buildTechItem('PostgreSQL + PostGIS', 'Base de données géospatiales'),
        _buildTechItem('Flutter Web', 'Interface utilisateur moderne'),
        _buildTechItem('Supabase', 'Backend et authentification'),
        _buildTechItem('Machine Learning', 'Classification automatisée'),
      ],
    );
  }

  Widget _buildTechItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
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
        ],
      ),
    );
  }

  Widget _buildTechDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Architecture Moderne',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Notre application utilise une stack technologique moderne pour offrir des performances optimales et une expérience utilisateur exceptionnelle.',
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          onPressed: () => context.go('/auth/register'),
          icon: const Icon(Icons.code),
          label: const Text('Découvrir la plateforme'),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDesktop) {
    return Container(
      key: const Key('about'),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Développé pour la SODEMI',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              'Cette application a été développée dans le cadre d\'un stage en collaboration avec la SODEMI (Société pour le Développement Minier de la Côte d\'Ivoire) pour optimiser l\'exploration des pegmatites riches en minéraux critiques sur le territoire ivoirien.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.terrain,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'SODEMI Pegmatites Detection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            '© 2025 SODEMI. Tous droits réservés.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToSection(String section) {
    // Implementation for smooth scrolling to sections
    // This would require implementing section detection and smooth scrolling
  }
}