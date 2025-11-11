import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_companion/routes/app_router.dart';
import 'package:forex_companion/core/theme/app_theme.dart';

/// [MyApp] is the root widget of the application.
/// It wraps the GoRouter configuration and applies the global theme.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We watch the Riverpod provider that holds our GoRouter instance.
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Forex Companion',
      debugShowCheckedModeBanner: false,

      // Apply the light and dark themes based on the OS setting.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Connect the GoRouter configuration.
      routerConfig: router,
    );
  }
}