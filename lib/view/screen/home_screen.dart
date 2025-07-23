import 'package:flutter/material.dart';
import 'package:marble_grouping_game/view/components/dialog_card.dart';
import 'package:marble_grouping_game/view/components/question_card.dart';
import 'package:marble_grouping_game/view/components/play_area.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  late Map<int, int> eachPocketMarbleCounts = {};
  bool checkAnswer(Map<int, int> pocketMarbleCounts) {
    if (pocketMarbleCounts[1] == 8 &&
        pocketMarbleCounts[2] == 8 &&
        pocketMarbleCounts[3] == 8) {
      return true; // Correct answer
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2B9EC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              QuestionCard(questionText: "24 ÷ 3 = "),
              const SizedBox(height: 20),
              Expanded(
                child: PlayArea(
                  getMarbleCountOnPocket: (Map<int, int> pocketMarbleCount) {
                    eachPocketMarbleCounts = pocketMarbleCount;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                      bool isCorrect = checkAnswer(eachPocketMarbleCounts);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        if (isCorrect) {
                          return DialogCard("Benar", "Your Answer is Correct", Icons.check, true);
                        }
                        else{
                        return DialogCard("Salah", "Your Answer is Incorrect", Icons.close, false);
                        }
                      },
                    );
                  },
                  child: Text("Check Answer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
