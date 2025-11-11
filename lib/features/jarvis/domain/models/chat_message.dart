// lib/features/jarvis/domain/models/chat_message.dart

/// The core domain model representing a message in the Jarvis chat.
/// This model is immutable and is used across the Domain and Presentation layers.
class ChatMessage {
  final String id;
  final String role; // 'user' or 'model'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });
}