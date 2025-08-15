import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/marble.dart';

class MarbleController extends GetxController {
  var marbles = <Marble>[];
  int nextGroupId = 0;
  late Size canvasSize;

  final Map<int, double> _groupAngles = {};

  void generateMarbles(Size size, List<Rect> pockets) {
    if (marbles.isNotEmpty) {
      marbles.clear();
      nextGroupId = 0;
    }

    canvasSize = size;
    if (size.width <= 0 || size.height <= 0) return;

    final List<Color> colorPalette = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
    ];

    final rand = Random();
    final safeDistanceFromPocket = 75.0;
    final marbleRadius = 20.0;

    int totalMarblesToGenerate = 24;
    for (int i = 0; i < totalMarblesToGenerate; i++) {
      int attempts = 0;
      int maxAttempts = 1000;

      while (attempts < maxAttempts) {
        final candidate = Offset(
          rand.nextDouble() * (canvasSize.width - 2 * marbleRadius) +
              marbleRadius,
          rand.nextDouble() * (canvasSize.height - 2 * marbleRadius) +
              marbleRadius,
        );

        bool tooCloseToPocket = pockets.any((pocket) {
          final pocketCenter = pocket.center;
          return (candidate - pocketCenter).distance < safeDistanceFromPocket;
        });

        if (tooCloseToPocket) {
          attempts++;
          continue;
        }

        bool tooCloseToMarble = marbles.any((m) {
          return (candidate - m.position).distance < marbleRadius * 2;
        });

        if (tooCloseToMarble) {
          attempts++;
          continue;
        }

        marbles.add(
          Marble(
            position: candidate,
            color: colorPalette[marbles.length % colorPalette.length],
            groupId: nextGroupId++,
          ),
        );
        break;
      }

      if (attempts >= maxAttempts) {
        print(
          'Peringatan: Gagal menempatkan kelereng ke-${i + 1} setelah $maxAttempts percobaan.',
        );
      }
    }
    update();
  }

  /// Mengatur ulang posisi SEMUA kelereng dalam grup ke dalam formasi poligon
  /// di sekitar posisi jari pengguna.
void arrangeMarblesInPattern(Marble draggedMarble, Offset dragPosition) {
    final group = marbles.where((m) => m.groupId == draggedMarble.groupId).toList();
    if (group.isEmpty) return;

    // ==========================================================
    // LOGIKA BARU UNTUK ROTASI PADA PUSAT GRUP
    // ==========================================================

    // 1. Tentukan posisi pusat grup yang baru.
    //    Pusat grup akan mengikuti posisi jari pengguna.
    final newCenter = dragPosition;

    // 2. Tambahkan sedikit rotasi untuk animasi orbit
    _groupAngles.putIfAbsent(draggedMarble.groupId, () => 0.0);
    _groupAngles[draggedMarble.groupId] = (_groupAngles[draggedMarble.groupId]! + 0.015) % (2 * pi); // Sedikit lebih cepat
    final currentAngle = _groupAngles[draggedMarble.groupId]!;
    
    // 3. Atur ulang posisi SEMUA kelereng dalam grup di sekitar pusat baru
    final count = group.length;
    if (count <= 1) {
        draggedMarble.position = dragPosition;
        update();
        return;
    }

    const double distance = 25.0; // Jarak dari pusat ke setiap kelereng
    final double angleIncrement = 2 * pi / count;

    for (int i = 0; i < count; i++) {
      final angle = currentAngle + (angleIncrement * i);
      final offsetX = distance * cos(angle);
      final offsetY = distance * sin(angle);
      // Atur posisi setiap kelereng di grup relatif terhadap pusat baru
      group[i].position = newCenter + Offset(offsetX, offsetY);
    }
    // ==========================================================

    update();
}

  /// Menggabungkan kelereng jika jaraknya berdekatan.
  void groupMarblesIfNearby(Marble selectedMarble) {
    for (var other in marbles) {
      if (other == selectedMarble) continue;

      final double distance =
          (other.position - selectedMarble.position).distance;

      if (distance < 40 && other.groupId != selectedMarble.groupId) { // Jarak grouping sedikit diperbesar
        int oldGroupId = other.groupId;
        int newGroupId = selectedMarble.groupId;

        for (var marble in marbles) {
          if (marble.groupId == oldGroupId) {
            marble.groupId = newGroupId;
          }
        }
        
        // Panggil arrangeMarblesInPattern lagi setelah grouping agar kelereng baru
        // langsung "melompat" ke dalam formasi poligon.
        arrangeMarblesInPattern(selectedMarble, selectedMarble.position);
        return; // Keluar setelah satu grup digabungkan untuk efisiensi
      }
    }
  }

  /// Mengosongkan area permainan.
  void resetPlayArea() {
    marbles.clear();
    nextGroupId = 0;
    update();
  }
}