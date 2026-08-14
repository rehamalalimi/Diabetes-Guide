import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../DoctorReservation/AppointmentCard.dart';


class Med extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'الأنسولين',
      'icon': Icons.medication,  // More specific than medical_services
      'page': const DiabetesInfoPage(),
      'color': Colors.teal
    },
    {
      'title': 'أنواع أدوية السكر',
      'icon': Icons.medication_liquid,  // Represents different medicine types
      'page': const DiabetesTypesPage(),
      'color': Colors.indigo
    },
    {
      'title': 'أعراض الجانبية',
      'icon': Icons.warning_rounded,  // Good for side effects
      'page': const SymptomsPage(),
      'color': Colors.orange
    },
    {
      'title': 'التداخلات الدوائية',
      'icon': Icons.merge,  // Represents drug interactions
      'page': const PreventionPage(),
      'color': Colors.green
    },
    {
      'title': 'أبرة السكري',
      'icon': Icons.vaccines,  // Better representation for diabetes needle
      'page': const NutritionTipsPage(),
      'color': Colors.purple
    },
  ];


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: primaryColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('مكتبة الأدوية',style: TextStyle(color: Colors.white),),

          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              return CategoryCard(
                title: item['title'],
                icon: item['icon'],
                page: item['page'],
                color: item['color'],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget page;
  final Color color;

  const CategoryCard({
    required this.title,
    required this.icon,
    required this.page,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _elevationAnimation,
        builder: (context, child) {
          return Card(
            elevation: _elevationAnimation.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) {
                _controller.reverse();
                Future.delayed(const Duration(milliseconds: 150), () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => widget.page,
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              onTapCancel: () => _controller.reverse(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withOpacity(0.2),
                      widget.color. withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.withOpacity(0.1),
                      ),
                      child: AnimatedIcon(
                        icon: widget.icon,
                        color: widget.color,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AnimatedIcon({
    required this.icon,
    required this.color,
    this.size = 24,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            Color.lerp(color, Colors.white, 0.3)!,
          ],
        ).createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

// Updated pages with medical-themed content
class DiabetesInfoPage extends StatelessWidget {
  const DiabetesInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'ما هو مرض السكري',
      content: 'مرض السكري هو حالة مزمنة تؤثر على كيفية معالجة الجسم للجلوكوز (السكر) في الدم.',
    );
  }
}

class DiabetesTypesPage extends StatelessWidget {
  const DiabetesTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'أنواع مرض السكري',
      content: 'النوع الأول: نقص إنتاج الإنسولين\nالنوع الثاني: مقاومة الإنسولين\nسكري الحمل: أثناء الحمل',
    );
  }
}

class SymptomsPage extends StatelessWidget {
  const SymptomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'أعراض مرض السكري',
      content: 'العطش الشديد، التبول المتكرر، الجوع المستمر، فقدان الوزن، التعب، عدم وضوح الرؤية',
    );
  }
}

class PreventionPage extends StatelessWidget {
  const PreventionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'الوقاية من السكري النوع الثاني',
      content: 'الحفاظ على وزن صحي، ممارسة الرياضة، تناول غذاء متوازن، تجنب التدخين',
    );
  }
}

class NutritionTipsPage extends StatelessWidget {
  const NutritionTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'نصائح غذائية مهمة',
      content: 'تناول الألياف، تقليل السكريات، اختيار الدهون الصحية، تقسيم الوجبات',
    );
  }
}

class SugarMonitoringPage extends StatelessWidget {
  const SugarMonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'مراقبة السكر',
      content: 'فحص السكر بانتظام، تسجيل النتائج، مراقبة التغيرات، استشارة الطبيب',
    );
  }
}

class ComplicationsPage extends StatelessWidget {
  const ComplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicalInfoPage(
      title: 'مضاعفات إهمال السكري',
      content: 'أمراض القلب، تلف الأعصاب، مشاكل الكلى، فقدان البصر، مشاكل القدم',
    );
  }
}

class MedicalInfoPage extends StatelessWidget {
  final String title;
  final String content;

  const MedicalInfoPage({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.6,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'العودة',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}