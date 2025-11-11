// lib/features/jarvis/data/repositories/jarvis_repository_impl.dart

import 'package:uuid/uuid.dart';

import '../../../core/data/dependencies/dependencies.dart'; // Assuming dependencies.dart provides Riverpod Providers
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/jarvis_repository.dart';
import '../services/jarvis_service.dart';

// Assuming you have a Riverpod Provider for the service in core/data/dependencies/
// Example: final jarvisServiceProvider = Provider<JarvisService>((ref) => JarvisServiceImpl());
// For simplicity here, we'll instantiate directly or rely on the DI setup.

/// Implementation of the JarvisRepository contract.
///
/// This class handles:
/// 1. Converting Domain Models (ChatMessage) into Data Service DTOs (Content).
/// 2. Calling the external service (JarvisService).
/// 3. Converting Service responses back into Domain Models.
/// 4. Handling low-level data errors and transforming them into Domain Exceptions (not shown, but best practice).
class JarvisRepositoryImpl implements JarvisRepository {
  final JarvisService _jarvisService;
  final Uuid _uuid;

  JarvisRepositoryImpl(this._jarvisService) : _uuid = const Uuid();

  /// Converts a Domain ChatMessage list to the Gemini API's Content DTO list.
  List<Content> _mapToContent(List<ChatMessage> history) {
    return history.map((msg) {
      return Content(
        role: msg.role,
        parts: [Part(text: msg.text)],
      );
    }).toList();
  }

  @override
  Future<ChatMessage> sendMessage({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
  }) async {
    // 1. Add the new user message to the history list for context
    final userMsgContent = ChatMessage(
      id: _uuid.v4(),
      role: 'user',
      text: userMessage,
      timestamp: DateTime.now(),
    );

    final historyWithNewMessage = [...conversationHistory, userMsgContent];

    // 2. Convert the full history into the API-compatible Content DTOs
    final contentHistory = _mapToContent(historyWithNewMessage);

    // 3. Call the service
    final responseText = await _jarvisService.generateResponse(contentHistory);

    // 4. Map the raw response text back to a Domain ChatMessage
    final modelResponse = ChatMessage(
      id: _uuid.v4(),
      role: 'model',
      text: responseText,
      timestamp: DateTime.now(),
    );

    return modelResponse;
  }
}