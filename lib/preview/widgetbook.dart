// Widgetbook file: widgetbook.dart
import 'package:flutter/material.dart';

import 'package:marble_grouping_game/view/components/question_card.dart';
import 'package:marble_grouping_game/view/screen/home_screen.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const HotReload());
}

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
  ),
);

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light Theme', // Nama yang akan muncul di UI Widgetbook
              data: lightTheme,
            ),
          ],
        ),
      ],
      directories: [
        WidgetbookComponent(
          name: 'Marble Component',
          useCases: [
            WidgetbookUseCase(
              name: 'Marble Component 1',
              builder: (context) => Center(child: HomeScreen()),
            ),
          ],
        ),

        WidgetbookComponent(
          name: 'Question Card',
          useCases: [
            WidgetbookUseCase(
              name: 'Question Card',
              builder: (context) => Center(child: QuestionCard(questionText: "24 ÷ 3 = ?",)),
            ),
          ],
        ),
        WidgetbookComponent(
          name: 'Home Screen',
          useCases: [
            WidgetbookUseCase(
              name: 'hOME Screen',
              builder: (context) => Center(child: HomeScreen()),
            ),
          ],
        ),
      ],
    );
  }
}
