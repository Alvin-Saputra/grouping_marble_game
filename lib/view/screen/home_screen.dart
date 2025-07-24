import 'package:flutter/material.dart';
import 'package:marble_grouping_game/view/components/dialog_card.dart';
import 'package:marble_grouping_game/view/components/question_card.dart';
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
              QuestionCard(questionText: "24 ÷ 3 = "),
              const SizedBox(height: 20),
              Expanded(
                child: PlayArea(
                  key: playAreaKey,
                  getMarbleCountOnPocket: (Map<int, int> pocketMarbleCount) {
                    eachPocketMarbleCounts = pocketMarbleCount;
                  },
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: () {
                    bool isCorrect = checkAnswer(eachPocketMarbleCounts);
                    Map<int, bool> feedback = answerFeedback(eachPocketMarbleCounts);
                     playAreaKey.currentState?.showAnswerFeedback(feedback);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        if (isCorrect) {
                          return DialogCard(
                            "Benar",
                            "Your Answer is Correct",
                            Icons.check,
                            true,
                          );
                        } else {
                          return DialogCard(
                            "Salah",
                            "Your Answer is Incorrect",
                            Icons.close,
                            false,
                          );
                        }
                      },
                    ).then((_) {
                      if (!isCorrect) {
                        // Reset play area jika jawaban salah
                        playAreaKey.currentState?.resetPlayArea();
                      }
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
                        ), // Warna border
                        width: 3, // Ketebalan border
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
