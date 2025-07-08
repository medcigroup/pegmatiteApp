import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/landing_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/dashboard/dashboard_page.dart';
import '../screens/dashboard/analysis_page.dart';
import '../screens/dashboard/results_page.dart';
import '../screens/dashboard/settings_page.dart';
import '../providers/auth_provider.dart';

// Helper pour connecter les streams au routeur
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  // Utiliser le stream d'authentification de Supabase
  final authStream = ref.watch(authStateChangeStreamProvider.stream);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // Activer les logs de navigation
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.value != null;
      final location = state.matchedLocation;

      debugPrint('Redirection: isLoggedIn=$isLoggedIn, location=$location');

      if (isLoggedIn) {
        if (location == '/' || location.startsWith('/auth')) {
          return '/dashboard';
        }
      } else {
        if (location.startsWith('/dashboard')) {
          return '/auth/login';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        pageBuilder: (context, state) => const MaterialPage(child: LandingPage()),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        pageBuilder: (context, state) => const MaterialPage(child: RegisterPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => const MaterialPage(child: DashboardPage()),
          ),
          GoRoute(
            path: '/dashboard/analysis',
            name: 'analysis',
            pageBuilder: (context, state) => const MaterialPage(child: AnalysisPage()),
          ),
          GoRoute(
            path: '/dashboard/results',
            name: 'results',
            pageBuilder: (context, state) => const MaterialPage(child: ResultsPage()),
          ),
          GoRoute(
            path: '/dashboard/settings',
            name: 'settings',
            pageBuilder: (context, state) => const MaterialPage(child: SettingsPage()),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page non trouvée: ${state.uri}'),
      ),
    ),
  );
});

// Shell pour le dashboard avec navigation latérale
class DashboardShell extends StatelessWidget {
  final Widget child;

  const DashboardShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation latérale
          const DashboardSidebar(),
          // Contenu principal
          Expanded(child: child),
        ],
      ),
    );
  }
}

class DashboardSidebar extends ConsumerWidget {
  const DashboardSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header avec logo SODEMI
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.terrain,
                    size: 30,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SODEMI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Pegmatites Detection',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isActive: currentLocation == '/dashboard',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.analytics,
                  title: 'Analyse Spectrale',
                  route: '/dashboard/analysis',
                  isActive: currentLocation == '/dashboard/analysis',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.map,
                  title: 'Résultats',
                  route: '/dashboard/results',
                  isActive: currentLocation == '/dashboard/results',
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Paramètres',
                  route: '/dashboard/settings',
                  isActive: currentLocation == '/dashboard/settings',
                ),
              ],
            ),
          ),

          // User profile et logout
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(color: Colors.white24),
                Consumer(
                    builder: (context, ref, _) {
                      final authState = ref.watch(authProvider);
                      final user = authState.asData?.value;

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Color(0xFF2E7D32)),
                        ),
                        title: Text(
                          user?.email ?? 'Utilisateur',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        subtitle: Text(
                          user?.email ?? 'non connecté',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white70),
                          onPressed: () async {
                            await ref.read(authProvider.notifier).signOut();
                            if (context.mounted) context.go('/');
                          },
                        ),
                      );
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        required bool isActive,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        onTap: () => context.go(route),
      ),
    );
  }
}