// lib/features/jarvis/presentation/widgets/chat_bubble.dart

import 'package:flutter/material.dart';
// Assuming AppColors is available via a relative import or core library
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/chat_message.dart';

/// Reusable widget for a single chat message bubble.
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // NOTE: Copy the complete ChatBubble widget implementation from your
    // original jarvis_page.dart and paste it here.

    final isUser = message.role == 'user';
    final isModel = message.role == 'model';
    final isSystem = message.role == 'system';

    // Placeholder logic - replace with your actual implementation:
    Color backgroundColor = isUser ? AppColors.secondary : AppColors.surface;
    Alignment alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
              )
            ]
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontStyle: isSystem ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ),
    );
  }
}