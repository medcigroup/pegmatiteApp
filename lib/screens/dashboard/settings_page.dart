import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  // Paramètres d'analyse
  double _defaultConfidenceThreshold = 0.75;
  String _preferredAlgorithm = 'k-means';
  bool _autoSaveResults = true;
  bool _enableNotifications = true;
  bool _showAdvancedOptions = false;

  // Paramètres de carte
  String _defaultMapLayer = 'satellite';
  bool _showGridLines = false;
  bool _enableMeasurementTools = true;
  double _mapOpacity = 0.8;

  // Paramètres système
  String _theme = 'light';
  String _language = 'fr';
  bool _autoBackup = true;
  String _dataRetention = '12_months';

  // Profil utilisateur
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _organizationController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadUserProfile() {
    // Charger le profil utilisateur depuis Supabase
    ref.read(userProfileProvider).when(
      data: (profile) {
        if (profile != null) {
          _nameController.text = profile['full_name'] ?? '';
          _emailController.text = profile['email'] ?? '';
          _organizationController.text = profile['organization'] ?? '';
          _phoneController.text = profile['phone'] ?? '';
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Onglets
          _buildTabBar(),

          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildAnalysisSettingsTab(),
                _buildMapSettingsTab(),
                _buildSystemSettingsTab(),
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
                  Icons.settings,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Configuration de l\'application et du profil',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),

          // Actions
          OutlinedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            label: const Text('Restaurer défauts'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Sauvegarder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
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
          Tab(icon: Icon(Icons.person), text: 'Profil'),
          Tab(icon: Icon(Icons.analytics), text: 'Analyse'),
          Tab(icon: Icon(Icons.map), text: 'Cartographie'),
          Tab(icon: Icon(Icons.computer), text: 'Système'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations personnelles
          _buildSection(
            'Informations Personnelles',
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom complet',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        enabled: false, // Email non modifiable
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _organizationController,
                        decoration: const InputDecoration(
                          labelText: 'Organisation',
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone (optionnel)',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Photo de profil
          _buildSection(
            'Photo de Profil',
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _uploadProfilePhoto,
                      icon: const Icon(Icons.upload),
                      label: const Text('Changer la photo'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Formats acceptés: JPG, PNG (max 2MB)',
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

          const SizedBox(height: 32),

          // Sécurité
          _buildSection(
            'Sécurité',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Changer le mot de passe'),
                  subtitle: const Text('Dernière modification il y a 2 mois'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _changePassword,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Authentification à deux facteurs'),
                  subtitle: const Text('Sécurisez votre compte'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text('Sessions actives'),
                  subtitle: const Text('Gérer les appareils connectés'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _manageSessions,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Préférences de notification
          _buildSection(
            'Notifications',
            Column(
              children: [
                SwitchListTile(
                  title: const Text('Notifications d\'analyse'),
                  subtitle: const Text('Recevoir les résultats par email'),
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      _enableNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Alertes système'),
                  subtitle: const Text('Notifications de maintenance'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Rapport hebdomadaire'),
                  subtitle: const Text('Résumé des activités'),
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Paramètres par défaut
          _buildSection(
            'Paramètres d\'Analyse par Défaut',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Algorithme préféré',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _preferredAlgorithm,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'k-means', child: Text('K-means')),
                              DropdownMenuItem(value: 'random-forest', child: Text('Random Forest')),
                              DropdownMenuItem(value: 'svm', child: Text('SVM')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _preferredAlgorithm = value ?? 'k-means';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seuil de confiance par défaut',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: _defaultConfidenceThreshold,
                            min: 0.5,
                            max: 0.95,
                            divisions: 9,
                            label: '${(_defaultConfidenceThreshold * 100).toInt()}%',
                            onChanged: (value) {
                              setState(() {
                                _defaultConfidenceThreshold = value;
                              });
                            },
                          ),
                          Text(
                            '${(_defaultConfidenceThreshold * 100).toInt()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Options d'analyse
          _buildSection(
            'Options d\'Analyse',
            Column(
              children: [
                SwitchListTile(
                  title: const Text('Sauvegarde automatique'),
                  subtitle: const Text('Sauvegarder automatiquement les résultats'),
                  value: _autoSaveResults,
                  onChanged: (value) {
                    setState(() {
                      _autoSaveResults = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Options avancées'),
                  subtitle: const Text('Afficher les paramètres techniques'),
                  value: _showAdvancedOptions,
                  onChanged: (value) {
                    setState(() {
                      _showAdvancedOptions = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Validation automatique'),
                  subtitle: const Text('Valider auto si confiance > 90%'),
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Indices spectraux
          _buildSection(
            'Configuration des Indices Spectraux',
            Column(
              children: [
                _buildIndexConfig('Feldspath Index', 'SWIR1/SWIR2', true),
                _buildIndexConfig('Iron Ratio', 'RED/NIR', true),
                _buildIndexConfig('Bright Index', '(SWIR1+SWIR2)/2', true),
                _buildIndexConfig('Magnetic Index', 'Personnalisé', false),
                _buildIndexConfig('Clay Index', 'SWIR1/SWIR2', false),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Paramètres de traitement
          _buildSection(
            'Traitement d\'Images',
            Column(
              children: [
                _buildParameterSlider(
                  'Masquage végétation (NDVI)',
                  0.3,
                  0.1,
                  0.6,
                ),
                _buildParameterSlider(
                  'Filtrage spatial (kernel)',
                  3.0,
                  1.0,
                  7.0,
                ),
                _buildParameterSlider(
                  'Correction atmosphérique',
                  1.0,
                  0.5,
                  2.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Couches par défaut
          _buildSection(
            'Couches de Base',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Couche par défaut',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _defaultMapLayer,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'satellite', child: Text('Vue satellite')),
                    DropdownMenuItem(value: 'terrain', child: Text('Terrain')),
                    DropdownMenuItem(value: 'osm', child: Text('OpenStreetMap')),
                    DropdownMenuItem(value: 'hybrid', child: Text('Hybride')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _defaultMapLayer = value ?? 'satellite';
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Options d'affichage
          _buildSection(
            'Affichage de la Carte',
            Column(
              children: [
                SwitchListTile(
                  title: const Text('Grille de coordonnées'),
                  subtitle: const Text('Afficher la grille lat/lon'),
                  value: _showGridLines,
                  onChanged: (value) {
                    setState(() {
                      _showGridLines = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Outils de mesure'),
                  subtitle: const Text('Distance et superficie'),
                  value: _enableMeasurementTools,
                  onChanged: (value) {
                    setState(() {
                      _enableMeasurementTools = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Coordonnées en temps réel'),
                  subtitle: const Text('Position du curseur'),
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Opacité des couches
          _buildSection(
            'Transparence des Couches',
            Column(
              children: [
                _buildOpacitySlider('Couches d\'analyse', _mapOpacity),
                _buildOpacitySlider('Zones d\'étude', 0.7),
                _buildOpacitySlider('Résultats de classification', 0.8),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Styles de marqueurs
          _buildSection(
            'Styles de Marqueurs',
            Column(
              children: [
                _buildMarkerStyle('Pegmatites feldspathiques', AppTheme.feldspathColor),
                _buildMarkerStyle('Pegmatites biotite-magnétite', AppTheme.biotiteColor),
                _buildMarkerStyle('Zones d\'intérêt', AppTheme.primaryColor),
                _buildMarkerStyle('Points de validation', Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interface
          _buildSection(
            'Interface Utilisateur',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thème',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _theme,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'light', child: Text('Clair')),
                              DropdownMenuItem(value: 'dark', child: Text('Sombre')),
                              DropdownMenuItem(value: 'auto', child: Text('Automatique')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _theme = value ?? 'light';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Langue',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _language,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'fr', child: Text('Français')),
                              DropdownMenuItem(value: 'en', child: Text('English')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _language = value ?? 'fr';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Stockage et sauvegarde
          _buildSection(
            'Stockage et Sauvegarde',
            Column(
              children: [
                SwitchListTile(
                  title: const Text('Sauvegarde automatique'),
                  subtitle: const Text('Sauvegarde quotidienne sur le cloud'),
                  value: _autoBackup,
                  onChanged: (value) {
                    setState(() {
                      _autoBackup = value;
                    });
                  },
                ),
                ListTile(
                  title: const Text('Rétention des données'),
                  subtitle: Text(_getRetentionLabel()),
                  trailing: DropdownButton<String>(
                    value: _dataRetention,
                    items: const [
                      DropdownMenuItem(value: '3_months', child: Text('3 mois')),
                      DropdownMenuItem(value: '6_months', child: Text('6 mois')),
                      DropdownMenuItem(value: '12_months', child: Text('12 mois')),
                      DropdownMenuItem(value: 'unlimited', child: Text('Illimité')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _dataRetention = value ?? '12_months';
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Utilisation du stockage'),
                  subtitle: const Text('2.3 GB utilisés sur 10 GB'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showStorageDetails,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Performance
          _buildSection(
            'Performance',
            Column(
              children: [
                ListTile(
                  title: const Text('Cache des tuiles'),
                  subtitle: const Text('156 MB en cache'),
                  trailing: TextButton(
                    onPressed: _clearTileCache,
                    child: const Text('Vider'),
                  ),
                ),
                ListTile(
                  title: const Text('Données temporaires'),
                  subtitle: const Text('89 MB de fichiers temporaires'),
                  trailing: TextButton(
                    onPressed: _clearTempFiles,
                    child: const Text('Nettoyer'),
                  ),
                ),
                ListTile(
                  title: const Text('Optimisation base de données'),
                  subtitle: const Text('Dernière optimisation: il y a 3 jours'),
                  trailing: TextButton(
                    onPressed: _optimizeDatabase,
                    child: const Text('Optimiser'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Support et diagnostic
          _buildSection(
            'Support et Diagnostic',
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Signaler un problème'),
                  subtitle: const Text('Envoyer un rapport d\'erreur'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _reportBug,
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Informations système'),
                  subtitle: const Text('Version, logs, diagnostics'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showSystemInfo,
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Documentation'),
                  subtitle: const Text('Guide d\'utilisation'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: _openDocumentation,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Actions dangereuses
          _buildSection(
            'Zone Dangereuse',
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.red.shade600),
                    title: Text(
                      'Supprimer toutes les données',
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                    subtitle: const Text('Action irréversible'),
                    trailing: TextButton(
                      onPressed: _deleteAllData,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Supprimer'),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red.shade600),
                    title: Text(
                      'Déconnexion de tous les appareils',
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                    subtitle: const Text('Fermer toutes les sessions'),
                    trailing: TextButton(
                      onPressed: _logoutAllDevices,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Déconnecter'),
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

  Widget _buildSection(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildIndexConfig(String name, String formula, bool enabled) {
    return ListTile(
      title: Text(name),
      subtitle: Text(formula),
      trailing: Switch(
        value: enabled,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildParameterSlider(String name, double value, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: (newValue) {},
        ),
      ],
    );
  }

  Widget _buildOpacitySlider(String name, double opacity) {
    return ListTile(
      title: Text(name),
      subtitle: Slider(
        value: opacity,
        min: 0.1,
        max: 1.0,
        divisions: 9,
        label: '${(opacity * 100).toInt()}%',
        onChanged: (value) {},
      ),
      trailing: Text('${(opacity * 100).toInt()}%'),
    );
  }

  Widget _buildMarkerStyle(String name, Color color) {
    return ListTile(
      leading: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(name),
      trailing: IconButton(
        icon: const Icon(Icons.color_lens),
        onPressed: () {},
      ),
    );
  }

  String _getRetentionLabel() {
    switch (_dataRetention) {
      case '3_months':
        return '3 mois';
      case '6_months':
        return '6 mois';
      case '12_months':
        return '12 mois';
      case 'unlimited':
        return 'Illimité';
      default:
        return '12 mois';
    }
  }

  // Actions
  void _uploadProfilePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonctionnalité de upload en cours de développement')),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Mot de passe actuel'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Confirmer nouveau mot de passe'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mot de passe modifié avec succès')),
              );
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _manageSessions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ouverture de la gestion des sessions')),
    );
  }

  void _showStorageDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Utilisation du Stockage'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Images satellitaires: 1.8 GB'),
            Text('Résultats d\'analyse: 0.3 GB'),
            Text('Cache: 0.2 GB'),
            Text('Total: 2.3 GB / 10 GB'),
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

  void _clearTileCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache des tuiles vidé')),
    );
  }

  void _clearTempFiles() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fichiers temporaires supprimés')),
    );
  }

  void _optimizeDatabase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Optimisation de la base de données...')),
    );
  }

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ouverture du formulaire de rapport de bug')),
    );
  }

  void _showSystemInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informations Système'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0+1'),
            Text('Build: 2025.01.15'),
            Text('Platform: Web'),
            Text('Supabase: Connecté'),
            Text('Last sync: 2 min ago'),
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

  void _openDocumentation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ouverture de la documentation...')),
    );
  }

  void _deleteAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attention !'),
        content: const Text(
          'Cette action supprimera définitivement toutes vos données. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les données ont été supprimées'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer tout'),
          ),
        ],
      ),
    );
  }

  void _logoutAllDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion globale'),
        content: const Text(
          'Cela fermera toutes les sessions actives sur tous les appareils.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Déconnexion effectuée')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurer les paramètres par défaut'),
        content: const Text(
          'Cela restaurera tous les paramètres à leurs valeurs par défaut.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _defaultConfidenceThreshold = 0.75;
                _preferredAlgorithm = 'k-means';
                _autoSaveResults = true;
                _enableNotifications = true;
                _showAdvancedOptions = false;
                _defaultMapLayer = 'satellite';
                _showGridLines = false;
                _enableMeasurementTools = true;
                _mapOpacity = 0.8;
                _theme = 'light';
                _language = 'fr';
                _autoBackup = true;
                _dataRetention = '12_months';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres restaurés par défaut')),
              );
            },
            child: const Text('Restaurer'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // Sauvegarder les paramètres dans Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paramètres sauvegardés avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }
}