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
    final connections = appState.activeConnections;
    final bool useTabs = connections.length > 4;

    return DefaultTabController(
      length: connections.length,
      child: Builder(builder: (context) {
        // Only try to listen to the controller if it's currently active
        final TabController? tabController = DefaultTabController.of(context);

        tabController?.addListener(() {
          if (!tabController.indexIsChanging) {
            appState.setActiveConnection(tabController.index);
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('WebSocket King', style: TextStyle(fontSize: 14)),
            backgroundColor: const Color(0xFF1E1F28),
            bottom: useTabs
                ? TabBar(
              isScrollable: true,
              tabs: connections.map((c) => Tab(text: c.id)).toList(),
            )
                : null,
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
              const VerticalDivider(width: 1, color: Colors.black26),
              Expanded(
                child: Container(
                  color: const Color(0xFF1E1F28),
                  child: _buildConnectionView(appState, connections, useTabs),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildConnectionView(AppState appState, List<dynamic> connections, bool useTabs) {
    if (connections.isEmpty) {
      return const Center(child: Text("No active connections. Click 'Add Connection'"));
    }

    if (useTabs) {
      return TabBarView(
        children: connections.map((conn) {
          return ConnectionColumn(connectionState: conn);
        }).toList(),
      );
    } else {
      return Row(
        children: List.generate(connections.length, (index) {
          final conn = connections[index];
          return Expanded(
            child: GestureDetector(
              onTapDown: (_) => appState.setActiveConnection(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: appState.activeConnectionIndex == index
                        ? Colors.deepPurple
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ConnectionColumn(connectionState: conn),
              ),
            ),
          );
        }),
      );
    }
  }
}