import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/router.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ayumgdkxyphniugfzafh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5dW1nZGt4eXBobml1Z2Z6YWZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5NjIyOTIsImV4cCI6MjA2NzUzODI5Mn0.z-ttA9me4077i6z0H_TNblWZ5wv0U01gHD1q_-qdZTo',
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Pegmatites Detection - SODEMI',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Supabase client global
final supabase = Supabase.instance.client;