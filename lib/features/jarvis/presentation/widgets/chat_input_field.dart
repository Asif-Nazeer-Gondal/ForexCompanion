// lib/features/jarvis/presentation/widgets/chat_input_field.dart

import 'package:flutter/material.dart';
// Assuming AppColors is available via a relative import or core library
import '../../../../core/theme/app_colors.dart';

/// The input field for the chat, including the send button and loading indicator.
class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.trim().isNotEmpty && !widget.isLoading) {
      widget.onSend(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: Copy the complete ChatInputField widget implementation from your
    // original jarvis_page.dart and paste it here.

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.isLoading ? 'Jarvis is thinking...' : 'Ask Jarvis about finance...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
              ),
              onSubmitted: (_) => _handleSend(),
              readOnly: widget.isLoading,
            ),
          ),
          const SizedBox(width: 8),
          widget.isLoading
              ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          )
              : IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// NOTE: You must also ensure your AppColors class is accessible in this file.
// If it's located in core/theme/app_colors.dart, the import path should be correct.
abstract class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF64B5F6);
}