import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/utils/shape_painter_helper.dart';

class MarblePainter extends CustomPainter {
  final List<Marble> marbles;

  MarblePainter(this.marbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Gambar kelereng
     for (var marble in marbles) {
      ShapePainterHelper.drawCircle(
        canvas: canvas,
        center: marble.position,
        radius: 25,
        fillColor: marble.color,
        borderColor: Colors.black,
      );
  }

}

   @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
