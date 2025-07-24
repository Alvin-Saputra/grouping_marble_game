import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/model/pocket.dart';

class PocketController extends GetxController {
  var pockets = <Pocket>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi pockets akan dilakukan dari PlayArea setelah ukuran canvas diketahui
  }

  void initializePockets(Size canvasSize) {
    if (pockets.isNotEmpty) return; // Cegah inisialisasi berulang
    
    // Langsung gunakan pocketList yang sudah ada dengan posisi yang sudah didefinisikan
    for (var originalPocket in pocketList) {
      // Copy semua properti dari pocketList tanpa mengubah posisi
      final pocket = Pocket(
        id: originalPocket.id,
        area: originalPocket.area, // Gunakan posisi asli dari pocketList
        fillColor: originalPocket.fillColor,
        shadowColor: originalPocket.shadowColor,
        marbleCount: 0,
      );
      
      pockets.add(pocket);
    }
    update();
  }

  void resetPockets() {
    for (var pocket in pockets) {
      pocket.marbleCount = 0;
      pocket.marbles.clear();
      pocket.isCorrect = false;
      pocket.showResult = false;
    }
    update();
  }

  void showAnswerFeedback(Map<int, bool> feedbackMap) {
    for (var pocket in pockets) {
      pocket.isCorrect = feedbackMap[pocket.id] ?? false;
      pocket.showResult = true;
    }
    update();

    Future.delayed(Duration(seconds: 2), () {
      for (var pocket in pockets) {
        pocket.showResult = false;
      }
      update();
    });
  }
}