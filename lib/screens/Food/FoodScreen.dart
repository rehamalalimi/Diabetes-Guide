import 'package:flutter/material.dart';
import '../../Conist.dart';
import '../../Widget/FoodBady/FoodBody.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      appBar: AppBar(
        title: Text('التغذية',  style: TextStyle(fontFamily: 'Cairo', fontSize: 20,color: Colors.white),),
        backgroundColor: PrimaryColor,
      ),

      body: FoodScreenBody(),
    );
  }
}
