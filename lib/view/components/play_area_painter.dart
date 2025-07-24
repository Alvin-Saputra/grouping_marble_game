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
    for (var eachPocket in pocket) {
      // shadow
      paint
        ..style = PaintingStyle.fill
        ..color = eachPocket.shadowColor; // Warna shadow gelap transparan

      final shadowOffset = Offset(8, 8); // Geser ke kanan dan bawah
      final shadowRect = eachPocket.area.shift(shadowOffset);

      canvas.drawRect(shadowRect, paint); // Gambar shadow-nya dulu

      // fill
      paint
        ..style = PaintingStyle.fill
        ..color = eachPocket.fillColor;
      canvas.drawRect(eachPocket.area, paint);

      // border
      paint
        ..style = PaintingStyle.stroke
        ..color = eachPocket.shadowColor
        ..strokeWidth = 4;
      canvas.drawRect(eachPocket.area, paint);
    }

    for (var eachPocket in pocket) {
      if (!eachPocket.showResult || eachPocket.isCorrect == null)
        continue; 
      else if ((eachPocket.showResult == true && eachPocket.isCorrect != null)) {
        final textSpan = TextSpan(
          text: eachPocket.isCorrect! ? '✔' : '✖',
          style: TextStyle(
            fontSize: 24,
            color: eachPocket.isCorrect! ? Colors.green : Colors.red,
          ),
        );

        final tp = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        tp.layout();

        final offset = Offset(
          eachPocket.area.center.dx - tp.width / 2,
          eachPocket.area.center.dy - tp.height / 2,
        );
        tp.paint(canvas, offset);
      }
    }

    // Gambar kelereng
    paint.style = PaintingStyle.fill;
    for (var marble in marbles) {
      paint.color = marble.color;
      canvas.drawCircle(marble.position, 15, paint);
    }

    for (var eachPocket in pocket) {
      const int marblePerRow = 4;
      const double spacing = 20.0;
      const double rowSpacing = 25.0;
      final topLeft = eachPocket.area.topLeft;

      for (int i = 0; i < eachPocket.marbles.length; i++) {
        final marble = eachPocket.marbles[i];
        paint.color = marble.color;

        int row = i ~/ marblePerRow; // integer division untuk baris ke berapa
        int col = i % marblePerRow; // sisa bagi untuk kolom

        // Hitung offset posisi
        Offset offset = Offset(
          (col - (marblePerRow - 1) / 2) * spacing +
              30, // +10 agar geser ke kanan
          row * rowSpacing,
        );

        canvas.drawCircle(topLeft + offset, 15, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlayAreaPainter oldDelegate) => true;
}
