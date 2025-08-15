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
  Pocket(id: 1, area: Rect.fromLTWH(10, 30, 50, 100), fillColor: const Color.fromARGB(255, 223, 157, 137), shadowColor: const Color.fromARGB(255, 161, 120, 82)),
  Pocket(id: 2, area: Rect.fromLTWH(10, 180, 50, 100), fillColor: const Color.fromARGB(255, 206, 225, 119), shadowColor: const Color.fromARGB(255, 147, 150, 90)),
  Pocket(id: 3, area: Rect.fromLTWH(10, 330, 50, 100), fillColor: const Color.fromARGB(255, 116, 214, 210), shadowColor: const Color.fromARGB(255, 79, 151, 141)),
];
