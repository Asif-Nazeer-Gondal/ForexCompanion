// Path: lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// FIXED: Use a more robust package-style import. This assumes your pubspec.yaml name is 'forex_companion'
import 'package:forex_companion/providers/theme_provider.dart';
import 'package:forex_companion/core/theme/app_theme.dart';

class ForexCompanionApp extends ConsumerWidget {
  const ForexCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Forex Companion',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const Scaffold(
        body: Center(
          child: Text('Setup Complete!'),
        ),
      ),
    );
  }
}
