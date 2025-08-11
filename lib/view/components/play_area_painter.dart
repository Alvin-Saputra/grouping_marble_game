// lib/view/components/play_area_painter.dart

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

    for (var eachPocket in pocket) {
      // shadow
      paint
        ..style = PaintingStyle.fill
        ..color = eachPocket.shadowColor;
      final shadowOffset = Offset(8, 8);
      final shadowRect = eachPocket.area.shift(shadowOffset);
      canvas.drawRect(shadowRect, paint);

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
      if (eachPocket.showResult && eachPocket.isCorrect != null) {
        IconData iconData = eachPocket.isCorrect! ? Icons.check : Icons.close;
        Color iconColor = eachPocket.isCorrect! ? Colors.green : Colors.red;

        final textSpan = TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontSize: 40.0,
            fontFamily: iconData.fontFamily,
            color: iconColor,
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

     

    paint.style = PaintingStyle.fill;
    for (var marble in marbles) {
      paint.color = marble.color;
      canvas.drawCircle(marble.position, 15, paint);
    }


     paint.style = PaintingStyle.fill;
    for (var marble in marbles) {
      // 1. Hitung jumlah kelereng dalam grup kelereng ini
      final groupSize = marbles.where((m) => m.groupId == marble.groupId).length;

      // 2. Tentukan warna berdasarkan jumlah grup
      Color displayColor;
      switch (groupSize) {
        case 1:
          displayColor = marble.color; // Kembali ke warna asli jika sendirian
          break;
        case 2:
          displayColor = Colors.blue;
          break;
        case 3:
          displayColor = Colors.purple;
          break;
        case 4:
          displayColor = Colors.red;
          break;
        case 5:
          displayColor = Colors.orange;
          break;
        case 6:
          displayColor = Colors.yellow;
          break;
        case 7:
          displayColor = Colors.pink;
          break;
        case 8:
          displayColor = Colors.cyan; 
          break;
        case 9: 
          displayColor = Colors.brown; 
          break;
        case 10:
          displayColor = Colors.teal;
          break;
        case 11:
          displayColor = Colors.lime; 
          break;
        case 12:
          displayColor = Colors.indigo;
          break;
        case 13:
          displayColor = Colors.amber;
          break;
        case 14:
          displayColor = Colors.deepOrange;
          break;
        case 15:
          displayColor = Colors.lightBlue;
          break;
        case 16:
          displayColor = Colors.lightGreen;
          break;
        case 17:
          displayColor = Colors.purpleAccent;
          break;
        case 18:
          displayColor = Colors.blueGrey;
          break;
        case 19:
          displayColor = Colors.deepPurple;
          break;
        case 20:
          displayColor = Colors.grey;
          break;
        case 21:
          displayColor = Colors.cyanAccent;
          break;  
        case 22:
          displayColor = Colors.tealAccent;
          break;
        case 23:
          displayColor = Colors.orangeAccent;
          break;  
        case 24:
          displayColor = Colors.redAccent;
        // Anda bisa menambahkan case lain di sini, misal: case 5, case 6, dst.
        default:
          displayColor = Colors.green; // Warna default untuk grup > 4
      }

      // 3. Gunakan warna yang sudah ditentukan untuk menggambar
      paint.color = displayColor;
      canvas.drawCircle(marble.position, 15, paint);
    }

     final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final groupIds = marbles.map((m) => m.groupId).toSet();

    for (final id in groupIds) {
      final group = marbles.where((m) => m.groupId == id).toList();

      if (group.length > 1) {
        // Loop melalui setiap kelereng dalam grup
        for (int i = 0; i < group.length; i++) {
          // Loop lagi untuk menghubungkan ke kelereng lain
          for (int j = i + 1; j < group.length; j++) {
            // Gambar garis dari kelereng 'i' ke kelereng 'j'
            canvas.drawLine(group[i].position, group[j].position, linePaint);
          }
        }
      }
    }


    

    for (var eachPocket in pocket) {
      const int marblePerRow = 4;
      const double spacing = 20.0;
      const double rowSpacing = 25.0;
      final topLeft = eachPocket.area.topLeft;

      for (int i = 0; i < eachPocket.marbles.length; i++) {
        final marble = eachPocket.marbles[i];
       
        
        int row = i ~/ marblePerRow;
        int col = i % marblePerRow;

        Offset offset = Offset(
          (col - (marblePerRow - 1) / 2) * spacing + 30,
          row * rowSpacing,
        );
        // fill
      paint
        ..style = PaintingStyle.fill
        ..color = eachPocket.fillColor;
        canvas.drawCircle(topLeft + offset, 15, paint);

         paint
        ..style = PaintingStyle.stroke
        ..color = eachPocket.shadowColor
        ..strokeWidth = 2;
        canvas.drawCircle(topLeft + offset, 15, paint);
      }

      
    }
  }

  @override
  bool shouldRepaint(covariant PlayAreaPainter oldDelegate) => true;
}