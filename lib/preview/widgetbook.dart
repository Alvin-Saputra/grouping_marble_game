// Widgetbook file: widgetbook.dart
import 'package:flutter/material.dart';
import 'package:marble_grouping_game/view/components/card.dart';
import 'package:marble_grouping_game/view/components/problem_card.dart';
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
          name: 'Marble Component',
          useCases: [
            WidgetbookUseCase(
              name: 'Marble Component 1',
              builder: (context) => Center(child:ProblemCard()),
            ),
          ],
        ),
      ],
    );
  }
}
