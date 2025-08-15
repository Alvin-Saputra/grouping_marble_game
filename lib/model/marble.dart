import 'package:flutter/material.dart';
class Marble {
  Offset position;
  final Color color;
  int groupId;
   bool isDragging;

  Marble({required this.position, required this.color, required this.groupId, this.isDragging = false});
}
