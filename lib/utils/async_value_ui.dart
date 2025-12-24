// lib/utils/async_value_ui.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI<T> on AsyncValue<T> {
  Widget buildWhen({
    required Widget Function(T data) data,
    Widget Function()? loading,
    Widget Function(Object error, StackTrace stackTrace)? error,
  }) {
    return when(
      data: data,
      loading: loading ?? () => const Center(child: CircularProgressIndicator()),
      error: error ?? (e, st) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $e', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}