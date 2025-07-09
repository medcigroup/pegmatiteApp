import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
            onPressed: () => context.go('/landing/technology'),
            child: const Text('Technologie'),
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

            // Mission Section
            _buildMissionSection(context, isDesktop),

            // SODEMI Section
            _buildSodemiSection(context, isDesktop),

            // Project Context Section
            _buildProjectContextSection(context, isDesktop),

            // Team Section
            _buildTeamSection(context, isDesktop),

            // Impact Section
            _buildImpactSection(context, isDesktop),

            // Timeline Section
            _buildTimelineSection(context, isDesktop),

            // Contact Section
            _buildContactSection(context, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.terrain,
                size: 50,
                color: Colors.white,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            Text(
              'À Propos de SODEMI Pegmatites APP',
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
                'Une innovation technologique développée par les équipes de la SODEMI pour révolutionner l\'exploration géologique des pegmatites en Côte d\'Ivoire.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),
            ),

            const SizedBox(height: 48),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard('2025', 'Année de développement'),
                const SizedBox(width: 32),
                _buildStatCard('8 mois', 'Durée du projet'),
                const SizedBox(width: 32),
                _buildStatCard('85%', 'Précision atteinte'),
              ],
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Notre Mission',
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
                  child: _buildMissionContent(),
                ),
                const SizedBox(width: 64),
                Expanded(
                  child: _buildMissionImage(),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildMissionContent(),
                const SizedBox(height: 48),
                _buildMissionImage(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMissionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Révolutionner l\'Exploration Géologique',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'Notre mission est de transformer l\'exploration des pegmatites en Côte d\'Ivoire en utilisant les technologies de pointe de la télédétection et de l\'intelligence artificielle, développées par les équipes expertes de la SODEMI.',
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.6,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 32),

        ...['Optimiser les campagnes d\'exploration', 'Réduire les coûts et les délais', 'Améliorer la précision de détection', 'Minimiser l\'impact environnemental'].map((objective) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.accentColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      objective,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildMissionImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Placeholder pour l'image
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: const Center(
                child: Icon(
                  Icons.landscape,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            // Overlay avec texte
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exploration Moderne',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Utilisation des dernières technologies pour une exploration plus efficace et durable.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSodemiSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Partenariat avec la SODEMI',
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
                Expanded(child: _buildSodemiInfo()),
                const SizedBox(width: 64),
                Expanded(child: _buildSodemiLogo()),
              ],
            )
          else
            Column(
              children: [
                _buildSodemiLogo(),
                const SizedBox(height: 48),
                _buildSodemiInfo(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSodemiInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Société pour le Développement Minier de la Côte d\'Ivoire',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          'La SODEMI est l\'organisme national chargé de la promotion et du développement du secteur minier en Côte d\'Ivoire. Créée en 1962, elle a développé cette application innovante avec ses équipes internes pour optimiser l\'exploration et la valorisation des ressources minérales du pays.',
          style: TextStyle(
            color: Colors.grey.shade600,
            height: 1.6,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 32),

        _buildSodemiFeature(
          icon: Icons.explore,
          title: 'Exploration Minière',
          description: 'Recherche et identification des gisements minéraux',
        ),
        _buildSodemiFeature(
          icon: Icons.science,
          title: 'Recherche & Développement',
          description: 'Innovation technologique pour l\'industrie minière',
        ),
        _buildSodemiFeature(
          icon: Icons.handshake,
          title: 'Développement Interne',
          description: 'Développement complet avec les équipes internes SODEMI',
        ),
      ],
    );
  }

  Widget _buildSodemiFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.accentColor,
              size: 24,
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSodemiLogo() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.diamond,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'SODEMI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Développeur du projet',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectContextSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Contexte du Projet',
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
            childAspectRatio: isDesktop ? 2.5 : 4,
            children: [
              _buildContextCard(
                icon: Icons.business,
                title: 'Projet Interne SODEMI',
                description: 'Développé entièrement par les équipes internes de la SODEMI avec leurs expertises techniques et géologiques.',
                color: AppTheme.primaryColor,
              ),
              _buildContextCard(
                icon: Icons.flag,
                title: 'Objectif National',
                description: 'Contribuer au développement des ressources minérales critiques en Côte d\'Ivoire.',
                color: AppTheme.accentColor,
              ),
              _buildContextCard(
                icon: Icons.timeline,
                title: 'Innovation Technologique',
                description: 'Première application d\'IA pour la détection de pegmatites en Afrique de l\'Ouest.',
                color: AppTheme.secondaryColor,
              ),
              _buildContextCard(
                icon: Icons.public,
                title: 'Impact Régional',
                description: 'Potentiel d\'extension à d\'autres pays de la sous-région ouest-africaine.',
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContextCard({
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

  Widget _buildTeamSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Équipe SODEMI',
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
            childAspectRatio: isDesktop ? 1.2 : 2.5,
            children: [
              _buildTeamCard(
                name: 'Équipe Géologique SODEMI',
                role: 'Expertise & Validation',
                description: 'Géologues experts de la SODEMI spécialisés en pegmatites et en validation terrain des résultats d\'exploration.',
                avatar: Icons.terrain,
              ),
              _buildTeamCard(
                name: 'Équipe Technique SODEMI',
                role: 'Développement & IA',
                description: 'Ingénieurs et techniciens SODEMI spécialisés en télédétection, machine learning et SIG.',
                avatar: Icons.computer,
              ),
              _buildTeamCard(
                name: 'Direction SODEMI',
                role: 'Supervision & Stratégie',
                description: 'Direction technique et stratégique du projet par les cadres supérieurs de la SODEMI.',
                avatar: Icons.manage_accounts,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard({
    required String name,
    required String role,
    required String description,
    required IconData avatar,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Icon(
              avatar,
              size: 32,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Impact et Bénéfices',
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
            childAspectRatio: isDesktop ? 1.5 : 2.5,
            children: [
              _buildImpactCard(
                title: 'Impact Économique',
                items: [
                  'Réduction des coûts d\'exploration de 70%',
                  'Accélération des découvertes minérales',
                  'Optimisation des investissements',
                ],
                icon: Icons.trending_up,
                color: AppTheme.secondaryColor,
              ),
              _buildImpactCard(
                title: 'Impact Technologique',
                items: [
                  'Transfert de technologie vers l\'Afrique',
                  'Formation aux outils numériques',
                  'Innovation dans le secteur minier',
                ],
                icon: Icons.computer,
                color: AppTheme.accentColor,
              ),
              _buildImpactCard(
                title: 'Impact Environnemental',
                items: [
                  'Réduction de l\'empreinte écologique',
                  'Exploration plus ciblée et précise',
                  'Préservation des écosystèmes',
                ],
                icon: Icons.eco,
                color: AppTheme.primaryColor,
              ),
              _buildImpactCard(
                title: 'Impact Social',
                items: [
                  'Création d\'emplois qualifiés',
                  'Développement des compétences locales',
                  'Contribution au développement national',
                ],
                icon: Icons.people,
                color: AppTheme.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard({
    required String title,
    required List<String> items,
    required IconData icon,
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
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
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
          )),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context, bool isDesktop) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Chronologie du Projet',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 64),

          Column(
            children: [
              _buildTimelineItem(
                date: 'Mai 2025',
                title: 'Lancement du Projet',
                description: 'Début du projet et définition des objectifs avec les équipes SODEMI',
                isCompleted: true,
              ),
              _buildTimelineItem(
                date: 'Juin 2025',
                title: 'Recherche & Analyse',
                description: 'Étude de faisabilité et sélection des technologies par les équipes SODEMI',
                isCompleted: true,
              ),
              _buildTimelineItem(
                date: 'Juillet-Août 2025',
                title: 'Développement',
                description: 'Développement des algorithmes et de l\'interface par les ingénieurs SODEMI',
                isCompleted: true,
              ),
              _buildTimelineItem(
                date: 'Septembre 2025',
                title: 'Tests & Validation',
                description: 'Tests sur données réelles et validation terrain par les géologues SODEMI',
                isCompleted: true,
              ),
              _buildTimelineItem(
                date: 'Octobre 2025',
                title: 'Déploiement',
                description: 'Mise en production et formation des utilisateurs SODEMI',
                isCompleted: true,
              ),
              _buildTimelineItem(
                date: 'Novembre 2025',
                title: 'Optimisation',
                description: 'Améliorations continues basées sur les retours des équipes SODEMI',
                isCompleted: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required String title,
    required String description,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isCompleted ? AppTheme.primaryColor : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 60,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
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

  Widget _buildContactSection(BuildContext context, bool isDesktop) {
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
            'Contactez-Nous',
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
              'Vous avez des questions sur le projet ou souhaitez en savoir plus sur nos solutions d\'exploration géologique ?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 48),

          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContactCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: 'contact@sodemi-pegmatites.ci',
                ),
                const SizedBox(width: 32),
                _buildContactCard(
                  icon: Icons.phone,
                  title: 'Téléphone',
                  value: '+225 XX XX XX XX',
                ),
                const SizedBox(width: 32),
                _buildContactCard(
                  icon: Icons.location_on,
                  title: 'Adresse',
                  value: 'Abidjan, Côte d\'Ivoire',
                ),
              ],
            )
          else
            Column(
              children: [
                _buildContactCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: 'contact@sodemi-pegmatites.ci',
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  icon: Icons.phone,
                  title: 'Téléphone',
                  value: '+225 XX XX XX XX',
                ),
                const SizedBox(height: 16),
                _buildContactCard(
                  icon: Icons.location_on,
                  title: 'Adresse',
                  value: 'Abidjan, Côte d\'Ivoire',
                ),
              ],
            ),

          const SizedBox(height: 48),

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
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}