import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';

class HealthyFoodScreen extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems = [
    {
      'unhealthy': 'اللحوم المصنعة مثل المرتديلا والنقانق',
      'reason': 'تحتوي على مواد حافظة ضارة وترفع مستوى الكوليسترول.',
      'healthy':
          '✅ لحوم طازجة مشوية أو مطهوة بالبخار.\n✅ بروتين نباتي مثل العدس والفول.'
    },
    {
      'unhealthy': 'الصلصات الجاهزة مثل المايونيز والكاتشب',
      'reason': 'تحتوي على سكريات مضافة ومواد حافظة غير صحية.',
      'healthy': '✅ مايونيز منزلي قليل الدسم.\n✅ كاتشب منزلي بدون سكر مضاف.'
    },
    {
      'unhealthy': 'الصلصات الجاهزة مثل المايونيز والكاتشب',
      'reason': 'تحتوي على سكريات مضافة ومواد حافظة غير صحية.',
      'healthy': '✅ مايونيز منزلي قليل الدسم.\n✅ كاتشب منزلي بدون سكر مضاف.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItems[index]['unhealthy'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SecondryColor),
                  ),
                  SizedBox(height: 5),
                  Text(foodItems[index]['reason'],
                      style: TextStyle(fontSize: 16)),
                  Divider(color: Colors.grey),
                  Text(
                    foodItems[index]['healthy'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
