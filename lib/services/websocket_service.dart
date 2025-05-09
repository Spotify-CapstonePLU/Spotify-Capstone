import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  Stream get stream {
    if (_channel == null) {
      throw StateError("WebSocket not connected");
    }
    return _channel!.stream;
  }

  void connect(String url) {
    if (_channel != null) return; // already connected
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
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
