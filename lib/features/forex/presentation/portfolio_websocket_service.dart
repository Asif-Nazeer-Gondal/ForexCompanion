import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/utils/app_logger.dart';

class PortfolioWebsocketService {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  final AppLogger _logger = AppLogger();

  PortfolioWebsocketService({required this.url});

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect() {
    try {
      _logger.info('Connecting to Portfolio WebSocket: $url');
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            _controller.add(data);
          } catch (e) {
            _logger.error('Error parsing websocket message', e);
          }
        },
        onError: (error) {
          _logger.error('WebSocket error', error);
        },
        onDone: () {
          _logger.info('WebSocket connection closed');
        },
      );
    } catch (e) {
      _logger.error('Connection failed', e);
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _logger.info('Disconnected from Portfolio WebSocket');
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}

final portfolioWebsocketServiceProvider = Provider<PortfolioWebsocketService>((ref) {
  // In a real app, URL should come from environment config
  const wsUrl = 'ws://localhost:8000/ws/portfolio';
  final service = PortfolioWebsocketService(url: wsUrl);
  ref.onDispose(() => service.dispose());
  return service;
});