import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Feature Imports ---
import '../features/splash/splash_screen.dart';
import '../features/forex/presentation/home/home_screen.dart'; 
import '../features/budget/presentation/input/budget_input_screen.dart';
import '../features/budget/presentation/summary/budget_summary_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../core/widgets/scaffold_with_navbar.dart'; 

// --- Global Navigator Keys ---
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/forex', 
    routes: [

      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [

          // --- Branch 1: FOREX (Home) ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/forex',
                name: 'forex_home',
                builder: (context, state) => const HomeScreen(),
                routes: const [], 
              ),
            ],
          ),

          // --- Branch 2: BUDGET ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/budget',
                name: 'budget_summary',
                builder: (context, state) => const BudgetSummaryScreen(),
                routes: [
                  GoRoute(
                    path: 'input', 
                    name: 'budget_input',
                    builder: (context, state) => const BudgetInputScreen(),
                  ),
                ],
              ),
            ],
          ),

          // --- Branch 3: SETTINGS ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
