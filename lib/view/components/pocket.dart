import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/utils/shape_painter_helper.dart';

class PocketPainter extends CustomPainter {
  final List<Pocket> pockets;

  PocketPainter(this.pockets);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var pocket in pockets) {
      ShapePainterHelper.drawRoundedRect(
        canvas: canvas,
        rect: pocket.area,
        borderRadius: 8,
        fillColor: Colors.brown.withOpacity(0.4),
        borderColor: Colors.brown,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PocketPainter oldDelegate) =>
      oldDelegate.pockets != pockets;
}
