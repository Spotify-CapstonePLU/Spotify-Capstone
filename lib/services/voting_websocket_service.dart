import 'package:web_socket_channel/web_socket_channel.dart';

class VotingWebSocketService {
  static const String baseUrl = 'http://127.0.0.1:3000';
  WebSocketChannel? _channel;

  Stream get stream {
    if (_channel == null) {
      throw StateError("WebSocket not connected");
    }
    return _channel!.stream;
  }

  void connect() {
    if (_channel != null) return; // already connected
    _channel = WebSocketChannel.connect(
      Uri.parse('$baseUrl/voting'),
    );
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}
