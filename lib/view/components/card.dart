import 'package:flutter/material.dart';
import 'package:marble_grouping_game/utils/shape_painter_helper.dart';


class CardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    ShapePainterHelper.drawRoundedRect(
      canvas: canvas,
      rect: rect,
      borderRadius: 20,
      fillColor: Colors.purple[400]!,
      borderColor: Colors.deepPurple[900]!,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
