import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/view/components/marble.dart';
import 'package:marble_grouping_game/view/components/pocket.dart';

class MarblePocket extends CustomPainter {
  final List<Marble> marbles;
  final List<Pocket> pockets;

  MarblePocket({required this.marbles, required this.pockets});

  @override
  void paint(Canvas canvas, Size size) {
    PocketPainter(pockets).paint(canvas, size);
    MarblePainter(marbles).paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}