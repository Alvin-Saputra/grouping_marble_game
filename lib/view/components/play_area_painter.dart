import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/model/pocket.dart';

class PlayAreaPainter extends CustomPainter {
  final List<Marble> marbles;
  final List<Pocket> pocket;

  PlayAreaPainter(this.marbles, this.pocket);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Gambar kantong
    for (var rect in pocket) {
      // Reset ke fill untuk isi kantong
      paint
        ..style = PaintingStyle.fill
        ..color = Colors.brown.withOpacity(0.4);
      canvas.drawRect(rect.area, paint);

      // Gambar border kantong
      paint
        ..style = PaintingStyle.stroke
        ..color = Colors.brown
        ..strokeWidth = 3;
      canvas.drawRect(rect.area, paint);
    }

    // Gambar kelereng
    paint.style = PaintingStyle.fill;
    for (var marble in marbles) {
      paint.color = marble.color;
      canvas.drawCircle(marble.position, 15, paint);
    }

    for (var marbleInPocket in pocket) {
      // Gambar kelereng dalam kantong
      for (var marble in marbleInPocket.marbles) {
        paint.color = marble.color;
        canvas.drawCircle(marble.position, 15, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlayAreaPainter oldDelegate) => true;
}
