import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marble_grouping_game/controller/marble_controller.dart';
import 'package:marble_grouping_game/controller/pocket_controller.dart';
import 'package:marble_grouping_game/view/screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MarbleController());
  Get.put(PocketController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( 
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
