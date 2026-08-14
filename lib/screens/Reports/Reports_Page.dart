//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import '../BloodSugarReading/initial_question_screen.dart';
//
// class TestHistoryScreen extends StatefulWidget {
//   @override
//   _TestHistoryScreenState createState() => _TestHistoryScreenState();
// }
//
// class _TestHistoryScreenState extends State<TestHistoryScreen> {
//   // نظام الألوان
//   final Color _primaryColor = Color(0xFF3366FF);
//   final Color _secondaryColor = Color(0xFF00CCFF);
//   final Color _successColor = Color(0xFF28A745);
//   final Color _warningColor = Color(0xFFFFC107);
//   final Color _dangerColor = Color(0xFFDC3545);
//   final Color _darkTextColor = Color(0xFF1A2E55);
//   final Color _lightTextColor = Color(0xFF6C757D);
//
//   Map<String, dynamic>? _analysisResult;
//   bool _showAnalysis = false;
//   bool _isLoading = true;
//   String _userCondition = '';
//   int _retryCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadWithRetry();
//   }
//
//   Future<void> _loadWithRetry() async {
//     try {
//       await _loadAnalysisData();
//       _retryCount = 0;
//     } catch (e) {
//       if (_retryCount < 3) {
//         _retryCount++;
//         await Future.delayed(Duration(seconds: 2));
//         await _loadWithRetry();
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('فشل تحميل البيانات بعد 3 محاولات')),
//           );
//         }
//       }
//     }
//   }
//
//   Future<void> _loadAnalysisData() async {
//     try {
//       if (mounted) {
//         setState(() => _isLoading = true);
//       }
//
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception('لم يتم تسجيل الدخول');
//       }
//
//       final now = DateTime.now();
//       final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
//
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('sugar_tests')
//           .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
//           .orderBy('timestamp', descending: true)
//           .get()
//           .timeout(const Duration(seconds: 15), onTimeout: () {
//         throw TimeoutException('استغرقت العملية وقتاً طويلاً');
//       });
//
//       if (querySnapshot.docs.isEmpty) {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//             _analysisResult = null;
//             _userCondition = 'لا توجد قراءات مسجلة في آخر 3 أشهر';
//           });
//         }
//         return;
//       }
//
//       int highCount = 0;
//       int lowCount = 0;
//       int normalCount = 0;
//       double totalValue = 0;
//
//
//       for (var doc in querySnapshot.docs) {
//         try {
//           final data = doc.data() as Map<String, dynamic>;
//
//           if (data['value'] == null || data['result'] == null || data['timestamp'] == null) {
//             continue;
//           }
//
//           final value = data['value'] as num;
//           final result = data['result'].toString();
//
//           totalValue += value.toDouble();
//
//             if (result.contains('مرتفع') || result.contains('مريض سكر')) {
//             highCount++;
//           } else if (result.contains('منخفض')){
//             lowCount++;
//           } else if (result.contains('طبيعي')){
//             normalCount++;
//           }
//         } catch (e) {
//           debugPrint('Error processing document ${doc.id}: $e');
//         }
//       }
//
//       if (highCount + lowCount + normalCount == 0) {
//         throw Exception('لا توجد قراءات صالحة للتحليل');
//       }
//
//       final totalReadings = highCount + lowCount + normalCount;
//       final average = totalValue / totalReadings;
//       String status;
//
//
//       if (highCount > totalReadings / 2) {
//         status = 'high';
//         _userCondition = '''
//           تحذير: يبدو أن مستوى السكر لديك غير منضبط (غالبية القراءات مرتفعة)
//
//           ننصحك بما يلي:
//           1. الالتزام بالحمية الغذائية الموصوفة
//           2. تناول الأدوية في مواعيدها
//           3. مراجعة طبيب الباطنة قريباً
//           4. ممارسة الرياضة بانتظام
//           5. تجنب الضغوط النفسية
//           6. النوم الكافي (7-8 ساعات يومياً)
//           7. شرب الماء بكميات كافية
//           8. مراقبة السكر بانتظام
//         ''';
//       } else if (lowCount > totalReadings / 2) {
//         status = 'low';
//         _userCondition = '''
//           انتباه: يبدو أن مستوى السكر لديك يميل إلى الانخفاض
//
//           ننصحك بما يلي:
//           1. مراجعة الطبيب لتعديل جرعات الأدوية
//           2. تناول وجبات صغيرة متكررة
//           3. الاحتفاظ بسكر سريع الامتصاص معك
//           4. مراقبة السكر قبل القيادة أو ممارسة الرياضة
//           5. إعلام المقربين بحالتك
//           6. تجنب تأخير الوجبات
//           7. مراجعة الطبيب في حال تكرار الانخفاض
//         ''';
//       } else if (normalCount > totalReadings / 2) {
//         status = 'normal';
//         _userCondition = '''
//           ممتاز! مستوى السكر لديك منضبط (غالبية القراءات طبيعية)
//
//           نصائح للمواصلة:
//           1. استمر في نظامك الغذائي الصحي
//           2. حافظ على مواعيد الأدوية والفحوصات
//           3. واصل ممارسة الرياضة المعتدلة
//           4. احرص على الفحوصات الدورية
//           5. سجل قراءاتك بانتظام
//           6. حافظ على وزن صحي
//           7. اشرب الماء بكميات كافية
//         ''';
//       } else   {
//         status = 'a';
//         _userCondition = '''
//           غير محدده ! مستوى السكر لديك مضطرب ( القراءات غير منظبطه)
//
//           نصائح للمواصلة:
//           1. استمر في نظامك الغذائي الصحي
//           2. حافظ على مواعيد الأدوية والفحوصات
//           3. واصل ممارسة الرياضة المعتدلة
//           4. احرص على الفحوصات الدورية
//           5. سجل قراءاتك بانتظام
//           6. حافظ على وزن صحي
//           7. اشرب الماء بكميات كافية
//         ''';
//
//       }
//
//       if (mounted) {
//         setState(() {
//           _analysisResult = {
//             'status': status,
//             'average': average,
//             'highCount': highCount,
//             'lowCount': lowCount,
//             'normalCount': normalCount,
//             'totalReadings': totalReadings,
//           };
//           _isLoading = false;
//         });
//       }
//
//       if (_showAnalysis && mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _showConditionAlert();
//         });
//       }
//
//     } on FirebaseException catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('خطأ في الاتصال بقاعدة البيانات: ${e.code}')),
//         );
//       }
//     } on TimeoutException catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('تم تجاوز وقت الانتظار: ${e.message}')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ غير متوقع: ${e.toString()}')),
//         );
//       }
//     }
//   }
//
//   Future<void> _generateAndSavePDF() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
//         );
//         return;
//       }
//
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('sugar_tests')
//           .where('userId', isEqualTo: user.uid)
//           .orderBy('timestamp', descending: true)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('لا توجد قراءات لحفظها')),
//         );
//         return;
//       }
//
//       final pdf = pw.Document();
//       final font = await PdfGoogleFonts.tajawalRegular();
//
//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Directionality(
//               textDirection: pw.TextDirection.rtl,
//               child: pw.Padding(
//                 padding: pw.EdgeInsets.all(20),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Header(
//                       level: 0,
//                       child: pw.Text('سجل قراءات السكر',
//                           style: pw.TextStyle(
//                               font: font,
//                               fontSize: 24,
//                               fontWeight: pw.FontWeight.bold)),
//                     ),
//                     pw.SizedBox(height: 20),
//                     if (_analysisResult != null)
//                       _buildPdfAnalysisSection(font),
//                     pw.SizedBox(height: 20),
//                     pw.Text('القراءات المسجلة:',
//                         style: pw.TextStyle(
//                             font: font,
//                             fontSize: 18,
//                             fontWeight: pw.FontWeight.bold)),
//                     pw.SizedBox(height: 10),
//                     pw.TableHelper.fromTextArray(
//                       context: context,
//                       cellAlignment: pw.Alignment.centerRight,
//                       headerStyle: pw.TextStyle(
//                           font: font, fontWeight: pw.FontWeight.bold),
//                       cellStyle: pw.TextStyle(font: font),
//                       headers: ['التاريخ', 'الوقت', 'النوع', 'القراءة (mg/dL)', 'الحالة'],
//                       data: querySnapshot.docs.map((doc) {
//                         final data = doc.data() as Map<String, dynamic>;
//                         final date = DateFormat('dd/MM/yyyy').format(data['timestamp'].toDate());
//                         final time = DateFormat('hh:mm a').format(data['timestamp'].toDate());
//                         final status = _getStatus(data['result'].toString());
//                         return [
//                           date,
//                           time,
//                           data['testType'] ?? 'غير محدد',
//                           data['value'].toString(),
//                           status
//                         ];
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//
//       await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdf.save(),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء إنشاء الملف: ${e.toString()}')),
//       );
//     }
//   }
//
//   pw.Widget _buildPdfAnalysisSection(pw.Font font) {
//     final status = _analysisResult!['status'];
//     final statusText = _getStatusText(status);
//
//     return pw.Container(
//       decoration: pw.BoxDecoration(
//         border: pw.Border.all(color: PdfColors.grey),
//         borderRadius: pw.BorderRadius.circular(10),
//       ),
//       padding: pw.EdgeInsets.all(15),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text('تحليل القراءات:',
//               style: pw.TextStyle(
//                   font: font,
//                   fontSize: 18,
//                   fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Row(
//             children: [
//               pw.Text('الحالة: ',
//                   style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
//               pw.Text(statusText, style: pw.TextStyle(font: font)),
//             ],
//           ),
//           pw.SizedBox(height: 5),
//           pw.Row(
//             children: [
//               pw.Text('متوسط القراءات: ',
//                   style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
//               pw.Text('${_analysisResult!['average'].toStringAsFixed(1)} mg/dL',
//                   style: pw.TextStyle(font: font)),
//             ],
//           ),
//           pw.SizedBox(height: 5),
//           pw.Row(
//             children: [
//               pw.Text('عدد القراءات: ',
//                   style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
//               pw.Text('${_analysisResult!['totalReadings']} قراءة',
//                   style: pw.TextStyle(font: font)),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//             children: [
//               _buildPdfCountChip('مرتفع', _analysisResult!['highCount'], font),
//               _buildPdfCountChip('منخفض', _analysisResult!['lowCount'], font),
//               _buildPdfCountChip('طبيعي', _analysisResult!['normalCount'], font),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   pw.Widget _buildPdfCountChip(String label, int count, pw.Font font) {
//     final color = _getPdfStatusColor(label);
//     return pw.Container(
//       padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: pw.BoxDecoration(
//
//         border: pw.Border.all(color: color),
//         borderRadius: pw.BorderRadius.circular(20),
//       ),
//       child: pw.Text('$label: $count',
//           style: pw.TextStyle(font: font, color: color)),
//     );
//   }
//
//   PdfColor _getPdfStatusColor(String status) {
//     switch (status) {
//       case 'مرتفع': return PdfColors.red;
//       case 'منخفض': return PdfColors.orange;
//       case 'طبيعي': return PdfColors.green;
//       default: return PdfColors.grey;
//     }
//   }
//
//   void _showConditionAlert() {
//     if (_userCondition.isEmpty || !mounted) return;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'نصيحة طبية',
//           style: TextStyle(
//             fontFamily: 'Tajawal',
//             fontWeight: FontWeight.bold,
//             color: _darkTextColor,
//           ),
//           textAlign: TextAlign.right,
//         ),
//         content: SingleChildScrollView(
//           child: Text(
//             _userCondition,
//             style: TextStyle(
//               fontFamily: 'Tajawal',
//               color: _darkTextColor,
//             ),
//             textAlign: TextAlign.right,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'حسناً',
//               style: TextStyle(
//                 fontFamily: 'Tajawal',
//                 color: _primaryColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _deleteReading(String docId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('sugar_tests')
//           .doc(docId)
//           .delete();
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('تم حذف القراءة بنجاح')),
//         );
//         _loadWithRetry();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('حدث خطأ أثناء حذف القراءة')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           'سجل قراءات السكر',
//           style: TextStyle(
//             fontFamily: 'Tajawal',
//             fontWeight: FontWeight.bold,
//             color: _darkTextColor,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: _darkTextColor),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.picture_as_pdf),
//             onPressed: _generateAndSavePDF,
//             tooltip: 'حفظ كملف PDF',
//           ),
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _loadWithRetry,
//             tooltip: 'تحديث البيانات',
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) => InitialQuestionScreen()));
//         },
//         child: Icon(Icons.add, color: Colors.white),
//         backgroundColor: _primaryColor,
//         elevation: 4,
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() => _showAnalysis = !_showAnalysis);
//                 if (_showAnalysis && _userCondition.isNotEmpty) {
//                   _showConditionAlert();
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     _showAnalysis ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                     color: Colors.white,
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     'تحليل قراءات السكر لآخر 3 أشهر',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                       fontFamily: 'Tajawal',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           if (_showAnalysis && _analysisResult != null) _buildAnalysisCard(),
//
//           Expanded(
//             child: _buildReadingsList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnalysisCard() {
//     final status = _analysisResult!['status'];
//     final Color statusColor = _getStatusColor(status);
//     final String statusText = _getStatusText(status);
//
//     return Card(
//       margin: EdgeInsets.all(16),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   _getStatusIcon(status),
//                   color: statusColor,
//                   size: 28,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   'تحليل قراءات السكر لآخر 3 أشهر',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: _darkTextColor,
//                     fontFamily: 'Tajawal',
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             _buildAnalysisRow('الحالة:', statusText, statusColor),
//             Divider(height: 20, thickness: 0.5),
//             _buildAnalysisRow(
//               'متوسط القراءات:',
//               '${_analysisResult!['average'].toStringAsFixed(1)} mg/dL',
//               _primaryColor,
//             ),
//             _buildAnalysisRow(
//               'عدد القراءات:',
//               '${_analysisResult!['totalReadings']} قراءة',
//               _primaryColor,
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildCountChip('مرتفع', _analysisResult!['highCount'], _dangerColor),
//                 _buildCountChip('منخفض', _analysisResult!['lowCount'], _warningColor),
//                 _buildCountChip('طبيعي', _analysisResult!['normalCount'], _successColor),
//               ],
//             ),
//             SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _showConditionAlert,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: statusColor.withOpacity(0.1),
//                 foregroundColor: statusColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.medical_services, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     'عرض النصائح الطبية',
//                     style: TextStyle(
//                       fontFamily: 'Tajawal',
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnalysisRow(String label, String value, Color valueColor) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 15,
//               color: _lightTextColor,
//               fontFamily: 'Tajawal',
//             ),
//           ),
//           SizedBox(width: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: valueColor,
//               fontFamily: 'Tajawal',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCountChip(String label, int count, Color color) {
//     return Chip(
//       label: Text(
//         '$label: $count',
//         style: TextStyle(
//           fontFamily: 'Tajawal',
//           color: color,
//         ),
//       ),
//       backgroundColor: color.withOpacity(0.1),
//       shape: StadiumBorder(
//         side: BorderSide(color: color.withOpacity(0.3)),
//       ),
//     );
//   }
//
//   Widget _buildReadingsList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('sugar_tests')
//           .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 50, color: _dangerColor),
//                 SizedBox(height: 16),
//                 Text(
//                   'حدث خطأ في تحميل القراءات',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: _dangerColor,
//                     fontFamily: 'Tajawal',
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.data?.docs.isEmpty ?? true) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.assignment_outlined, size: 50, color: _lightTextColor),
//                 SizedBox(height: 16),
//                 Text(
//                   'لا توجد قراءات مسجلة بعد',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: _lightTextColor,
//                     fontFamily: 'Tajawal',
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.separated(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           itemCount: snapshot.data!.docs.length,
//           separatorBuilder: (context, index) => Divider(height: 1),
//           itemBuilder: (context, index) {
//             var doc = snapshot.data!.docs[index];
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             return _buildReadingCard(data, doc.id);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildReadingCard(Map<String, dynamic> data, String docId) {
//     final date = DateFormat('dd/MM/yyyy').format(data['timestamp'].toDate());
//     final time = DateFormat('hh:mm a').format(data['timestamp'].toDate());
//     final value = data['value'].toString();
//     final status = _getStatus(data['result'].toString());
//
//     return Card(
//       elevation: 0,
//       margin: EdgeInsets.symmetric(vertical: 4),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {},
//         onLongPress: () {
//           _showDeleteDialog(docId);
//         },
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     date,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: _lightTextColor,
//                       fontFamily: 'Tajawal',
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _getStatusColor(status).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           status,
//                           style: TextStyle(
//                             color: _getStatusColor(status),
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Tajawal',
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       IconButton(
//                         icon: Icon(Icons.delete_outline, size: 20, color: _lightTextColor),
//                         onPressed: () => _showDeleteDialog(docId),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         time,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: _lightTextColor,
//                           fontFamily: 'Tajawal',
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'نوع الفحص: ${data['testType']}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: _darkTextColor,
//                           fontFamily: 'Tajawal',
//                         ),
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         '$value MG/DL',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: _darkTextColor,
//                           fontFamily: 'Tajawal',
//                         ),
//                       ),
//                       Text(
//                         '${_convertToMmol(double.parse(value))} Mmol/L',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: _lightTextColor,
//                           fontFamily: 'Tajawal',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               if (data.containsKey('pulse') && data['pulse'] != null)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8),
//                   child: Row(
//                     children: [
//                       Icon(Icons.favorite, color: Colors.red, size: 16),
//                       SizedBox(width: 4),
//                       Text(
//                         'نبض: ${data['pulse']}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: _lightTextColor,
//                           fontFamily: 'Tajawal',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               if (data.containsKey('notes') && data['notes'] != null && data['notes'].toString().isNotEmpty)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.note, size: 16, color: _lightTextColor),
//                       SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           'ملاحظات: ${data['notes']}',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: _lightTextColor,
//                             fontFamily: 'Tajawal',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteDialog(String docId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'حذف القراءة',
//           style: TextStyle(
//             fontFamily: 'Tajawal',
//             fontWeight: FontWeight.bold,
//             color: _darkTextColor,
//           ),
//           textAlign: TextAlign.right,
//         ),
//         content: Text(
//           'هل أنت متأكد من رغبتك في حذف هذه القراءة؟',
//           style: TextStyle(
//             fontFamily: 'Tajawal',
//             color: _darkTextColor,
//           ),
//           textAlign: TextAlign.right,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'إلغاء',
//               style: TextStyle(
//                 fontFamily: 'Tajawal',
//                 color: _lightTextColor,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _deleteReading(docId);
//             },
//             child: Text(
//               'حذف',
//               style: TextStyle(
//                 fontFamily: 'Tajawal',
//                 color: _dangerColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _convertToMmol(double mgDl) {
//     return (mgDl / 18).toStringAsFixed(1);
//   }
//
//   String _getStatus(String result) {
//     if (result.contains('منخفض')) return 'منخفض';
//     if (result.contains('مرتفع')) return 'مرتفع';
//     if (result.contains('طبيعي')) return 'طبيعي';
//     return 'غير معروف';
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'منخفض': return _warningColor;
//       case 'مرتفع': return _dangerColor;
//       case 'طبيعي': return _successColor;
//       default: return _lightTextColor;
//     }
//   }
//
//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'high': return Icons.warning_amber_rounded;
//       case 'low': return Icons.warning_amber_rounded;
//       case 'normal': return Icons.check_circle_outline;
//       default: return Icons.help_outline;
//     }
//   }
//
//   String _getStatusText(String status) {
//     switch (status) {
//       case 'high': return 'غير منضبط (مرتفع)';
//       case 'low': return 'غير منضبط (منخفض)';
//       case 'normal': return 'منضبط';
//       default: return 'غير محدد';
//     }
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../BloodSugarReading/initial_question_screen.dart';

class TestHistoryScreen extends StatefulWidget {
  @override
  _TestHistoryScreenState createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  // نظام الألوان
  final Color _primaryColor = Color(0xFF3366FF);
  final Color _secondaryColor = Color(0xFF00CCFF);
  final Color _successColor = Color(0xFF28A745);
  final Color _warningColor = Color(0xFFFFC107);
  final Color _dangerColor = Color(0xFFDC3545);
  final Color _darkTextColor = Color(0xFF1A2E55);
  final Color _lightTextColor = Color(0xFF6C757D);

  Map<String, dynamic>? _analysisResult;
  bool _showAnalysis = false;
  bool _isLoading = true;
  String _userCondition = '';
  int _retryCount = 0;
  bool _isConnected = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _loadWithRetry();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });

      if (!_isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يوجد اتصال بالإنترنت')),
        );
      } else {
        _loadWithRetry();
      }
    });

    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadWithRetry() async {
    if (!_isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكن تحميل البيانات بدون اتصال بالإنترنت')),
        );
      }
      return;
    }

    try {
      await _loadAnalysisData();
      _retryCount = 0;
    } catch (e) {
      if (_retryCount < 3) {
        _retryCount++;
        await Future.delayed(Duration(seconds: 2));
        await _loadWithRetry();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل تحميل البيانات بعد 3 محاولات')),
          );
        }
      }
    }
  }

  Future<void> _loadAnalysisData() async {
    try {
      if (mounted) {
        setState(() => _isLoading = true);
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('لم يتم تسجيل الدخول');
      }

      final now = DateTime.now();
      final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('sugar_tests')
          .where('userId', isEqualTo: user.uid)
          .where('timestamp', isGreaterThanOrEqualTo: threeMonthsAgo)
          .orderBy('timestamp', descending: true)
          .get()
          .timeout(const Duration(seconds: 15));

      if (querySnapshot.docs.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _analysisResult = null;
            _userCondition = 'لا توجد قراءات مسجلة في آخر 3 أشهر';
          });
        }
        return;
      }

      int highCount = 0;
      int lowCount = 0;
      int normalCount = 0;
      double totalValue = 0;

      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;

          if (data['value'] == null || data['result'] == null || data['timestamp'] == null) {
            continue;
          }

          final value = data['value'] as num;
          final result = data['result'].toString();

          totalValue += value.toDouble();

          if (result.contains('مرتفع') || result.contains('مريض سكر')) {
            highCount++;
          } else if (result.contains('منخفض')){
            lowCount++;
          } else if (result.contains('طبيعي')){
            normalCount++;
          }
        } catch (e) {
          debugPrint('Error processing document ${doc.id}: $e');
        }
      }

      if (highCount + lowCount + normalCount == 0) {
        throw Exception('لا توجد قراءات صالحة للتحليل');
      }

      final totalReadings = highCount + lowCount + normalCount;
      final average = totalValue / totalReadings;
      String status;

      if (highCount > totalReadings / 2) {
        status = 'high';
        _userCondition = '''
          تحذير: يبدو أن مستوى السكر لديك غير منضبط (غالبية القراءات مرتفعة)
          
          ننصحك بما يلي:
          1. الالتزام بالحمية الغذائية الموصوفة
          2. تناول الأدوية في مواعيدها
          3. مراجعة طبيب الباطنة قريباً
          4. ممارسة الرياضة بانتظام
          5. تجنب الضغوط النفسية
          6. النوم الكافي (7-8 ساعات يومياً)
          7. شرب الماء بكميات كافية
          8. مراقبة السكر بانتظام
        ''';
      } else if (lowCount > totalReadings / 2) {
        status = 'low';
        _userCondition = '''
          انتباه: يبدو أن مستوى السكر لديك يميل إلى الانخفاض
          
          ننصحك بما يلي:
          1. مراجعة الطبيب لتعديل جرعات الأدوية
          2. تناول وجبات صغيرة متكررة
          3. الاحتفاظ بسكر سريع الامتصاص معك
          4. مراقبة السكر قبل القيادة أو ممارسة الرياضة
          5. إعلام المقربين بحالتك
          6. تجنب تأخير الوجبات
          7. مراجعة الطبيب في حال تكرار الانخفاض
        ''';
      } else if (normalCount > totalReadings / 2) {
        status = 'normal';
        _userCondition = '''
          ممتاز! مستوى السكر لديك منضبط (غالبية القراءات طبيعية)
          
          نصائح للمواصلة:
          1. استمر في نظامك الغذائي الصحي
          2. حافظ على مواعيد الأدوية والفحوصات
          3. واصل ممارسة الرياضة المعتدلة
          4. احرص على الفحوصات الدورية
          5. سجل قراءاتك بانتظام
          6. حافظ على وزن صحي
          7. اشرب الماء بكميات كافية
        ''';
      } else {
        status = 'a';
        _userCondition = '''
          غير محدده ! مستوى السكر لديك مضطرب ( القراءات غير منظبطه)
          
          نصائح للمواصلة:
          1. استمر في نظامك الغذائي الصحي
          2. حافظ على مواعيد الأدوية والفحوصات
          3. واصل ممارسة الرياضة المعتدلة
          4. احرص على الفحوصات الدورية
          5. سجل قراءاتك بانتظام
          6. حافظ على وزن صحي
          7. اشرب الماء بكميات كافية
        ''';
      }

      if (mounted) {
        setState(() {
          _analysisResult = {
            'status': status,
            'average': average,
            'highCount': highCount,
            'lowCount': lowCount,
            'normalCount': normalCount,
            'totalReadings': totalReadings,
          };
          _isLoading = false;
        });
      }

      if (_showAnalysis && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showConditionAlert();
        });
      }

    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الاتصال بقاعدة البيانات: ${e.code}')),
        );
      }
    } on TimeoutException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تجاوز وقت الانتظار: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ غير متوقع: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _generateAndSavePDF() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
        );
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('sugar_tests')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا توجد قراءات لحفظها')),
        );
        return;
      }

      final pdf = pw.Document();
      final font = await PdfGoogleFonts.tajawalRegular();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 0,
                      child: pw.Text('سجل قراءات السكر',
                          style: pw.TextStyle(
                              font: font,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(height: 20),
                    if (_analysisResult != null)
                      _buildPdfAnalysisSection(font),
                    pw.SizedBox(height: 20),
                    pw.Text('القراءات المسجلة:',
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.TableHelper.fromTextArray(
                      context: context,
                      cellAlignment: pw.Alignment.centerRight,
                      headerStyle: pw.TextStyle(
                          font: font, fontWeight: pw.FontWeight.bold),
                      cellStyle: pw.TextStyle(font: font),
                      headers: ['التاريخ', 'الوقت', 'النوع', 'القراءة (mg/dL)', 'الحالة'],
                      data: querySnapshot.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final date = DateFormat('dd/MM/yyyy').format(data['timestamp'].toDate());
                        final time = DateFormat('hh:mm a').format(data['timestamp'].toDate());
                        final status = _getStatus(data['result'].toString());
                        return [
                          date,
                          time,
                          data['testType'] ?? 'غير محدد',
                          data['value'].toString(),
                          status
                        ];
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إنشاء الملف: ${e.toString()}')),
      );
    }
  }

  pw.Widget _buildPdfAnalysisSection(pw.Font font) {
    final status = _analysisResult!['status'];
    final statusText = _getStatusText(status);

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      padding: pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('تحليل القراءات:',
              style: pw.TextStyle(
                  font: font,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Text('الحالة: ',
                  style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
              pw.Text(statusText, style: pw.TextStyle(font: font)),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pw.Text('متوسط القراءات: ',
                  style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
              pw.Text('${_analysisResult!['average'].toStringAsFixed(1)} mg/dL',
                  style: pw.TextStyle(font: font)),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pw.Text('عدد القراءات: ',
                  style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold)),
              pw.Text('${_analysisResult!['totalReadings']} قراءة',
                  style: pw.TextStyle(font: font)),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildPdfCountChip('مرتفع', _analysisResult!['highCount'], font),
              _buildPdfCountChip('منخفض', _analysisResult!['lowCount'], font),
              _buildPdfCountChip('طبيعي', _analysisResult!['normalCount'], font),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfCountChip(String label, int count, pw.Font font) {
    final color = _getPdfStatusColor(label);
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color),
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Text('$label: $count',
          style: pw.TextStyle(font: font, color: color)),
    );
  }

  PdfColor _getPdfStatusColor(String status) {
    switch (status) {
      case 'مرتفع': return PdfColors.red;
      case 'منخفض': return PdfColors.orange;
      case 'طبيعي': return PdfColors.green;
      default: return PdfColors.grey;
    }
  }

  void _showConditionAlert() {
    if (_userCondition.isEmpty || !mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'نصيحة طبية',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: _darkTextColor,
          ),
          textAlign: TextAlign.right,
        ),
        content: SingleChildScrollView(
          child: Text(
            _userCondition,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: _darkTextColor,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: _primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReading(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('sugar_tests')
          .doc(docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف القراءة بنجاح')),
        );
        _loadWithRetry();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء حذف القراءة')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'سجل قراءات السكر',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: _darkTextColor,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkTextColor),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _isConnected ? _generateAndSavePDF : null,
            tooltip: 'حفظ كملف PDF',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isConnected ? _loadWithRetry : null,
            tooltip: 'تحديث البيانات',
          ),
        ],
      ),
      floatingActionButton: _isConnected
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => InitialQuestionScreen()));
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: _primaryColor,
        elevation: 4,
      )
          : null,
      body: !_isConnected
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 50, color: _lightTextColor),
            SizedBox(height: 16),
            Text(
              'لا يوجد اتصال بالإنترنت',
              style: TextStyle(
                fontSize: 18,
                color: _lightTextColor,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadWithRetry,
              child: Text('إعادة المحاولة'),
            ),
          ],
        ),
      )
          : _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() => _showAnalysis = !_showAnalysis);
                if (_showAnalysis && _userCondition.isNotEmpty) {
                  _showConditionAlert();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _showAnalysis ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'تحليل قراءات السكر لآخر 3 أشهر',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_showAnalysis && _analysisResult != null) _buildAnalysisCard(),

          Expanded(
            child: _buildReadingsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard() {
    final status = _analysisResult!['status'];
    final Color statusColor = _getStatusColor(status);
    final String statusText = _getStatusText(status);

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: statusColor,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'تحليل قراءات السكر لآخر 3 أشهر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkTextColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildAnalysisRow('الحالة:', statusText, statusColor),
            Divider(height: 20, thickness: 0.5),
            _buildAnalysisRow(
              'متوسط القراءات:',
              '${_analysisResult!['average'].toStringAsFixed(1)} mg/dL',
              _primaryColor,
            ),
            _buildAnalysisRow(
              'عدد القراءات:',
              '${_analysisResult!['totalReadings']} قراءة',
              _primaryColor,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCountChip('مرتفع', _analysisResult!['highCount'], _dangerColor),
                _buildCountChip('منخفض', _analysisResult!['lowCount'], _warningColor),
                _buildCountChip('طبيعي', _analysisResult!['normalCount'], _successColor),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showConditionAlert,
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor.withOpacity(0.1),
                foregroundColor: statusColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'عرض النصائح الطبية',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
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

  Widget _buildAnalysisRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: _lightTextColor,
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountChip(String label, int count, Color color) {
    return Chip(
      label: Text(
        '$label: $count',
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: StadiumBorder(
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildReadingsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sugar_tests')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: _dangerColor),
                SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل القراءات',
                  style: TextStyle(
                    fontSize: 18,
                    color: _dangerColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data?.docs.isEmpty ?? true) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 50, color: _lightTextColor),
                SizedBox(height: 16),
                Text(
                  'لا توجد قراءات مسجلة بعد',
                  style: TextStyle(
                    fontSize: 18,
                    color: _lightTextColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return _buildReadingCard(data, doc.id);
          },
        );
      },
    );
  }

  Widget _buildReadingCard(Map<String, dynamic> data, String docId) {
    final date = DateFormat('dd/MM/yyyy').format(data['timestamp'].toDate());
    final time = DateFormat('hh:mm a').format(data['timestamp'].toDate());
    final value = data['value'].toString();
    final status = _getStatus(data['result'].toString());

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        onLongPress: () {
          _showDeleteDialog(docId);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: _lightTextColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20, color: _lightTextColor),
                        onPressed: () => _showDeleteDialog(docId),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: _lightTextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'نوع الفحص: ${data['testType']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _darkTextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$value MG/DL',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _darkTextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        '${_convertToMmol(double.parse(value))} Mmol/L',
                        style: TextStyle(
                          fontSize: 16,
                          color: _lightTextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (data.containsKey('pulse') && data['pulse'] != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'نبض: ${data['pulse']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _lightTextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              if (data.containsKey('notes') && data['notes'] != null && data['notes'].toString().isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, size: 16, color: _lightTextColor),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'ملاحظات: ${data['notes']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _lightTextColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف القراءة',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: _darkTextColor,
          ),
          textAlign: TextAlign.right,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف هذه القراءة؟',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: _darkTextColor,
          ),
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: _lightTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteReading(docId);
            },
            child: Text(
              'حذف',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: _dangerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _convertToMmol(double mgDl) {
    return (mgDl / 18).toStringAsFixed(1);
  }

  String _getStatus(String result) {
    if (result.contains('منخفض')) return 'منخفض';
    if (result.contains('مرتفع')) return 'مرتفع';
    if (result.contains('طبيعي')) return 'طبيعي';
    return 'غير معروف';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'منخفض': return _warningColor;
      case 'مرتفع': return _dangerColor;
      case 'طبيعي': return _successColor;
      default: return _lightTextColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'high': return Icons.warning_amber_rounded;
      case 'low': return Icons.warning_amber_rounded;
      case 'normal': return Icons.check_circle_outline;
      default: return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'high': return 'غير منضبط (مرتفع)';
      case 'low': return 'غير منضبط (منخفض)';
      case 'normal': return 'منضبط';
      default: return 'غير محدد';
    }
  }
}