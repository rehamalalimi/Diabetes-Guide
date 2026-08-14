import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Conist.dart';
import '../DoctorAndBook/Doctor&BookScreesn.dart';

class PrediabetesTestScreen extends StatefulWidget {
  @override
  _PrediabetesTestScreenState createState() => _PrediabetesTestScreenState();
}

class _PrediabetesTestScreenState extends State<PrediabetesTestScreen> {
  int score = 0;
  int currentIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'كم عمرك؟',
      'options': {
        'أقل من 40': 0,
        '40-49': 1,
        '50-59': 2,
        '60 فأكثر': 3,
      },
    },
    {
      'question': 'هل أنت ذكر أو أنثى؟',
      'options': {
        'ذكر': 1,
        'أنثى': 0,
      },
    },
    {
      'question': 'هل لديك قريب من الدرجة الأولى (أب أو أم أو أخ أو أخت) مصاب بالسكري؟',
      'options': {
        'نعم': 1,
        'لا': 0,
      },
    },
    {
      'question': 'هل تم تشخيصك بارتفاع مستوى السكر في الدم من قبل؟',
      'options': {
        'نعم': 1,
        'لا': 0,
      },
    },
    {
      'question': 'هل تمارس الرياضة؟',
      'options': {
        'نعم': 0,
        'لا': 1,
      },
    },
    {
      'question': 'كم طولك؟',
      'options': {
        'أقل من 150 سم': 0,
        '150-160 سم': 1,
        '160-170 سم': 3,
        '170-180 سم': 4,
        'أكثر من 180 سم': 5,
      },
    },
    {
      'question': 'ما هو محيط خصرك؟',
      'options': {
        'أقل من 80 سم': 0,
        '80-95 سم': 1,
        '95-110 سم': 3,
        'أكثر من 110 سم': 4,
      },
    },
  ];

  void nextQuestion(int value) {
    setState(() {
      score += value;
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    String result;
    String resultDetails;
    Color resultColor;

    if (score >= 5) {
      result = 'خطر مرتفع';
      resultDetails = 'أنت في خطر مرتفع لمقدمات السكري، يُفضل استشارة الطبيب.';
      resultColor = SecondryColor;
    } else {
      result = 'خطر منخفض';
      resultDetails = 'خطر الإصابة بمقدمات السكري لديك منخفض.';
      resultColor = successColor;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'نتيجة الاختبار',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: resultColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    resultDetails,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'نقاطك: $score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PrimaryColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      score = 0;
                      currentIndex = 0;
                    });
                  },
                  child: Text(
                    'إعادة الاختبار',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: PrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  child: Text(
                    'الرجوع للصفحة الرئيسية',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: PrimaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SecondryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.to(() => DoctorScreen());
                  },
                  child: Text(
                    'حجز موعد عند الطبيب',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'اختبار خطر الإصابة بمرحلة ما قبل السكري',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: PrimaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [PrimaryColor, PrimaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BackgroundColor,
              Colors.white,
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(PrimaryColor),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),

              // Question card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        PrimaryColor.withOpacity(0.1),
                        PrimaryColor.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'السؤال ${currentIndex + 1}/${questions.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: PrimaryColor,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        currentQuestion['question'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Options
              ...currentQuestion['options'].entries.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PrimaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      padding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                    ),
                    onPressed: () => nextQuestion(option.value),
                    child: Text(
                      option.key,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}