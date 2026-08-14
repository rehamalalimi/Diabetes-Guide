import 'package:flutter/material.dart';
import '../../../Conist.dart';
import '../../../Widget/FoodBady/FoodPagesWidget/FoodsToAvoid_Widget/FoodsToAvoidBady.dart';
class FoodsToAvoidPage extends StatelessWidget {
  const FoodsToAvoidPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text("المأكولات التي يجب تجنبها"),
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
      body: Column(
        children: [
          const Text(
            "الأطعمة الصحية والبدائل",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: HealthyFoodScreen(),
          ),
        ],
      ),
    );
  }
}
