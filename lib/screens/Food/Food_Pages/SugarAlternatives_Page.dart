import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';

import '../../../Widget/FoodBady/FoodPagesWidget/SugarAlternativesPage/SugarAlternativesBady.dart';
class SugarAlternativesPage extends StatelessWidget {
  const SugarAlternativesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text("بدائل السكر"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        backgroundColor: PrimaryColor,
        foregroundColor: Colors.white,
      ),
       body: HealthySugarAlternativesScreen(),
    );
  }
}
