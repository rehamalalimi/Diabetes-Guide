import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';
import 'Sport_Pages/ActivityTracking_Page.dart';
import 'Sport_Pages/DiabetesExercise_Page.dart';
import 'Sport_Pages/EductionalVidoes_Page.dart';
import 'Sport_Pages/FitnessTips_Page.dart';


class DiabetesFitnessContent extends StatelessWidget {
  DiabetesFitnessContent({super.key});

  final List<Map<String, dynamic>> options = [
    {'label': 'تمارين مناسبة', 'image': 'assets/images/s2.png', 'page': DiabetesExerciseScreen()},
    {'label': 'تتبع النشاط', 'image': 'assets/images/s4.png', 'page': ActivityTrackerScreen()},
    {'label': 'مقاطع فيديو تعليمية', 'image': 'assets/images/s3.png', 'page': ExerciseTutorialScreen(
    exerciseName: 'تمارين السكري', // Provide appropriate value
    difficulty: 'متوسط',          // Provide appropriate value
    duration: '15 دقيقة',         // Provide appropriate value
    calories: '200 سعرة',         // Provide appropriate value
    ),},
    {'label': 'نصائح رياضية', 'image': 'assets/images/S1.png', 'page': FitnessTipsPage()},

  ];

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToPage(context, options[index]['page']);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            options[index]['image'],
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            options[index]['label'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: PrimaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
