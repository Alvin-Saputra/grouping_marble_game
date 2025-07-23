import 'dart:ui';

class Pocket {
  int id;
  final Rect area;
  int marbleCount;

  Pocket({required this.id, required this.area, this.marbleCount = 0});
}

List<Pocket> pocketList = [
  Pocket(id: 1, area: Rect.fromLTWH(10, 30, 100, 100)),
  Pocket(id: 2, area: Rect.fromLTWH(10, 300, 100, 100)),
  Pocket(id: 3, area: Rect.fromLTWH(10, 500, 100, 100)),
];
