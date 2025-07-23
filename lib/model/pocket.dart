import 'dart:ui';
import 'package:marble_grouping_game/model/marble.dart';

class Pocket {
  int id;
  final Rect area;
  int marbleCount;
  List <Marble> marbles = [];

  Pocket({required this.id, required this.area, this.marbleCount = 0});
}

List<Pocket> pocketList = [
  Pocket(id: 1, area: Rect.fromLTWH(10, 50, 100, 100)),
  Pocket(id: 2, area: Rect.fromLTWH(10, 200, 100, 100)),
  Pocket(id: 3, area: Rect.fromLTWH(10, 350, 100, 100)),
];
