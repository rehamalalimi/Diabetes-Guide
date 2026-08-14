import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';

class HealthySugarAlternativesScreen extends StatelessWidget {
  final List<Map<String, String>> alternatives = [
    {"image": "assets/images/honey11.jpg", "title": "العسل الطبيعي", "description": "يحتوي على مضادات أكسدة ومواد مغذية، يمكن استخدامه في التحلية الطبيعية للمشروبات والحلويات."},
    {"image": "assets/images/dates.jpg", "title": "معجون التمر", "description": "بديل طبيعي غني بالألياف والمعادن، يستخدم في الحلويات والمخبوزات."},
    {"image": "assets/images/stevia.jpg", "title": "ستيفيا", "description": "محلي طبيعي خالٍ من السعرات الحرارية، مناسب لمرضى السكري."},
    {"image": "assets/images/maple_syrup.jpg", "title": "شراب القيقب", "description": "يحتوي على معادن طبيعية ونكهة غنية، يستخدم في تحلية الأطعمة والمخبوزات."},
    {"image": "assets/images/coconut_sugar.jpg", "title": "سكر جوز الهند", "description": "يحتوي على مؤشر جلايسيمي منخفض، مناسب للتحلية في المشروبات والوصفات المختلفة."},
    {"image": "assets/agave.png", "title": "شراب الأغاف", "description": "محلي طبيعي ذو طعم خفيف، يُستخدم في المشروبات والمخبوزات."},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: alternatives.length,
                itemBuilder: (context, index) {
                  final item = alternatives[index];
                  return Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(item["image"]!, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                item["title"]!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item["description"]!,
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "✅ نصائح عند اختيار البديل",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: PrimaryColor),
                    ),
                    const Divider(thickness: 1, color: PrimaryColor),
                    const SizedBox(height: 5),
                    const Text("- استخدم المحليات الطبيعية بدلاً من السكر الأبيض.", style: TextStyle(fontSize: 16)),
                    const Text("- لا تكثر من العسل لأنه يحتوي على سعرات حرارية.", style: TextStyle(fontSize: 16)),
                    const Text("- اقرأ مكونات أي منتج يحتوي على محليات صناعية.", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),

    );
  }
}