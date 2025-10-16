import 'package:flutter/material.dart';

Future<String?> showNameDialog(BuildContext context, {String? initial}) {
  final controller = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Enter name'),
      content: TextField(
        controller: controller,
        maxLength: 12,
        decoration: const InputDecoration(hintText: 'Your name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop('::SKIP::'),
          child: const Text('Skip'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
