// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../screens/Login&Sign/firebase_service.dart';
// import 'FlutterServiceGlucose.dart';
//
// class GlucosePredictionScreen extends StatefulWidget {
//   final String userId;
//
//   const GlucosePredictionScreen({super.key, required this.userId});
//
//   @override
//   _GlucosePredictionScreenState createState() => _GlucosePredictionScreenState();
// }
//
// class _GlucosePredictionScreenState extends State<GlucosePredictionScreen> {
//   final GlucoseService _glucoseService = GlucoseService();
//   final FirebaseService _firebaseService = FirebaseService();
//
//   final TextEditingController _triglyceridesController = TextEditingController();
//   final TextEditingController _fastingGlucoseController = TextEditingController();
//   final TextEditingController _currentGlucoseController = TextEditingController();
//   final TextEditingController _carbsController = TextEditingController();
//
//   double? _tyGIndex;
//   double? _predictedGlucose;
//   String? _tyGInterpretation;
//   bool _isLoading = false;
//
//   List<Map<String, dynamic>> _predictionHistory = [];
//   Map<String, dynamic>? _userData;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadHistory();
//   }
//
//   Future<void> _loadUserData() async {
//     final data = await FirebaseService.getUserData(widget.userId);
//     setState(() => _userData = data);
//   }
//
//   Future<void> _loadHistory() async {
//     final history = await FirebaseService.getGlucoseHistory(widget.userId);
//     setState(() => _predictionHistory = history);
//   }
//
//   Future<void> _predictAndSave() async {
//     setState(() => _isLoading = true);
//
//     try {
//       // حساب مؤشر TyG إذا كانت القيم متوفرة
//       if (_triglyceridesController.text.isNotEmpty &&
//           _fastingGlucoseController.text.isNotEmpty) {
//         _tyGIndex = await _glucoseService.calculateTyGIndex(
//           double.parse(_triglyceridesController.text),
//           double.parse(_fastingGlucoseController.text),
//         );
//         final interpretation = await _glucoseService.interpretTyGIndex(_tyGIndex!);
//         setState(() => _tyGInterpretation = interpretation);
//       }
//
//       // توقع مستوى الجلوكوز
//       _predictedGlucose = await _glucoseService.predictGlucose(
//         double.parse(_currentGlucoseController.text),
//         double.parse(_carbsController.text),
//         _tyGIndex,
//       );
//
//       // حفظ في Firestore
//       await FirebaseService.saveGlucosePrediction(
//         userId: widget.userId,
//         currentGlucose: double.parse(_currentGlucoseController.text),
//         predictedGlucose: _predictedGlucose!,
//         carbsConsumed: double.parse(_carbsController.text),
//         tyGIndex: _tyGIndex,
//         interpretation: _tyGInterpretation ?? 'لم يتم الحساب',
//       );
//
//       // تحديث السجل
//       await _loadHistory();
//
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_userData?['name'] != null
//             ? 'توقعات الجلوكوز لـ ${_userData!['name']}'
//             : 'توقعات مستوى الجلوكوز'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // نموذج الإدخال
//             TextField(
//               controller: _triglyceridesController,
//               decoration: InputDecoration(labelText: 'الدهون الثلاثية (ملغم/ديسيلتر)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _fastingGlucoseController,
//               decoration: InputDecoration(labelText: 'جلوكوز الصيام (ملغم/ديسيلتر)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _currentGlucoseController,
//               decoration: InputDecoration(labelText: 'الجلوكوز الحالي (ملغم/ديسيلتر)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _carbsController,
//               decoration: InputDecoration(labelText: 'الكربوهيدرات المستهلكة (جرام)'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _predictAndSave,
//               child: _isLoading
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text('توقع واحفظ'),
//             ),
//
//             // عرض النتائج
//             if (_tyGIndex != null) ...[
//               SizedBox(height: 20),
//               Text('مؤشر TyG: ${_tyGIndex!.toStringAsFixed(2)}',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Text('التفسير: $_tyGInterpretation'),
//             ],
//
//             if (_predictedGlucose != null) ...[
//               SizedBox(height: 20),
//               Text('الجلوكوز المتوقع: ${_predictedGlucose!.toStringAsFixed(2)} ملغم/ديسيلتر',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//             ],
//
//             // قائمة السجل
//             SizedBox(height: 20),
//             Text('سجل التوقعات',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (_predictionHistory.isNotEmpty)
//               ..._predictionHistory.map((prediction) => Card(
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   title: Text('${prediction['predictedGlucose']} ملغم/ديسيلتر'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('الحالي: ${prediction['currentGlucose']} ملغم/ديسيلتر'),
//                       Text('الكربوهيدرات: ${prediction['carbsConsumed']} جرام'),
//                       Text(DateFormat('MMM d, y - h:mm a').format(prediction['timestamp'])),
//                     ],
//                   ),
//                   trailing: Text(prediction['interpretation']),
//                 ),
//               )).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _triglyceridesController.dispose();
//     _fastingGlucoseController.dispose();
//     _currentGlucoseController.dispose();
//     _carbsController.dispose();
//     super.dispose();
//   }
// }