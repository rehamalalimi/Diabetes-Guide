import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';

class MealTableScreen extends StatelessWidget {
  final List<Map<String, String>> meals = [
    {
      'category': 'غداء',
      'meal': 'مطبق خضار باللحم',
      'ingredients': 'لحم قليل الدهن، بامية، كوسا، طماطم، بصل، بهارات يمنية',
      'calories': '350',
      'details':
      'طريقة التحضير: يُطهى اللحم مع الخضار والتوابل حتى ينضج.\nالفوائد: يحتوي على بروتينات وفيتامينات من الخضار.'
    },
    {
      'category': 'غداء',
      'meal': 'زربيان دجاج صحي',
      'ingredients': 'أرز بسمتي، دجاج منزوع الجلد، بطاطس مشوية، زبادي، بهارات',
      'calories': '400',
      'details':
      'طريقة التحضير: يُسلق الأرز ويُطهى الدجاج مع البهارات ثم يُخلط.\nالفوائد: مصدر جيد للبروتين والكربوهيدرات الصحية.'
    },
  ];

  void showMealDetails(BuildContext context, String details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('تفاصيل الوجبة', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
          content: Text(details, style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إغلاق', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
              columns: [
                DataColumn(label: Text('الفئة', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('الوجبة', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('المكونات', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('السعرات', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('عرض المزيد', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: meals.map((meal) {
                return DataRow(cells: [
                  DataCell(Text(meal['category']!)),
                  DataCell(Text(meal['meal']!, style: TextStyle(fontWeight: FontWeight.w600, color: SecondryColor))),
                  DataCell(Text(meal['ingredients']!)),
                  DataCell(Text(meal['calories']! + ' سعره حرارية', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                  DataCell(
                    TextButton(
                      onPressed: () => showMealDetails(context, meal['details']!),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 18, color: PrimaryColor),
                          SizedBox(width: 4),
                          Text('عرض المزيد', style: TextStyle(color: PrimaryColor)),
                        ],
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}