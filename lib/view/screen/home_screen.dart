import 'package:flutter/material.dart';
import 'package:marble_grouping_game/view/components/dialog_box.dart';
import 'package:marble_grouping_game/view/components/card_item.dart';
import 'package:marble_grouping_game/view/components/play_area.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
      // backgroundColor: const Color(0xFFF2B9EC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              CardItem(cardText: "Find the result of this following division",
                cardColor: const Color.fromARGB(255, 183, 58, 177),
                borderColor: const Color.fromARGB(255, 183, 58, 177),
                borderWidth: 0,
                borderRadius: 24,
                textSize: 14,
                textWeight: FontWeight.w500,
                textColor: Colors.white,
                verticalPadding: 8.0,),
                SizedBox(height: 8.0),
              CardItem(
                cardText: "24 ÷ 3 = ",
                cardColor: Colors.deepPurple,
                borderColor: const Color.fromARGB(255, 50, 17, 107),
                borderWidth: 6.0,
                borderRadius: 8,
                textSize: 48,
                textWeight: FontWeight.bold,
                textColor: Colors.white,
                verticalPadding: 35.0,
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: PlayArea(
                  key: playAreaKey,
                  getMarbleCountOnPocket: (Map<int, int> pocketMarbleCount) {
                    eachPocketMarbleCounts = pocketMarbleCount;
                  },
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
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
                      playAreaKey.currentState?.showAnswerFeedback(feedback);
                      playAreaKey.currentState?.resetPlayArea();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 144, 238, 36),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: const Color.fromARGB(
                          255,
                          66,
                          202,
                          12,
                        ),
                        width: 3, 
                      ),
                    ),
                    elevation: 0,
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
            ],
          ),
        ),
      ),
    );
  }
}
