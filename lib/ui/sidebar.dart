import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'dialogs.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Container(
      width: 250,
      color: const Color(0xFF252733),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('PROJECTS', () => showCreateProjectDialog(context, appState.addProject)),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: appState.projects.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(appState.projects[index].name),
                leading: const Icon(Icons.folder, size: 16),
                dense: true,
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.black26),
          _buildHeader('SAVED PAYLOADS', () => showCreatePayloadDialog(context, appState.addPayload)),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: appState.savedPayloads.length,
              itemBuilder: (context, index) {
                final payload = appState.savedPayloads[index];
                return ListTile(
                  title: Text(payload.name),
                  subtitle: Text(payload.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                  leading: const Icon(Icons.code, size: 16),
                  dense: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, VoidCallback onAdd) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: onAdd,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }
}