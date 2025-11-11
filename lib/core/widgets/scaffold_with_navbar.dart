import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// This widget acts as the container for the persistent UI shell (e.g., BottomNavigationBar)
class ScaffoldWithNavBar extends StatelessWidget {
  // FIX: Converted 'key' to a super parameter for clean, modern Dart syntax
  const ScaffoldWithNavBar({
    super.key, // Now uses the new super.key syntax
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Navigate to the initial route if the intended branch is already active
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell, // The child content (the active route)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
        items: const [
          BottomNavigationBarItem(label: 'Forex', icon: Icon(Icons.currency_exchange)),
          BottomNavigationBarItem(label: 'Budget', icon: Icon(Icons.account_balance_wallet)),
          BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}

