import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Project> projects = [];
  List<SavedPayload> savedPayloads = [];
  List<WsConnectionState> activeConnections = [];

  int _connectionCounter = 1;
  int activeConnectionIndex = 0; // Tracks which tab/column is selected

  void setActiveConnection(int index) {
    activeConnectionIndex = index;
    notifyListeners();
  }

  void applyPayloadToActiveConnection(String content) {
    if (activeConnections.isNotEmpty && activeConnectionIndex < activeConnections.length) {
      // Update the controller directly so the UI reflects the change immediately
      activeConnections[activeConnectionIndex].payloadController.text = content;
      notifyListeners();
    }
  }

  AppState() {
    _loadData();
    addConnection(); // Start with one empty column
  }

  Future<void> _loadData() async {
    final data = await _storageService.loadData();
    if (data != null) {
      if (data['projects'] != null) {
        projects = (data['projects'] as List).map((e) => Project.fromJson(e)).toList();
      }
      if (data['payloads'] != null) {
        savedPayloads = (data['payloads'] as List).map((e) => SavedPayload.fromJson(e)).toList();
      }
      notifyListeners();
    }
  }

  void _saveData() {
    _storageService.saveData(projects, savedPayloads);
  }

  void addProject(String name) {
    projects.add(Project(id: DateTime.now().toString(), name: name));
    _saveData();
    notifyListeners();
  }

  void addPayload(String name, String content) {
    savedPayloads.add(SavedPayload(id: DateTime.now().toString(), name: name, content: content));
    _saveData();
    notifyListeners();
  }

  void addConnection() {
    activeConnections.add(WsConnectionState(id: '#${_connectionCounter++}'));
    notifyListeners();
  }

  void removeConnection(WsConnectionState conn) {
    conn.disconnect();
    activeConnections.remove(conn);
    notifyListeners();
  }
}