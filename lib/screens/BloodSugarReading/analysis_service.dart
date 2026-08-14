import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'notification_service.dart';

Future<Map<String, dynamic>> analyzeSugarReadings() async {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final now = DateTime.now();
  final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

  final querySnapshot = await FirebaseFirestore.instance
      .collection('sugar_tests')
      .where('userId', isEqualTo: userId)
      .where('timestamp', isGreaterThanOrEqualTo: threeMonthsAgo)
      .orderBy('timestamp', descending: true)
      .get();

  int highCount = 0;
  int lowCount = 0;
  int normalCount = 0;
  double totalValue = 0;
  int totalReadings = querySnapshot.docs.length;

  for (var doc in querySnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final value = double.tryParse(data['value'].toString()) ?? 0;
    totalValue += value;

    if (data['result'].toString().contains('منخفض')) {
      lowCount++;
    } else if (data['result'].toString().contains('مرتفع') ||
        data['result'].toString().contains('مريض سكر')) {
      highCount++;
    } else if (data['result'].toString().contains('طبيعي')) {
      normalCount++;
    }
  }

  final averageValue = totalReadings > 0 ? totalValue / totalReadings : 0;
  String status = 'unknown';

  if (highCount > lowCount && highCount > normalCount) {
    status = 'high';
  } else if (lowCount > highCount && lowCount > normalCount) {
    status = 'low';
  } else if (normalCount > highCount && normalCount > lowCount) {
    status = 'normal';
  }

  return {
    'status': status,
    'average': averageValue,
    'totalReadings': totalReadings,
    'highCount': highCount,
    'lowCount': lowCount,
    'normalCount': normalCount,
  };
}

Future<void> _showNotificationBasedOnAnalysis(Map<String, dynamic> analysis) async {
  final status = analysis['status'];
  final average = analysis['average'];

  if (status == 'unknown') return;

  String title = '';
  String message = '';

  switch (status) {
    case 'high':
      title = 'تحذير: مستوى السكر مرتفع';
      message = '''
نلاحظ أن معظم قراءات السكر لديك مرتفعة (المتوسط: ${average.toStringAsFixed(1)}).
ننصحك بـ:
- الالتزام بالحمية الغذائية
- تناول الأدوية في مواعيدها
- متابعة طبيب الباطنة
- ممارسة الرياضة بانتظام
- تجنب الضغوط النفسية
- النوم بشكل كافٍ
''';
      break;
    case 'low':
      title = 'انتباه: مستوى السكر منخفض';
      message = '''
نلاحظ أن معظم قراءات السكر لديك منخفضة (المتوسط: ${average.toStringAsFixed(1)}).
ننصحك بـ:
- الاهتمام بالتغذية الصحية
- متابعة الطبيب لتعديل الجرعة
- تناول وجبات صغيرة متكررة
- حمل حلوى سريعة المفعول للطوارئ
''';
      break;
    case 'normal':
      title = 'أحسنت! مستوى السكر طبيعي';
      message = '''
ممتاز! معظم قراءات السكر لديك ضمن المعدل الطبيعي (المتوسط: ${average.toStringAsFixed(1)}).
نشجعك على:
- المواصلة على هذا المنوال
- الحفاظ على نظامك الغذائي
- متابعة الفحوصات الدورية
- ممارسة الرياضة بانتظام
''';
      break;
    default:
      return;
  }

  await NotificationService.showNotification(title: title, body: message);
}