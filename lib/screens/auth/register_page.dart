import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _organizationController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String? _selectedOrganization;
  String _selectedRole = 'Géologue';

  final List<String> _roles = [
    'Géologue',
    'Ingénieur en télédétection',
    'Chef de projet',
    'Analyste SIG',
    'Directeur technique',
    'Autre',
  ];

  final List<String> _organizations = [
    'SODEMI',
    'Ministère des Mines',
    'Université Félix Houphouët-Boigny',
    'UFHB - UFR STRM',
    'BNETD',
    'Consultant indépendant',
    'Autre',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _organizationController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez accepter les conditions d\'utilisation'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Utiliser l'organisation sélectionnée ou saisie
      final organization = _selectedOrganization == 'Autre'
          ? _organizationController.text.trim()
          : _selectedOrganization ?? '';

      await ref.read(authProvider.notifier).signUpWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        organization: organization,
        role: _selectedRole,
      );

      // Afficher le dialogue de succès
      if (mounted) {
        await _showSuccessDialog();
      }

    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    getAuthErrorMessage(error),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

// Méthode pour afficher le dialogue de succès
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utilisateur doit cliquer sur le bouton
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône de succès
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),

              const SizedBox(height: 24),

              // Titre
              Text(
                'Compte créé avec succès !',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Message
              Text(
                'Votre compte a été créé avec succès.\nVérifiez votre email pour activer votre compte, puis connectez-vous.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Bouton
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer le dialogue
                    context.go('/auth/login'); // Rediriger vers login
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Aller à la connexion'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return Scaffold(
      body: Row(
        children: [
          // Panneau gauche - Illustration (seulement sur desktop)
          if (isDesktop)
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.accentColor, AppTheme.primaryColor],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.terrain,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Rejoignez l\'Équipe SODEMI',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Créez votre compte pour accéder aux outils les plus avancés d\'exploration géologique et contribuer au développement minier de la Côte d\'Ivoire.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Statistics
                      _buildStatistics(),
                    ],
                  ),
                ),
              ),
            ),

          // Panneau droit - Formulaire d'inscription
          Expanded(
            flex: isDesktop ? 1 : 2,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(isDesktop ? 48 : 24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        if (!isDesktop) ...[
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.terrain,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'SODEMI',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],

                        Text(
                          'Créer un compte',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Rejoignez la plateforme d\'exploration',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Formulaire
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Nom complet
                              TextFormField(
                                controller: _fullNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom complet',
                                  hintText: 'Jean Kouassi',
                                  prefixIcon: Icon(Icons.person_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Veuillez saisir votre nom complet';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email professionnel',
                                  hintText: 'j.kouassi@sodemi.ci',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir votre email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                    return 'Format d\'email invalide';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Organisation
                              DropdownButtonFormField<String>(
                                value: _selectedOrganization,
                                decoration: const InputDecoration(
                                  labelText: 'Organisation',
                                  prefixIcon: Icon(Icons.business_outlined),
                                ),
                                items: _organizations.map((org) => DropdownMenuItem(
                                  value: org,
                                  child: Text(org),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOrganization = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner votre organisation';
                                  }
                                  return null;
                                },
                              ),

                              // Champ pour organisation personnalisée
                              if (_selectedOrganization == 'Autre')
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextFormField(
                                    controller: _organizationController,
                                    decoration: const InputDecoration(
                                      labelText: 'Précisez votre organisation',
                                      prefixIcon: Icon(Icons.edit),
                                    ),
                                    validator: (value) {
                                      if ((_selectedOrganization == 'Autre') &&
                                          (value == null || value.trim().isEmpty)) {
                                        return 'Veuillez saisir votre organisation';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                              const SizedBox(height: 16),

                              // Rôle
                              DropdownButtonFormField<String>(
                                value: _selectedRole,
                                decoration: const InputDecoration(
                                  labelText: 'Rôle/Fonction',
                                  prefixIcon: Icon(Icons.work_outlined),
                                ),
                                items: _roles.map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value ?? 'Géologue';
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              // Mot de passe
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  hintText: 'Minimum 6 caractères',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir un mot de passe';
                                  }
                                  if (value.length < 6) {
                                    return 'Le mot de passe doit contenir au moins 6 caractères';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Confirmation du mot de passe
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Confirmer le mot de passe',
                                  hintText: 'Retapez votre mot de passe',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez confirmer votre mot de passe';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Conditions d'utilisation
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _acceptTerms = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'J\'accepte les ',
                                        style: TextStyle(color: Colors.grey.shade600),
                                        children: const [
                                          TextSpan(
                                            text: 'conditions d\'utilisation',
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          TextSpan(text: ' et la '),
                                          TextSpan(
                                            text: 'politique de confidentialité',
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Bouton d'inscription
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: _isLoading
                                      ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Création du compte...'),
                                    ],
                                  )
                                      : const Text('Créer mon compte'),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Lien vers connexion
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Déjà un compte ? ',
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                  TextButton(
                                    onPressed: () => context.go('/auth/login'),
                                    child: const Text('Se connecter'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Column(
      children: [
        _buildStatItem('500 km²', 'Zone analysable en 5-6 jours'),
        const SizedBox(height: 16),
        _buildStatItem('85%', 'Précision de détection'),
        const SizedBox(height: 16),
        _buildStatItem('2 Types', 'Pegmatites identifiables'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}