import 'package:flutter/material.dart';

class DialogCard extends StatelessWidget {
  DialogCard(
    this.title,
    this.description,
    this.icon,
    this.isCorrect, {
    super.key,
  });
  String title;
  String description;
  IconData icon;
  bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(icon, color: isCorrect ? Colors.green : Colors.red),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        description,
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
