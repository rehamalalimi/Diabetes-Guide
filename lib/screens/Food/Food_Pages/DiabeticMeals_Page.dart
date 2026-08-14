import 'package:flutter/material.dart';

import '../../../Conist.dart';
import '../../../Widget/FoodBady/FoodPagesWidget/DiabeticMeals_Widget/DiabeticMeals.dart';

class DiabeticMealsPage extends StatelessWidget {
  const DiabeticMealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text("الوجبات المناسبة لمرضى السكر"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 80.2,
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
      body: MealTableScreen(),
    );
  }
}
