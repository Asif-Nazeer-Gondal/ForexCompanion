// lib/state/providers/jarvis_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/jarvis/data/jarvis_service.dart';
import '../../features/jarvis/domain/models/chat_message.dart';

final jarvisServiceProvider = Provider<JarvisService>((ref) {
  final service = JarvisService();
  service.initialize(); // Initialize on creation
  return service;
});

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({this.messages = const [], this.isLoading = false});
}

class ChatNotifier extends StateNotifier<ChatState> {
  final JarvisService _service;

  ChatNotifier(this._service) : super(ChatState()) {
    // Add initial greeting
    state = ChatState(messages: [
      ChatMessage(
        text: "Hello! I'm Jarvis, your AI Forex Assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ]);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(text: text, isUser: true, timestamp: DateTime.now());
    state = ChatState(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );

    try {
      // Add placeholder for AI response
      final aiMsgPlaceholder = ChatMessage(text: "...", isUser: false, timestamp: DateTime.now());
      state = ChatState(
        messages: [...state.messages, aiMsgPlaceholder],
        isLoading: true,
      );

      String fullResponse = "";
      await for (final chunk in _service.sendMessage(text)) {
        fullResponse += chunk;
        
        // Update the last message (AI response) with accumulated text
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages.removeLast();
        updatedMessages.add(ChatMessage(
          text: fullResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        
        state = ChatState(messages: updatedMessages, isLoading: true);
      }
      
      state = ChatState(messages: state.messages, isLoading: false);
    } catch (e) {
      state = ChatState(messages: state.messages, isLoading: false);
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final service = ref.watch(jarvisServiceProvider);
  return ChatNotifier(service);
});