// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/settings_service.dart';
import 'state/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'state/providers/sync_provider.dart';
import 'features/offline/local_cache.dart';
import 'core/services/notification_service.dart';

Future<void> main() async { // Make main an async function
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Settings Service (Hive)
  await SettingsService().initialize();

  // Initialize LocalCache
  await LocalCache().initialize();

  // Initialize Notification Service
  await NotificationService().initialize();

  // TODO: Access the Gemini API key here using dotenv.env['GEMINI_API_KEY']
  // and pass it to the google_generative_ai initialization as needed.

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: ForexAdvisorApp(),
    ),
  );
}

class ForexAdvisorApp extends ConsumerWidget {
  const ForexAdvisorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);
    
    // Initialize SyncManager to listen for connectivity changes
    ref.watch(syncManagerProvider);

    return MaterialApp.router(
      title: 'ForexAdvisor',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Router
      routerConfig: router,
    );
  }
}