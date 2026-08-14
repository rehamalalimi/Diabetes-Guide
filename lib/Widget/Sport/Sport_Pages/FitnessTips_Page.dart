import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Conist.dart';

class FitnessTipsPage extends StatelessWidget {
  const FitnessTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: const Text("نصائح رياضية لمرضى السكري", style: TextStyle(fontFamily: 'Tajawal')),
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0,
        backgroundColor: PrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSectionTitle("أفضل الأوقات لممارسة الرياضة لمرضى السكري"),
            const SizedBox(height: 8),
            _buildTipCard(
              "الصباح الباكر",
              "ممارسة الرياضة في الصباح قبل الإفطار قد تساعد في تحسين حساسية الأنسولين. لكن يجب مراقبة السكر جيداً حيث قد ينخفض بشكل كبير.",
              Icons.wb_sunny,
            ),
            _buildTipCard(
              "بعد الوجبات بساعتين",
              "التمارين بعد ساعتين من تناول الطعام تساعد في تجنب ارتفاع السكر بعد الأكل مع تقليل خطر الهبوط المفاجئ.",
              Icons.access_time,
            ),
            _buildTipCard(
              "تجنب المساء المتأخر",
              "التمارين القوية في وقت متأخر من المساء قد تؤثر على مستويات السكر أثناء النوم. يفضل إنهاء التمارين قبل النوم ب 3 ساعات على الأقل.",
              Icons.nightlight_round,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("كيفية منع ارتفاع أو انخفاض السكر أثناء التمارين"),
            const SizedBox(height: 8),
            _buildTipCard(
              "فحص السكر قبل التمرين",
              "تحقق من مستوى السكر قبل البدء: إذا كان أقل من 100 ملغ/دل، تناول وجبة خفيفة. إذا كان أعلى من 250 ملغ/دل، تجنب التمارين الشديدة.",
              Icons.monitor_heart,
            ),
            _buildTipCard(
              "احمل وجبات خفيفة",
              "احمل معك عصير فواكه أو قطع حلوى سريعة المفعول لعلاج حالات هبوط السكر الطارئة أثناء التمرين.",
              Icons.fastfood,
            ),
            _buildTipCard(
              "اختر التمارين المناسبة",
              "تمارين المقاومة (رفع الأثقال) تسبب تقلبات أقل في السكر مقارنة بالتمارين الهوائية الطويلة. اخلط بين النوعين لتحقيق أفضل النتائج.",
              Icons.fitness_center,
            ),
            _buildTipCard(
              "ترطيب مستمر",
              "اشرب الماء قبل وأثناء وبعد التمرين. الجفاف يمكن أن يؤثر على مستويات السكر في الدم.",
              Icons.local_drink,
            ),
            _buildTipCard(
              "التدرج في الشدة",
              "ابدأ بتمارين خفيفة ثم زد الشدة تدريجياً. التوقف المفاجئ عن التمارين الشديدة قد يسبب هبوطاً حاداً في السكر.",
              Icons.trending_up,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: PrimaryColor,
        fontFamily: 'Tajawal',
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: PrimaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[700],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}