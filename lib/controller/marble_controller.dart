import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/marble.dart';

class MarbleController extends GetxController {
  var marbles = <Marble>[].obs;
  int nextGroupId = 0;
  late Size canvasSize; // Tambahkan ini

  void generateMarbles(Size size, List<Rect> pockets) {
    canvasSize = size; // Simpan ukuran canvas
    final rand = Random();
    final safeDistanceFromPocket = 85.0;
    final marbleRadius = 30.0;

    while (marbles.length < 24) {
      final candidate = Offset(
        rand.nextDouble() * (canvasSize.width - 2 * marbleRadius) +
            marbleRadius,
        rand.nextDouble() * (canvasSize.height - 2 * marbleRadius) +
            marbleRadius,
      );

      // Pastikan tidak terlalu dekat dengan pocket
      bool tooCloseToPocket = pockets.any((pocket) {
        final pocketCenter = pocket.center;
        return (candidate - pocketCenter).distance < safeDistanceFromPocket;
      });

      if (tooCloseToPocket) continue;

      // (Opsional) Pastikan tidak terlalu dekat dengan marble lain
      bool tooCloseToMarble = marbles.any((m) {
        return (candidate - m.position).distance < 20 * 2;
      });

      if (tooCloseToMarble) continue;

      marbles.add(
        Marble(
          position: candidate,
          color: Colors.primaries[marbles.length % Colors.primaries.length],
          groupId: nextGroupId++,
        ),
      );
    }
     update();
  }

  void moveGroupedMarbles(Marble selected, Offset delta, Offset newPosition) {
    for (var marble in marbles) {
      if (marble.groupId == selected.groupId) {
        // Terapkan batasan pada posisi marble
        final newX = (marble.position.dx + delta.dx).clamp(15.0, canvasSize.width - 15.0);
        final newY = (marble.position.dy + delta.dy).clamp(15.0, canvasSize.height - 15.0);
        marble.position = Offset(newX, newY);
      }
    }
    update(); // agar UI merespon perubahan
  }

  void groupMarblesIfNearby(Marble selectedMarble) {
    for (var other in marbles) {
      if (other == selectedMarble) continue;

      final double distance =
          (other.position - selectedMarble.position).distance;

      if (distance < 30 && other.groupId != selectedMarble.groupId) {
        int oldGroupId = other.groupId;
        int newGroupId = selectedMarble.groupId;

        for (var marble in marbles) {
          if (marble.groupId == oldGroupId) {
            marble.groupId = newGroupId;
          }
        }

        update(); // ini penting
      }
    }
  }

  void resetPlayArea(){
    marbles.clear();
    nextGroupId = 0;
    update(); // agar UI merespon perubahan
  }
}