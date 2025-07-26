import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/model/pocket.dart';

class PocketController extends GetxController {
  var pockets = <Pocket>[];
  
  @override
  void onInit() {
    super.onInit();
  }

  void initializePockets(Size canvasSize) {
    if (pockets.isNotEmpty) return; 
    
    for (var originalPocket in pocketList) {

      final pocket = Pocket(
        id: originalPocket.id,
        area: originalPocket.area, 
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
      // pocket.isCorrect = false;
      // pocket.showResult = false;
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

    Map<int, int> getPocketMarbleCounts() {
    return {
      for (var pocket in pockets)
        pocket.id: pocket.marbleCount,
    };
  }
}
