import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';

import '../../screens/Food/Food_Pages/DiabeticMeals_Page.dart';
import '../../screens/Food/Food_Pages/FoodsToAvoid_Page.dart';
import '../../screens/Food/Food_Pages/Planning_Page.dart';
import '../../screens/Food/Food_Pages/SugarAlternatives_Page.dart';

class FoodContent extends StatelessWidget {
  FoodContent({super.key});

  final List<Map<String, dynamic>> options = [
    {'label': 'التخطيط الغذائي', 'image': 'assets/images/food plan.png', 'page': PlanningPage()},
    {'label': 'بدائل السكر', 'image': 'assets/images/honey.jpeg', 'page': SugarAlternativesPage()},
    {'label': 'وجبات مناسبة لمرضى السكري', 'image': 'assets/images/apple.png', 'page': DiabeticMealsPage()},
    {'label': 'المأكولات التي يجب تجنبها', 'image': 'assets/images/avoid.jpeg', 'page': FoodsToAvoidPage()},
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
          const Text(
            "التغذية السليمة لمرضى السكري",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
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
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            options[index]['label'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: PrimaryColor ),
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
