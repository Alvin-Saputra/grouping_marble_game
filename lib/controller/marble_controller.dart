import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/marble.dart';

class MarbleController extends GetxController {
  var marbles = <Marble>[];
  int nextGroupId = 0;
  late Size canvasSize; 

  void generateMarbles(Size size, List<Rect> pockets) {
    if (marbles.isNotEmpty) {
      marbles.clear();
      nextGroupId = 0;
    }

    canvasSize = size;
    if (size.width <= 0 || size.height <= 0) return;
    
    final rand = Random();
    final safeDistanceFromPocket = 75.0;
    final marbleRadius = 20.0;

    int totalMarblesToGenerate = 24;
    for (int i = 0; i < totalMarblesToGenerate; i++) {
      int attempts = 0;
      int maxAttempts = 1000; // Batas percobaan untuk mencegah freeze

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
            color: Colors.primaries[marbles.length % Colors.primaries.length],
            groupId: nextGroupId++,
          ),
        );
        break; 
      }
      
      if (attempts >= maxAttempts) {
        print('Peringatan: Gagal menempatkan kelereng ke-${i + 1} setelah $maxAttempts percobaan.');
      }
    }
    update();
  }

  void moveGroupedMarbles(Marble selected, Offset delta, Offset newPosition) {
    for (var marble in marbles) {
      if (marble.groupId == selected.groupId) {
        final newX = (marble.position.dx + delta.dx).clamp(15.0, canvasSize.width - 15.0);
        final newY = (marble.position.dy + delta.dy).clamp(15.0, canvasSize.height - 15.0);
        marble.position = Offset(newX, newY);
      }
    }
    update(); 
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

        update();
      }
    }
  }

  void resetPlayArea(){
    marbles.clear();
    nextGroupId = 0;
    update();
  }
}