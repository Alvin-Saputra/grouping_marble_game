import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/marble.dart';

class Pocket {
  int id;
  final Rect area;
  Color fillColor;
  Color shadowColor;
  int marbleCount;
  List <Marble> marbles = [];
  bool? isCorrect;
  bool showResult = false; 

  Pocket({required this.id, required this.area, required this.fillColor, required this.shadowColor ,this.marbleCount = 0});
}

List<Pocket> pocketList = [
  Pocket(id: 1, area: Rect.fromLTWH(10, 30, 50, 100), fillColor: Colors.orange, shadowColor: Colors.deepOrange),
  Pocket(id: 2, area: Rect.fromLTWH(10, 180, 50, 100), fillColor: Colors.yellow, shadowColor: const Color.fromARGB(255, 252, 172, 2)),
  Pocket(id: 3, area: Rect.fromLTWH(10, 330, 50, 100), fillColor: Colors.blue, shadowColor: const Color.fromARGB(255, 4, 98, 175)),
];
