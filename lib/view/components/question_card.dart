import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({required this.questionText,super.key});

  late final String questionText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.deepPurple, // Warna latar belakang card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Radius sudut card
        side: BorderSide(
          color: const Color.fromARGB(255, 50, 17, 107), // Warna border
          width: 6.0, // Ketebalan border
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35.0),
          child: Text(
            questionText,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
