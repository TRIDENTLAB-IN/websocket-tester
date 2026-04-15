import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_models.dart';
import '../state/app_state.dart';

class ConnectionColumn extends StatelessWidget {
  final WsConnectionState connectionState;

  const ConnectionColumn({Key? key, required this.connectionState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: connectionState,
      child: Consumer<WsConnectionState>(
        builder: (context, state, child) {
          return Container(
            margin: const EdgeInsets.only(right: 0),

            color: const Color(0xFF2B2D3A), // Dark column background
            child: Column(
              children: [
                // Top URL Bar
                Container(
                  padding: const EdgeInsets.all(8),
                  color: const Color(0xFF1E1F28),
                  child: Row(
                    children: [
                      Text(state.id, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: state.urlController,
                          decoration: const InputDecoration(
                            hintText: 'WebSocket URL',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.isConnected ? Colors.red : Colors.deepPurple,
                        ),
                        onPressed: state.isConnected ? state.disconnect : state.connect,
                        child: Text(state.isConnected ? 'Disconnect' : 'Connect'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => context.read<AppState>().removeConnection(state),
                      )
                    ],
                  ),
                ),
                // Payload Area
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Payload', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: state.payloadController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter JSON payload...',
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                        onPressed: state.sendMessage,
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.black26),
                // Output Area
                Expanded(
                  child: state.messages.isEmpty
                      ? const Center(child: Text('NO OUTPUT', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        color: msg.isSent ? Colors.transparent : Colors.black12,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(msg.isSent ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 16, color: msg.isSent ? Colors.green : Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(child: Text(msg.text, style: const TextStyle(fontFamily: 'monospace'))),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}