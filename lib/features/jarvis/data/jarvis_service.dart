import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/utils/app_logger.dart';

class JarvisService {
  GenerativeModel? _model;
  ChatSession? _chat;

  /// Initializes the Gemini model
  Future<void> initialize() async {
    try {
      // -----------------------------------------------------------
      // YOUR API KEY
      // I have placed your key here. For production, move this to
      // Firestore or an ENV file to keep it secure.
      // -----------------------------------------------------------
      const String myApiKey = "AIzaSyBRrf3oC4E0p9SgjLJg78AFfdWtRgVyqvE";

      // 1. Initialize the Model
      // We use 'gemini-1.5-pro' for the high-intelligence capabilities.
      _model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: myApiKey,
      );

      // 2. Start a chat session (allows the AI to remember context)
      _chat = _model!.startChat(history: [
        Content.text('You are Jarvis, an expert Forex trading assistant. Be concise and helpful.'),
      ]);

      AppLogger.info("Jarvis AI (Pro Model) initialized successfully.");
    } catch (e) {
      AppLogger.error("Failed to initialize Jarvis: $e");
    }
  }

  /// Sends a message to Jarvis and streams the response back
  Stream<String> sendMessage(String message) async* {
    if (_model == null || _chat == null) {
      yield "Jarvis is waking up... please wait a moment.";
      await initialize();
      // If it still fails, stop
      if (_model == null) {
        yield "System Error: Unable to connect to AI.";
        return;
      }
    }

    try {
      final response = _chat!.sendMessageStream(Content.text(message));
      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      AppLogger.error("Error sending message to Jarvis: $e");
      yield "I encountered an error processing that request.";
    }
  }
}