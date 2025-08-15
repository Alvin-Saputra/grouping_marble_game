import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:marble_grouping_game/controller/marble_controller.dart';
import 'package:marble_grouping_game/controller/pocket_controller.dart';
import 'package:marble_grouping_game/model/pocket.dart';
import 'package:marble_grouping_game/view/components/dialog_box.dart';
import 'package:marble_grouping_game/view/components/card_item.dart';
import 'package:marble_grouping_game/view/components/play_area.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final MarbleController marbleController = Get.find<MarbleController>();
  final PocketController pocketController = Get.find<PocketController>();

  late Map<int, int> eachPocketMarbleCounts = {};
  final GlobalKey<PlayAreaState> playAreaKey = GlobalKey<PlayAreaState>();

  bool checkAnswer(Map<int, int> pocketMarbleCounts) {
    if (pocketMarbleCounts[1] == 8 &&
        pocketMarbleCounts[2] == 8 &&
        pocketMarbleCounts[3] == 8) {
      return true; // Correct answer
    } else {
      return false;
    }
  }

  Map<int, bool> answerFeedback(Map<int, int> pocketMarbleCounts) {
    return {
      1: pocketMarbleCounts[1] == 8,
      2: pocketMarbleCounts[2] == 8,
      3: pocketMarbleCounts[3] == 8,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 197, 248),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              CardItem(
                cardText: "Find the result of this following division",
                cardColor: const Color.fromARGB(255, 183, 58, 177),
                // shadowColor: const Color.fromARGB(255, 183, 58, 177),
                borderWidth: 0,
                borderRadius: 24,
                textSize: 14,
                textWeight: FontWeight.w500,
                textColor: Colors.white,
                verticalPadding: 8.0,
              ),
              SizedBox(height: 8.0),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CardItem(
                    cardText: "24 ÷ 3",
                    cardColor: Colors.deepPurple,
                    shadowColor: const Color.fromARGB(255, 50, 17, 107),
                    borderWidth: 6.0,
                    borderRadius: 8,
                    textSize: 48,
                    textWeight: FontWeight.bold,
                    textColor: Colors.white,
                    verticalPadding: 35.0,
                  ),
                  Positioned(
                    bottom: -10, // Sedikit naikkan agar tidak terlalu jauh
                    left: 0,
                    right: 0,
                    child: Center(
                      // Gunakan Center untuk menengahkan
                      child: Container(
                        // Bungkus dengan Container untuk memberi ukuran
                        width: 60, // Atur lebar di sini
                        height: 40, // Atur tinggi di sini
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 87, 34, 168),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 50, 17, 107),
                            width: 4.0,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.drag_handle, // Gunakan ikon yang mirip
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Stack(
                  children: [
                    Obx(
                      () => Stack(
                        children: pocketController.pockets.map((pocket) {
                          return _buildPocketWidget(pocket);
                        }).toList(),
                      ),
                    ),
                    PlayArea(
                      key: playAreaKey,
                      getMarbleCountOnPocket:
                          (Map<int, int> pocketMarbleCount) {
                            eachPocketMarbleCounts = pocketMarbleCount;
                          },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      24,
                    ), // Samakan dengan bentuk tombol
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          37,
                          134,
                          4,
                        ), // Warna shadow
                        spreadRadius: 1,
                        blurRadius:
                            0, // blurRadius: 0 akan membuat shadow menjadi solid
                        offset: Offset(
                          4,
                          4,
                        ), // Posisi shadow (4px ke kanan, 4px ke bawah)
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      bool isCorrect = checkAnswer(eachPocketMarbleCounts);
                      Map<int, bool> feedback = answerFeedback(
                        eachPocketMarbleCounts,
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          if (isCorrect) {
                            return DialogCard(
                              "Correct",
                              "Your Answer is Correct",
                              Icons.check,
                              true,
                            );
                          } else {
                            return DialogCard(
                              "Incorrect",
                              "Your Answer is Incorrect",
                              Icons.close,
                              false,
                            );
                          }
                        },
                      ).then((_) {
                         pocketController.showAnswerFeedback(feedback);
                        playAreaKey.currentState?.resetPlayArea();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 238, 103),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 36, 238, 103),
                          width: 3,
                        ),
                      ),
                      elevation: 8, // Atur ketinggian shadow
                      shadowColor: const Color.fromARGB(255, 15, 153, 61).withOpacity(0.5),
                    ),
                    child: Text(
                      "Check Answer",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 2, 116, 12),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPocketWidget(Pocket pocket) {
  return Positioned(
    top: pocket.area.top,
    left: pocket.area.left,
    width: pocket.area.width,
    height: pocket.area.height,
    child: Container(
      decoration: BoxDecoration(
        color: pocket.fillColor,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: pocket.shadowColor, width: 4),
        boxShadow: [
          BoxShadow(
            color: pocket.shadowColor,
            offset: const Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 2,
          ),
        ],
      ),
      // Child di sini bisa untuk menampilkan jumlah kelereng jika mau
      child: Center(
        child: (pocket.showResult && pocket.isCorrect != null)
            ? Icon(
                pocket.isCorrect! ? Icons.check_circle : Icons.cancel,
                color: pocket.isCorrect! ? Colors.green.shade700 : Colors.red.shade700,
                size: 50.0, // Sesuaikan ukuran ikon
                shadows: [ // Tambahkan sedikit shadow agar ikon lebih menonjol
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  )
                ],
              )
            : SizedBox.shrink(),
        // child: Text(pocket.marbleCount.toString()),
      ),
    ),
  );
}
