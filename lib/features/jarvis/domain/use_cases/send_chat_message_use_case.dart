// lib/features/jarvis/domain/use_cases/send_chat_message_use_case.dart

import '../models/chat_message.dart';
import '../repositories/jarvis_repository.dart';

/// Use Case: Send Chat Message
///
/// This class handles the core business logic of the Jarvis feature:
/// 1. Takes the user's message and the current history.
/// 2. Delegates the communication logic to the [JarvisRepository].
/// 3. Returns the model's response.
class SendChatMessageUseCase {
  final JarvisRepository _repository;

  SendChatMessageUseCase(this._repository);

  /// Executes the use case.
  ///
  /// Returns the model's new [ChatMessage].
  Future<ChatMessage> execute({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
  }) async {
    // Business logic related to conversation flow, such as pre-processing the
    // userMessage or managing history size limits, would happen here.

    // Delegate to the repository to handle data fetching/mapping
    return _repository.sendMessage(
      userMessage: userMessage,
      conversationHistory: conversationHistory,
    );
  }
}