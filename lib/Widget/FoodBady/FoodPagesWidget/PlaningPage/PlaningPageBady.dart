import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_firebase_project/Conist.dart';

class MealPlannerScreen extends StatelessWidget {
  final List<String> sliderTexts = [
    "بعد تنظيم وجباتك اليومية جزءًا أساسيًا من التحكم في مستوى السكر في الدم والحفاظ على نمط حياة صحي",
    "يساعد التخطيط الجيد للوجبات على تجنب الارتفاع المفاجئ أو الانخفاض الحاد في مستويات السكر مما يحافظ على توازن الجسم وصحته",
  ];

  final List<Map<String, String>> mealData = [
    {"الوجبة": "الإفطار", "الأطعمة": "🥚 بيض مسلوق + 🍞 خبز أسمر + 🥗 خضار طازجة + 🥛 كوب حليب قليل الدسم"},
    {"الوجبة": "وجبة خفيفة صباحية", "الأطعمة": "🥜 حفنة مكسرات غير مملحة + 🍏 فاكهة منخفضة السكر (تفاح أو برتقال)"},
    {"الوجبة": "الغداء", "الأطعمة": "🍗 صدر دجاج مشوي + 🍚 أرز بني + 🥗 سلطة خضراء بزيت الزيتون"},
    {"الوجبة": "وجبة خفيفة بعد الظهر", "الأطعمة": "🍦 زبادي يوناني قليل الدسم + 🥄 ملعقة صغيرة من بذور الشيا"},
    {"الوجبة": "العشاء", "الأطعمة": "🥣 شوربة عدس + 🍞 خبز كامل الحبوب + 🥦 طبق صغير من الخضار المطهوة على البخار"},
    {"الوجبة": "وجبة خفيفة مسائية", "الأطعمة": "🧀 قطعة صغيرة من الجبن قليل الدسم + 🥜 حفنة من اللوز"},
  ];

  final List<Map<String, String>> tipsData = [
    {"icon": "🥗", "tip": "تناول الألياف مثل الخضروات الورقية للحد من ارتفاع السكر بعد الأكل."},
    {"icon": "🚰", "tip": "اشرب الماء قبل الوجبات للمساعدة في التحكم في الشهية."},
    {"icon": "⚖️", "tip": "اختر الكربوهيدرات المعقدة مثل الشوفان بدلًا من الخبز الأبيض."},
    {"icon": "⏳", "tip": "قسّم وجباتك على مدار اليوم للحفاظ على استقرار السكر."},
    {"icon": "🍛", "tip": "تجنب الأطعمة المصنعة والسكريات المخفية."},
    {"icon": "🍎", "tip": "استبدل الحلويات بالفواكه الطازجة الغنية بالألياف."},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        // 📌 شريط النصائح المتحرك
        Card(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: CarouselSlider(
              options: CarouselOptions(height: 110, autoPlay: true, enlargeCenterPage: true),
              items: sliderTexts.map((text) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 📌 قائمة الوجبات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: mealData.length + 1, // +1 لإضافة قسم النصائح
            itemBuilder: (context, index) {
              if (index < mealData.length) {
                final meal = mealData[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      meal["الوجبة"]!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: PrimaryColor),
                    ),
                    subtitle: Text(
                      meal["الأطعمة"]!,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    leading: const Icon(Icons.fastfood, color: SecondryColor),
                  ),
                );
              } else {
                // 📌 قسم النصائح بعد التنسيق الجديد
                return Card(
                  color: Colors.white, // لون خلفية فاتح
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "✅ نصائح لتخطيط وجباتك بذكاء",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor),
                          ),
                        ),
                        const Divider(thickness: 1, color: PrimaryColor),
                        ...tipsData.map((tip) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tip["icon"]!, style: const TextStyle(fontSize: 24)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    tip["tip"]!,
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
