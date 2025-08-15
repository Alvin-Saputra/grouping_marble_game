import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/controller/marble_controller.dart';
import 'package:marble_grouping_game/controller/pocket_controller.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/view/components/marble_animation_game.dart';

class PlayArea extends StatefulWidget {
  final Function(Map<int, int>) getMarbleCountOnPocket;

  const PlayArea({super.key, required this.getMarbleCountOnPocket});

  @override
  State<PlayArea> createState() => PlayAreaState();
}

class PlayAreaState extends State<PlayArea> {
  late final MarbleAnimationGame _game;
  final MarbleController marbleController = Get.find<MarbleController>();
  final PocketController pocketController = Get.find<PocketController>();

  // =================================================================
  // PERBAIKAN UTAMA ADA DI SINI
  // Variabel untuk menyimpan kelereng yang sedang disentuh
  Marble? _draggedMarble;
  // =================================================================

  @override
  void initState() {
    super.initState();
    _game = MarbleAnimationGame(
      marbleController: marbleController,
      pocketController: pocketController,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final canvasSize = (context.findRenderObject() as RenderBox).size;
        pocketController.initializePockets(canvasSize); // Inisialisasi kantong
        marbleController.generateMarbles(
          canvasSize,
          pocketController.pockets.map((p) => p.area).toList(),
        );
        widget.getMarbleCountOnPocket(pocketController.getPocketMarbleCounts());
      }
    });
  }

  void resetPlayArea() {
    final canvasSize = (context.findRenderObject() as RenderBox).size;
    pocketController.resetPockets();
    marbleController.generateMarbles(
      canvasSize,
      pocketController.pockets.map((p) => p.area).toList(),
    );
  }

  void showAnswerFeedback(Map<int, bool> feedbackMap) {
    pocketController.showAnswerFeedback(feedbackMap);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // Cari kelereng terdekat dengan titik sentuh
        _draggedMarble = marbleController.marbles.firstWhereOrNull((marble) {
          final distance = (marble.position - details.localPosition).distance;
          return distance < 30; // Radius sentuh 30px
        });
      },
      onPanUpdate: (details) {
        // HANYA jika ada kelereng yang sedang di-drag
        if (_draggedMarble != null) {
          // Gunakan _draggedMarble, bukan marbles.first
          marbleController.arrangeMarblesInPattern(
            _draggedMarble!,
            details.localPosition,
          );
          marbleController.groupMarblesIfNearby(_draggedMarble!);
        }
      },
      onPanEnd: (_) {
        if (_draggedMarble != null) {
          _draggedMarble!.isDragging = false;
          // Panggil update terakhir untuk memastikan posisi final sebelum animasi
          marbleController.arrangeMarblesInPattern(
            _draggedMarble!,
            _draggedMarble!.position,
          );

          final groupId = _draggedMarble!.groupId;
          final groupMarbles = marbleController.marbles
              .where((m) => m.groupId == groupId)
              .toList();

          for (var pocket in pocketController.pockets) {
            bool allInPocket = groupMarbles.every(
              (m) => pocket.area.inflate(30).contains(m.position),
            );

            if (allInPocket) {
              // ==========================================================
              // PERUBAHAN UTAMA: Panggil animasi sebelum menghapus data
              // ==========================================================

              // 1. Dapatkan semua komponen visual yang perlu dianimasikan.
              final componentsToAnimate = _game.children
                  .whereType<MarbleComponent>()
                  .where(
                    (c) => groupMarbles.any((m) => m.hashCode == c.marbleId),
                  )
                  .toList();

              // 2. Minta setiap komponen untuk menjalankan animasi "terserap".
              for (var component in componentsToAnimate) {
                component.animateToPocket(pocket.area.center);
              }

              // 3. Hapus data dari controller SETELAH jeda singkat agar animasi terlihat.
              Future.delayed(const Duration(milliseconds: 400), () {
                if (!mounted) return;
                pocket.marbles.addAll(groupMarbles);
                pocket.marbleCount += groupMarbles.length;
                marbleController.marbles.removeWhere(
                  (m) => m.groupId == groupId,
                );

                // Beri tahu UI dan game untuk update
                pocketController.update();
                marbleController.update();

                widget.getMarbleCountOnPocket(
                  pocketController.getPocketMarbleCounts(),
                );
              });

              break; // Keluar dari loop setelah menemukan kantong
            }
          }
        }
        _draggedMarble = null;
      },
      child: GameWidget(game: _game),
    );
  }
}
