import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'sidebar.dart';
import 'connection_column.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket King', style: TextStyle(fontSize: 14)),
        backgroundColor: const Color(0xFF1E1F28),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Connection'),
            onPressed: appState.addConnection,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFF1E1F28),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: appState.activeConnections.length,
                itemBuilder: (context, index) {
                  return ConnectionColumn(
                    connectionState: appState.activeConnections[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}