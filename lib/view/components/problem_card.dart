import 'package:flutter/material.dart';
import 'package:marble_grouping_game/view/components/card.dart';

class ProblemCard extends StatelessWidget {


  const ProblemCard({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(150, 100),
          painter: CardPainter(),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "test",
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: (){},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[800],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '=',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
