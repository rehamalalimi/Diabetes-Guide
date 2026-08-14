import 'package:flutter/material.dart';

import '../../Conist.dart';
import 'DiabetesFitnessContent.dart';

class DiabetesFitness extends StatelessWidget {
  DiabetesFitness({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background container
          Column(
            children: [
              SizedBox(height: def_Padding / 2),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(
                    color: BackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            height:  150,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ابقَ نشيطًا، ابقَ بصحة جيدة!',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColor)),
                  SizedBox(height: 5),
                  Text('التمارين الموصى بها لمرضى السكري.',
                      style: TextStyle(fontSize: 18, color: PrimaryColor)),
                ],
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: DiabetesFitnessContent(),
          ),
        ],
      ),
    );
  }
}
