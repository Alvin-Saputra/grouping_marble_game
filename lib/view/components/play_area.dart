import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/controller/marble_controller.dart';
import 'package:marble_grouping_game/controller/pocket_controller.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/view/components/play_area_painter.dart';

class PlayArea extends StatefulWidget {
  PlayArea({super.key, required this.getMarbleCountOnPocket});
  Function(Map<int, int>) getMarbleCountOnPocket;

  @override
  State<PlayArea> createState() => PlayAreaState();
}

class PlayAreaState extends State<PlayArea> {
  final MarbleController marbleController = Get.find<MarbleController>();
  final PocketController pocketController = Get.find<PocketController>();

  Marble? selectedMarble;
  late Size canvasSize;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _initializeGameComponents() {
    if (_initialized) return;
    
    // Inisialisasi pockets terlebih dahulu
    pocketController.initializePockets(canvasSize);
    
    // Kemudian generate marbles
    generateMarbles();
    
    // Update marble count
    widget.getMarbleCountOnPocket(getPocketMarbleCounts());
    
    _initialized = true;
  }

  void generateMarbles() {
    marbleController.generateMarbles(
      canvasSize,
      pocketController.pockets.map((p) => p.area).toList(),
    );
  }

  void onDrag(Offset localPosition) {
    if (selectedMarble == null) return;

    Offset delta = localPosition - selectedMarble!.position;

    // Gerakkan semua kelereng dalam grup yang sama
    marbleController.moveGroupedMarbles(selectedMarble!, delta, localPosition);

    // Cek penempelan dan gabung grup
    marbleController.groupMarblesIfNearby(selectedMarble!);
  }

  void showAnswerFeedback(Map<int, bool> feedbackMap) {
    pocketController.showAnswerFeedback(feedbackMap);
  }

  void resetPlayArea() {
    marbleController.resetPlayArea();
    pocketController.resetPockets();
    _initialized = false; // Reset flag
    
    // Re-initialize setelah reset
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGameComponents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final localPos = details.localPosition;
        for (var marble in marbleController.marbles) {
          if ((marble.position - localPos).distance < 30) {
            selectedMarble = marble;
            break;
          }
        }
      },
      onPanUpdate: (details) {
        if (selectedMarble != null) {
          onDrag(details.localPosition);
        }
      },
      onPanEnd: (_) {
        if (selectedMarble != null) {
          int groupId = selectedMarble!.groupId;

          for (var pocket in pocketController.pockets) {
            bool allInPocket = marbleController.marbles
                .where((m) => m.groupId == groupId)
                .every((m) => pocket.area.inflate(30).contains(m.position));

            if (allInPocket) {
              final groupMarbles = marbleController.marbles
                  .where((m) => m.groupId == groupId)
                  .toList();
              pocket.marbleCount += groupMarbles.length;
              pocket.marbles.addAll(groupMarbles);
              marbleController.marbles.removeWhere((m) => m.groupId == groupId);
              widget.getMarbleCountOnPocket(getPocketMarbleCounts());
            }
          }
        }

        selectedMarble = null;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
          
          // Inisialisasi komponen game setelah ukuran canvas diketahui
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeGameComponents();
          });
          
          return GetBuilder<MarbleController>(
            builder: (_) => GetBuilder<PocketController>(
              builder: (_) => CustomPaint(
                size: canvasSize,
                painter: PlayAreaPainter(
                  marbleController.marbles,
                  pocketController.pockets,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Map<int, int> getPocketMarbleCounts() {
    return {
      for (var pocket in pocketController.pockets)
        pocket.id: pocket.marbleCount,
    };
  }
}