// lib/features/jarvis/presentation/state/jarvis_state.dart

import '../../domain/models/chat_message.dart';

/// Represents the entire state of the Jarvis AI conversation feature.
class JarvisState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  JarvisState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  /// Factory constructor for the initial state.
  factory JarvisState.initial() => JarvisState(
    messages: [
      // Initial greeting message from Jarvis
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'model',
        text:
        "Hello! I'm Jarvis, your AI financial assistant. How can I help you with your forex, budget, or general finance questions today?",
        timestamp: DateTime.now(),
      ),
    ],
  );

  /// Creates a copy of the state, optionally updating fields.
  JarvisState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return JarvisState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Error is explicitly passed, allowing nulling out errors
    );
  }
}