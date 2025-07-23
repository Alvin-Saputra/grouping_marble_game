import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/view/components/play_area_painter.dart';

class PlayArea extends StatefulWidget {
  PlayArea({super.key, required this.getMarbleCountOnPocket});
  Function(Map<int, int>) getMarbleCountOnPocket;

  @override
  State<PlayArea> createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> {
  final List<Pocket> listPocket = pocketList;
  List<Marble> marbles = [];
  int nextGroupId = 0;
  Marble? selectedMarble;
  late var canvaSize;
  bool _marblesInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  void generateMarbles() {
    final rand = Random();
    final safeDistanceFromPocket = 85.0;
    final canvasSize = canvaSize; // Ganti sesuai ukuran sebenarnya
    final marbleRadius = 30.0;

    while (marbles.length < 24) {
      final candidate = Offset(
        rand.nextDouble() * (canvasSize.width - 2 * marbleRadius) +
            marbleRadius,
        rand.nextDouble() * (canvasSize.height - 2 * marbleRadius) +
            marbleRadius,
      );

      // Pastikan tidak terlalu dekat dengan pocket
      bool tooCloseToPocket = pocketList.any((pocket) {
        final pocketCenter = pocket.area.center;
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
  }

  void onDrag(Offset localPosition) {
    if (selectedMarble == null) return;

    Offset delta = localPosition - selectedMarble!.position;

    // Gerakkan semua kelereng dalam grup yang sama
    setState(() {
      for (var marble in marbles) {
        if (marble.groupId == selectedMarble!.groupId) {
          marble.position += delta;
        }
      }

      selectedMarble!.position = localPosition;

      // Cek penempelan dan gabung grup
      for (var other in marbles) {
        if (other == selectedMarble) continue;
        double distance = (other.position - selectedMarble!.position).distance;
        if (distance < 30 && other.groupId != selectedMarble!.groupId) {
          int oldGroup = other.groupId;
          for (var marble in marbles) {
            if (marble.groupId == oldGroup) {
              marble.groupId = selectedMarble!.groupId;
            }
          }
        }
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final localPos = details.localPosition;
        for (var marble in marbles) {
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

          for (var pocket in listPocket) {
            bool allInPocket = marbles
                .where((m) => m.groupId == groupId)
                .every((m) => pocket.area.contains(m.position));

            if (allInPocket) {
              int marbleCount = marbles
                  .where((m) => m.groupId == groupId)
                  .length;
              setState(() {
                final groupMarbles = marbles
                    .where((m) => m.groupId == groupId)
                    .toList();
                pocket.marbleCount += groupMarbles.length;
                pocket.marbles.addAll(groupMarbles);
                marbles.removeWhere((m) => m.groupId == groupId);
                widget.getMarbleCountOnPocket(getPocketMarbleCounts());
              });
            }
          }
        }

        selectedMarble = null;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          canvaSize = Size(constraints.maxWidth, constraints.maxHeight);
          if (!_marblesInitialized) {
            generateMarbles();
            _marblesInitialized = true;
          }
          return CustomPaint(
            size: canvaSize,
            painter: PlayAreaPainter(marbles, listPocket),
          );
        },
      ),
    );
  }

  Map<int, int> getPocketMarbleCounts() {
    return {for (var pocket in listPocket) pocket.id: pocket.marbleCount};
  }
}
