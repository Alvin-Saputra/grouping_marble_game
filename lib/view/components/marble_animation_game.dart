import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:marble_grouping_game/controller/marble_controller.dart';
import 'package:marble_grouping_game/controller/pocket_controller.dart';
import 'package:marble_grouping_game/model/marble.dart' as model;
import 'dart:ui';

/// Kelas Game Utama yang bertanggung jawab untuk visualisasi.
class MarbleAnimationGame extends FlameGame {
  final MarbleController marbleController;
  final PocketController pocketController;

  MarbleAnimationGame({
    required this.marbleController,
    required this.pocketController,
  });

  @override
  Future<void> onLoad() async {
    marbleController.addListener(_syncMarbles);
    pocketController.addListener(() {});
    _syncMarbles();
  }

  void _syncMarbles() {
    // ==========================================================
    // PERBAIKAN UTAMA: Logika sinkronisasi yang lebih kuat
    // ==========================================================

    // 1. Dapatkan daftar ID dari data kelereng yang seharusnya ada di layar.
    final modelIds = marbleController.marbles.map((m) => m.hashCode).toSet();

    // 2. Cari komponen visual yang datanya sudah tidak ada lagi di controller.
    final componentsToRemove = children
        .whereType<MarbleComponent>()
        .where((component) => !modelIds.contains(component.marbleId))
        .toList();

    for (final component in componentsToRemove) {
  // Cari di pocket mana marble ini berada
  final pocket = pocketController.pockets.firstWhereOrNull(
    (p) => p.marbles.any((m) => m.hashCode == component.marbleId),
  );

  if (pocket != null) {
    // Hitung posisi tengah pocket untuk animasi
    final pocketCenter = pocket.area.center;
    component.animateToPocket(pocketCenter);
  }

  // Setelah animasi selesai, baru hapus
  Future.delayed(Duration(milliseconds: 400), () {
    remove(component);
  });
}
    // 3. Hapus semua komponen yang sudah tidak valid tersebut dari game.
    removeAll(componentsToRemove);

    // 4. Tambah atau perbarui komponen visual berdasarkan data dari controller.
    for (final modelMarble in marbleController.marbles) {
      final existingComponent = children
          .whereType<MarbleComponent>()
          .firstWhereOrNull((c) => c.marbleId == modelMarble.hashCode);

      if (existingComponent == null) {
        add(MarbleComponent(modelMarble));
      } else {
        existingComponent.updateData(modelMarble);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // 1. Gambar semua kelereng yang bergerak bebas.
    super.render(canvas);
    // 2. Gambar kelereng yang sudah ada di dalam kantong.
    _drawMarblesInPockets(canvas);
    // 3. TERAKHIR, gambar garis di lapisan paling atas.
    _drawGroupLines(canvas);
  }

  /// Method helper untuk menentukan warna berdasarkan ukuran grup
  Color _getGroupColor(int groupSize, Color originalColor) {
    switch (groupSize) {
      case 1:
        return originalColor; // Kembali ke warna asli jika sendirian
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.red;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.yellow;
      case 7:
        return Colors.pink;
      case 8:
        return Colors.cyan;
      case 9:
        return Colors.brown;
      case 10:
        return Colors.teal;
      case 11:
        return Colors.lime;
      case 12:
        return Colors.indigo;
      case 13:
        return Colors.amber;
      case 14:
        return Colors.deepOrange;
      case 15:
        return Colors.lightBlue;
      case 16:
        return Colors.lightGreen;
      case 17:
        return Colors.purpleAccent;
      case 18:
        return Colors.blueGrey;
      case 19:
        return Colors.deepPurple;
      case 20:
        return Colors.grey;
      case 21:
        return Colors.cyanAccent;
      case 22:
        return Colors.tealAccent;
      case 23:
        return Colors.orangeAccent;
      case 24:
        return Colors.redAccent;
      default:
        return Colors.green; // Warna default untuk grup > 24
    }
  }

  /// Menggambar garis dari pusat setiap kelereng hingga radiusnya sendiri, mengarah ke kelereng lain dalam grup.
  void _drawGroupLines(Canvas canvas) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final groupIds = marbleController.marbles.map((m) => m.groupId).toSet();

    for (final id in groupIds) {
      final group = marbleController.marbles
          .where((m) => m.groupId == id)
          .toList();

      if (group.length > 1) {
        for (int i = 0; i < group.length; i++) {
          for (int j = i + 1; j < group.length; j++) {
            final marbleA = group[i];
            final marbleB = group[j];
            const double marbleRadius = 15.0;

            // Vektor dari A ke B
            final directionAtoB = marbleB.position - marbleA.position;
            final normalizedAtoB = directionAtoB / directionAtoB.distance;

            // Vektor dari B ke A
            final directionBtoA = marbleA.position - marbleB.position;
            final normalizedBtoA = directionBtoA / directionBtoA.distance;

            // Titik akhir garis dari pusat A mengarah ke B (hanya sampai radius A)
            final endPointA =
                marbleA.position + (normalizedAtoB * marbleRadius);

            // Titik akhir garis dari pusat B mengarah ke A (hanya sampai radius B)
            final endPointB =
                marbleB.position + (normalizedBtoA * marbleRadius);

            // Gambar garis dari pusat marble A ke tepi marble A (mengarah ke B)
            canvas.drawLine(marbleA.position, endPointA, linePaint);

            // Gambar garis dari pusat marble B ke tepi marble B (mengarah ke A)
            canvas.drawLine(marbleB.position, endPointB, linePaint);
          }
        }
      }
    }
  }

  /// Menggambar kelereng yang sudah terkumpul di dalam setiap kantong.
  void _drawMarblesInPockets(Canvas canvas) {
    final paint = Paint();
    const int marblePerRow = 4;
    const double spacing = 22.0;

    for (var pocket in pocketController.pockets) {
      final topLeft = pocket.area.topLeft;
      for (int i = 0; i < pocket.marbles.length; i++) {
        final marbleData = pocket.marbles[i];
        int row = i ~/ marblePerRow;
        int col = i % marblePerRow;
        Offset position =
            topLeft + Offset(50 + (col * spacing), 18 + (row * spacing));

        // Hitung ukuran grup untuk marble di dalam pocket
        final groupSize = marbleController.marbles
            .where((m) => m.groupId == marbleData.groupId)
            .length;
        final displayColor = _getGroupColor(groupSize, marbleData.color);

        paint
          ..style = PaintingStyle.fill
          ..color = pocket.fillColor;
        canvas.drawCircle(position, 15, paint);

        paint
          ..style = PaintingStyle.stroke
          ..color = pocket.shadowColor
          ..strokeWidth = 2;
        canvas.drawCircle(position, 15, paint);
      }
    }
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

/// Komponen visual untuk satu kelereng yang bergerak bebas.
class MarbleComponent extends PositionComponent {
  late model.Marble _marble;
  final int marbleId;
  final double speed = 500.0;
   bool isPocketed = false; 

  MarbleComponent(model.Marble initialMarble)
    : _marble = initialMarble,
      marbleId = initialMarble.hashCode,
      super(position: initialMarble.position.toVector2());

  void updateData(model.Marble newMarbleData) {
    _marble = newMarbleData;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // HANYA LAKUKAN ANIMASI JIKA KELERENG TIDAK SEDANG DI-DRAG
    if (!_marble.isDragging) {
      final targetPosition = _marble.position.toVector2();
      final distance = position.distanceTo(targetPosition);

      if (distance > 0.1) {
        final direction = (targetPosition - position)..normalize();
        final movement = direction * (speed * dt);
        if (movement.length < distance) {
          position.add(movement);
        } else {
          position.setFrom(targetPosition);
        }
      }
    } else {
      // Jika sedang di-drag, langsung teleport ke posisinya
      position.setFrom(_marble.position.toVector2());
    }
  }

     void animateToPocket(Offset pocketCenter) {
    if (isPocketed) return;
    isPocketed = true;

    // Hentikan pembaruan posisi dari controller
    _marble.isDragging = true; 

    // Tambahkan dua efek yang berjalan bersamaan
    addAll([
      // 1. Efek mengecil hingga hilang (menjadi 0)
      ScaleEffect.to(
        Vector2.all(0),
        EffectController(
          duration: 0.4,
          curve: Curves.easeIn,
        ),
      ),
      // 2. Efek bergerak ke tengah kantong dengan sedikit efek "memantul"
      MoveEffect.to(
        pocketCenter.toVector2(),
        EffectController(
          duration: 0.5, // Sedikit lebih lama dari scale agar terlihat
          curve: Curves.elasticOut, 
        ),
      )
    ]);
  }

  

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Akses marbleController dari parent game untuk menghitung ukuran grup
    final game = findGame() as MarbleAnimationGame;
    final allMarbles = game.marbleController.marbles;
    final groupSize = allMarbles
        .where((m) => m.groupId == _marble.groupId)
        .length;

    // Tentukan warna berdasarkan ukuran grup
    final displayColor = game._getGroupColor(groupSize, _marble.color);

    final paint = Paint()..color = displayColor;
    canvas.drawCircle(Offset.zero, 15, paint);
  }
}



/// Extension helper untuk mengubah Offset menjadi Vector2.
extension on Offset {
  Vector2 toVector2() => Vector2(dx, dy);
}
