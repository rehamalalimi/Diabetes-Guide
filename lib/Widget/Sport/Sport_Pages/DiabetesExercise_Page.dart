import 'package:flutter/material.dart';

import '../../../Conist.dart';

class DiabetesExerciseScreen extends StatelessWidget {
  final List<Map<String, dynamic>> exercises = [
    {
      'icon': Icons.directions_walk,
      'title': 'المشي',
      'description': 'تمرين منخفض التأثير لتحسين الدورة الدموية.'
    },
    {
      'icon': Icons.self_improvement,
      'title': 'اليوغا',
      'description': 'تعزز المرونة وتقلل من التوتر.'
    },
    {
      'icon': Icons.pool,
      'title': 'السباحة',
      'description': 'تمرين لكامل الجسم مع الحد الأدنى من إجهاد المفاصل.'
    },
    {
      'icon': Icons.fitness_center,
      'title': 'تمارين القوة',
      'description': 'تبني العضلات وتحسن التمثيل الغذائي.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text("التمارين المناسبة لمرضى السكر"),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(exercises[index]['icon'],
                          size: 40, color: SecondryColor),
                      title: Text(exercises[index]['title'],
                          style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor)),
                      subtitle: Text(exercises[index]['description'],style: TextStyle(color:Colors.blue.shade700),),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
