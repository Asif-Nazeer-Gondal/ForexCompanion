// lib/features/jarvis/domain/repositories/jarvis_repository.dart

import '../models/chat_message.dart';

/// The contract for the Jarvis data operations.
/// This is an abstract interface that defines the capabilities of the Jarvis data layer
/// as seen by the domain layer (Use Cases).
abstract class JarvisRepository {
  /// Sends a new message and the current conversation history to the AI.
  ///
  /// Returns the model's generated response as a ChatMessage.
  Future<ChatMessage> sendMessage({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
  });
}