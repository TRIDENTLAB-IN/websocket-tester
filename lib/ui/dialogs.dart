import 'package:flutter/material.dart';

void showCreateProjectDialog(BuildContext context, Function(String) onSave) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('CREATE PROJECT'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Project Name'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) onSave(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void showCreatePayloadDialog(BuildContext context, Function(String, String) onSave) {
  final nameController = TextEditingController();
  final contentController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('CREATE PAYLOAD'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Payload Name')),
          const SizedBox(height: 10),
          TextField(
            controller: contentController,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Content (JSON)'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) onSave(nameController.text, contentController.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}