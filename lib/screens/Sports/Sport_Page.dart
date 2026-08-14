import 'package:flutter/material.dart';
import '../../Conist.dart';
import '../../Widget/FoodBady/FoodBody.dart';
import '../../Widget/Sport/DiabetesFitnessBady.dart';

class DiabetesFitnessScreen extends StatelessWidget {
  const DiabetesFitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      appBar: AppBar(
        title: Text('الرياضة',  style: TextStyle(fontFamily: 'Cairo', fontSize: 20,color: Colors.white),),
        backgroundColor: PrimaryColor,
      ),

    body: DiabetesFitness(),
    );
  }
}
