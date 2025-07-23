import 'package:flutter/material.dart';
import 'package:marble_grouping_game/model/marble.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/view/components/marble_pocket.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Pocket> listPocketRect = pocketList;
  List<Marble> marbles = [];
  int nextGroupId = 0;
  Marble? selectedMarble;

  @override
  void initState() {
    super.initState();
    marbles = List.generate(5, (index) {
      return Marble(
        position: Offset(100.0 + index * 80, 200.0),
        color: Colors.primaries[index],
        groupId: nextGroupId++,
      );
    });
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
        if (distance < 60 && other.groupId != selectedMarble!.groupId) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
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

            // Cek apakah semua kelereng dalam grup ini masuk ke dalam pocketRect
            for (var pocket in listPocketRect) {
              bool allInPocket = marbles
                  .where((m) => m.groupId == groupId)
                  .every((m) => pocket.area.contains(m.position));

              if (allInPocket) {
                int marbleCount = marbles
                    .where((m) => m.groupId == groupId)
                    .length;
                setState(() {
                  pocket.marbleCount += marbleCount;
                  print(marbleCount);
                  marbles.removeWhere((m) => m.groupId == groupId);
                });
              }
            }
          }

          selectedMarble = null;
        },
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: MarblePocket(marbles: marbles, pockets: listPocketRect),
        ),
      ),
    );
  }
}
