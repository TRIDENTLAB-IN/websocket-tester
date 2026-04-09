import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/data_models.dart';

class StorageService {
  static const String _fileName = 'ws_king_data.json';

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> saveData(List<Project> projects, List<SavedPayload> payloads) async {
    final file = await _localFile;
    final data = {
      'projects': projects.map((p) => p.toJson()).toList(),
      'payloads': payloads.map((p) => p.toJson()).toList(),
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadData() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      print("Error loading data: $e");
      return null;
    }
  }
}