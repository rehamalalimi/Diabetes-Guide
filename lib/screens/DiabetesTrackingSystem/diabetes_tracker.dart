import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../DoctorReservation/AppointmentCard.dart';



class DailyDiabetesForm extends StatefulWidget {
  const DailyDiabetesForm({Key? key}) : super(key: key);

  @override
  _DailyDiabetesFormState createState() => _DailyDiabetesFormState();
}

class _DailyDiabetesFormState extends State<DailyDiabetesForm> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _records = [];
  String _selectedMealTime = 'morning';
  String _selectedMeasurementType = 'before';
  final TextEditingController _valueController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadRecords();

  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('diabetes_tracker')
          .doc(user.uid)
          .collection('records')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _records = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'date': (data['date'] as Timestamp).toDate(),
            'measurements': Map<String, dynamic>.from(data['measurements']),
          };
        }).toList();
      });
    } catch (e) {
      _showErrorSnackbar('Failed to load records: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            surface: backgroundColor,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: backgroundColor,
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _showAddRecordDialog() async {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('إضافة قراءة جديدة',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                          const SizedBox(height: 16),
                          _buildDateSelector(context),
                          const SizedBox(height: 16),
                          _buildMealTimeDropdown(setState),
                          const SizedBox(height: 16),
                          if (_selectedMealTime != 'night') _buildMeasurementTypeDropdown(setState),
                          const SizedBox(height: 16),
                          _buildGlucoseInputField(),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDialogButton(text: 'إلغاء', color: Colors.grey, onPressed: () => Navigator.pop(context)),
                              _buildDialogButton(text: 'حفظ', color: primaryColor, onPressed: _saveRecord),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: ListTile(
        title: Text('التاريخ', style: TextStyle(color: primaryColor)),
        subtitle: Text(_formatDateWithDay(_selectedDate), style: const TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: Icon(Icons.calendar_today, color: primaryColor),
          onPressed: () => _selectDate(context),
        ),
      ),
    );
  }

  String _formatDateWithDay(DateTime date) {
    final dayName = DateFormat('EEEE', 'ar').format(date);
    return '${dayName} - ${DateFormat('yyyy-MM-dd').format(date)}';
  }

  Widget _buildMealTimeDropdown(void Function(void Function()) setState) {
    return DropdownButtonFormField<String>(
      value: _selectedMealTime,
      decoration: _buildInputDecoration('وقت الوجبة'),
      dropdownColor: backgroundColor,
      items: const [
        DropdownMenuItem(value: 'morning', child: Text('فطور')),
        DropdownMenuItem(value: 'noon', child: Text('غداء')),
        DropdownMenuItem(value: 'evening', child: Text('عشاء')),
        DropdownMenuItem(value: 'night', child: Text('قبل النوم')),
      ],
      onChanged: (value) => setState(() {
        _selectedMealTime = value!;
        if (_selectedMealTime == 'night') _selectedMeasurementType = 'before';
      }),
    );
  }

  Widget _buildMeasurementTypeDropdown(void Function(void Function()) setState) {
    return DropdownButtonFormField<String>(
      value: _selectedMeasurementType,
      decoration: _buildInputDecoration('نوع القياس'),
      dropdownColor: backgroundColor,
      items: const [
        DropdownMenuItem(value: 'before', child: Text('قبل الوجبة')),
        DropdownMenuItem(value: 'after', child: Text('بعد الوجبة')),
      ],
      onChanged: (value) => setState(() => _selectedMeasurementType = value!),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  Widget _buildGlucoseInputField() {
    return TextFormField(
      controller: _valueController,
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration('مستوى الجلوكوز (ملغم/دل)').copyWith(
        prefixIcon: Icon(Icons.monitor_heart, color: primaryColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'الرجاء إدخال قيمة';
        final numValue = double.tryParse(value);
        if (numValue == null) return 'الرجاء إدخال رقم صحيح';
        if (numValue < 20 || numValue > 500) return 'يجب أن تكون القيمة بين 20 و 500';
        return null;
      },
    );
  }

  Widget _buildDialogButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = _auth.currentUser;
        if (user == null) {
          _showErrorSnackbar('User not authenticated');
          return;
        }

        final measurementKey = _selectedMealTime == 'night'
            ? 'nightBefore'
            : '${_selectedMealTime}${_selectedMeasurementType == 'before' ? 'Before' : 'After'}';

        final value = double.parse(_valueController.text);
        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

        await _firestore
            .collection('diabetes_tracker')
            .doc(user.uid)
            .collection('records')
            .doc(formattedDate)
            .set({
          'date': _selectedDate,
          'measurements': {
            measurementKey: value,
          },
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        _valueController.clear();
        Navigator.pop(context);
        _loadRecords(); // Refresh the records
        _showSuccessSnackbar('تم حفظ القراءة بنجاح');
      } catch (e) {
        _showErrorSnackbar('Failed to save record: $e');
      }
    }
  }

  Future<void> _deleteRecord(String recordId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('diabetes_tracker')
          .doc(user.uid)
          .collection('records')
          .doc(recordId)
          .delete();

      _loadRecords(); // Refresh the records
      _showSuccessSnackbar('تم حذف السجل');
    } catch (e) {
      _showErrorSnackbar('Failed to delete record: $e');
    }
  }

  Future<void> _exportToPdf() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showErrorSnackbar('User not authenticated');
        return;
      }

      // Load a font that supports Arabic (replace with your actual font)
      final font = await PdfGoogleFonts.tajawalRegular(); // or use pw.Font.ttf()

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl, // Important for Arabic
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Header(
                      level: 0,
                      child: pw.Text('سجل قياسات السكري',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('المريض: ${user.displayName ?? 'غير معروف'}',
                        style: pw.TextStyle(font: font)),
                    pw.Text('تاريخ التقرير: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: pw.TextStyle(font: font)),
                    pw.Divider(),
                    pw.SizedBox(height: 20),

                    // Table with proper styling
                    pw.Table.fromTextArray(
                      context: context,
                      border: pw.TableBorder.all(width: 0.5),
                      headerStyle: pw.TextStyle(
                        font: font,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      cellStyle: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                      ),
                      headerDecoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                      ),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(1.5), // Wider date column
                      },
                      headers: [
                        'التاريخ',
                        'قبل الفطور',
                        'بعد الفطور',
                        'قبل الغداء',
                        'بعد الغداء',
                        'قبل العشاء',
                        'بعد العشاء',
                        'قبل النوم',
                      ],
                      data: _records.map((record) {
                        final measurements = record['measurements'];
                        return [
                          DateFormat('yyyy-MM-dd').format(record['date']),
                          measurements['morningBefore']?.toStringAsFixed(1) ?? '-',
                          measurements['morningAfter']?.toStringAsFixed(1) ?? '-',
                          measurements['noonBefore']?.toStringAsFixed(1) ?? '-',
                          measurements['noonAfter']?.toStringAsFixed(1) ?? '-',
                          measurements['eveningBefore']?.toStringAsFixed(1) ?? '-',
                          measurements['eveningAfter']?.toStringAsFixed(1) ?? '-',
                          measurements['nightBefore']?.toStringAsFixed(1) ?? '-',
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

      // Option 1: Share PDF (what you're currently doing)
      // await Printing.sharePdf(
      //   bytes: await pdf.save(),
      //   filename: 'diabetes_records_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      // );

      // Option 2: Save to device storage (add this if you want local saving)
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إنشاء الملف: ${e.toString()}')),
      );
    }
  }
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final measurements = record['measurements'];
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _animationController.reset();
          _animationController.forward();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDateWithDay(record['date'])),
                  IconButton(
                    icon: Icon(Icons.delete, color: secondaryColor),
                    onPressed: () => _deleteRecord(record['id']),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMeasurementRow('قبل الفطور', measurements['morningBefore']),
              _buildMeasurementRow('بعد الفطور', measurements['morningAfter']),
              _buildMeasurementRow('قبل الغداء', measurements['noonBefore']),
              _buildMeasurementRow('بعد الغداء', measurements['noonAfter']),
              _buildMeasurementRow('قبل العشاء', measurements['eveningBefore']),
              _buildMeasurementRow('بعد العشاء', measurements['eveningAfter']),
              _buildMeasurementRow('قبل النوم', measurements['nightBefore']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 14))),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _getValueColor(value),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value?.toStringAsFixed(1) ?? '-',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getValueColor(dynamic value) {
    if (value == null) return Colors.grey;
    final numValue = value.toDouble();
    if (numValue < 70) return Colors.blue;
    if (numValue < 100) return Colors.green;
    if (numValue < 140) return Colors.green;
    if (numValue < 200) return Colors.orange;
    return secondaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('تتبع السكري'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
            tooltip: 'تصدير إلى PDF',
          ),
        ],
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 80.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,

        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildAddButton(),
                  const SizedBox(height: 20),
                  _buildRecordsList(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecordDialog,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'إضافة قراءة جديدة',
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: _showAddRecordDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: 8),
          Text('إضافة قراءة جديدة', style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildRecordsList() {
    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Expanded(
      child: _records.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_heart_outlined, size: 60, color: primaryColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('لا توجد سجلات متاحة', style: TextStyle(fontSize: 18)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _records.length,
        itemBuilder: (context, index) => _buildRecordCard(_records[index]),
      ),
    );
  }
}