// lib/app.dart
import 'package:flutter/material.dart';

class ForexCompanionApp extends StatelessWidget {
  const ForexCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forex Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Forex Companion'),
        ),
        body: const Center(
          child: Text('Welcome to Forex Companion!'),
        ),
      ),
    );
  }
}