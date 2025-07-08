import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Provider pour l'état d'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

// StreamProvider pour les changements d'état d'authentification
final authStateChangeStreamProvider = StreamProvider<User?>((ref) {
  return supabase.auth.onAuthStateChange.map((event) {
    log('Auth state changed: ${event.session?.user?.id}');
    return event.session?.user;
  });
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    // État initial
    final currentUser = supabase.auth.currentUser;
    state = currentUser != null
        ? AsyncValue.data(currentUser)
        : const AsyncValue.data(null);

    // Écouter les changements futurs
    supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      state = session?.user != null
          ? AsyncValue.data(session!.user)
          : const AsyncValue.data(null);
    });
  }

  // Connexion avec email/mot de passe
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      state = const AsyncValue.loading();

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = AsyncValue.data(response.user);
      } else {
        state = AsyncValue.error('Échec de la connexion', StackTrace.current);
        throw AuthException('Échec de la connexion');
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  // Inscription avec email/mot de passe et profil
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String organization,
    required String role,
  }) async {
    try {
      state = const AsyncValue.loading();

      log('Début de l\'inscription pour: $email');

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'organization': organization,
          'role': role,
        },
      );

      log('Réponse auth.signUp: ${response.user?.id}');

      if (response.user != null) {
        try {
          // Créer le profil utilisateur dans la table profiles
          await _createUserProfile(response.user!, fullName, organization, role);
          log('Profil créé avec succès');

          state = AsyncValue.data(response.user);
        } catch (profileError) {
          log('Erreur création profil: $profileError');

          // Optionnel : supprimer l'utilisateur auth si le profil échoue
          // await supabase.auth.signOut();

          state = AsyncValue.error(
              'Compte créé mais erreur profil: $profileError',
              StackTrace.current
          );
          throw AuthException('Erreur lors de la création du profil: $profileError');
        }
      } else {
        state = AsyncValue.error('Échec de l\'inscription', StackTrace.current);
        throw AuthException('Échec de l\'inscription');
      }
    } catch (error) {
      log('Erreur générale inscription: $error');
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> _createUserProfile(
      User user,
      String fullName,
      String organization,
      String role,
      ) async {
    try {
      // Attendre un peu pour s'assurer que l'utilisateur est complètement créé
      await Future.delayed(const Duration(milliseconds: 500));

      final now = DateTime.now().toIso8601String();

      final profileData = {
        'id': user.id,
        'full_name': fullName,
        'email': user.email,
        'organization': organization,
        'role': role,
        'created_at': now,
        'updated_at': now,
        'is_active': true, // Ajout du champ is_active
      };

      log('Tentative d\'insertion du profil: $profileData');

      final response = await supabase
          .from('profiles')
          .insert(profileData)
          .select(); // Ajout de select() pour récupérer la réponse

      log('Profil créé avec succès: $response');

    } catch (error, stackTrace) {
      log('Erreur lors de la création du profil: $error');
      log('StackTrace: $stackTrace');

      // Re-lancer l'erreur pour qu'elle soit gérée au niveau supérieur
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Erreur lors de la réinitialisation: $error');
    }
  }
}

// Provider pour les informations du profil utilisateur
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authProvider);

  return authState.when(
    data: (user) async {
      if (user == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return response;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// États d'authentification utiles
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Exceptions personnalisées pour l'authentification
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, [this.code]);

  @override
  String toString() => 'AuthException: $message';
}

// Helper pour gérer les erreurs d'authentification Supabase
String getAuthErrorMessage(dynamic error) {
  if (error is AuthException) {
    switch (error.message) {
      case 'Invalid login credentials':
        return 'Email ou mot de passe incorrect';
      case 'Email not confirmed':
        return 'Veuillez confirmer votre email avant de vous connecter';
      case 'User already registered':
        return 'Un compte existe déjà avec cet email';
      case 'Password should be at least 6 characters':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      default:
        return error.message;
    }
  }

  final errorString = error.toString().toLowerCase();

  if (errorString.contains('invalid login credentials')) {
    return 'Email ou mot de passe incorrect';
  } else if (errorString.contains('email not confirmed')) {
    return 'Veuillez confirmer votre email avant de vous connecter';
  } else if (errorString.contains('user already registered')) {
    return 'Un compte existe déjà avec cet email';
  } else if (errorString.contains('password')) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
  } else if (errorString.contains('network')) {
    return 'Problème de connexion réseau';
  }

  return 'Une erreur inattendue s\'est produite';
}