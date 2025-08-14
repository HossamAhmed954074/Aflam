import 'package:flutter/material.dart';

class AlertDialogCustom extends StatelessWidget {
  const AlertDialogCustom({
    super.key,
    required this.title, required this.buttonText, required this.text,
  });
final String title;
final String buttonText;
final String text;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(text),
      content: Text(
        title,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child:  Text(
            buttonText,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
