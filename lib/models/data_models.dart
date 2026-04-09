import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Project {
  String id;
  String name;

  Project({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
  );
}

class SavedPayload {
  String id;
  String name;
  String content;

  SavedPayload({required this.id, required this.name, required this.content});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'content': content};
  factory SavedPayload.fromJson(Map<String, dynamic> json) => SavedPayload(
    id: json['id'],
    name: json['name'],
    content: json['content'],
  );
}

class WsMessage {
  final String text;
  final bool isSent;
  final DateTime timestamp;

  WsMessage({required this.text, required this.isSent, required this.timestamp});
}

// Holds the state for a single column (not saved to JSON, runtime only)
class WsConnectionState extends ChangeNotifier {
  final String id;
  String url = '';
  WebSocketChannel? channel;
  bool isConnected = false;
  List<WsMessage> messages = [];

  TextEditingController urlController = TextEditingController();
  TextEditingController payloadController = TextEditingController();

  WsConnectionState({required this.id});

  void connect() {
    if (urlController.text.isEmpty) return;
    try {
      url = urlController.text;
      channel = WebSocketChannel.connect(Uri.parse(url));
      isConnected = true;
      notifyListeners();

      channel!.stream.listen(
            (message) {
          messages.add(WsMessage(text: message.toString(), isSent: false, timestamp: DateTime.now()));
          notifyListeners();
        },
        onDone: () => _disconnectLocal(),
        onError: (e) => _disconnectLocal(),
      );
    } catch (e) {
      _disconnectLocal();
    }
  }

  void sendMessage() {
    if (isConnected && channel != null && payloadController.text.isNotEmpty) {
      final msg = payloadController.text;
      channel!.sink.add(msg);
      messages.add(WsMessage(text: msg, isSent: true, timestamp: DateTime.now()));
      notifyListeners();
    }
  }

  void disconnect() {
    channel?.sink.close();
    _disconnectLocal();
  }

  void _disconnectLocal() {
    isConnected = false;
    channel = null;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    urlController.dispose();
    payloadController.dispose();
    super.dispose();
  }
}