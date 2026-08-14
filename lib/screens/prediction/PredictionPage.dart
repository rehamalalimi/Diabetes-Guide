import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'DiabetesPredictionService.dart';

const Color backgroundColor = Color(0xFFF1EFF1);
const Color primaryColor = Color(0xff1c6ab1);
const Color secondaryColor = Color(0xffdf3b25);

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> with SingleTickerProviderStateMixin {
  final DiabetesPredictionService _service = DiabetesPredictionService();
  final List<TextEditingController> _controllers = List.generate(8, (i) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _predictionResult;
  bool _isLoading = false;
  String? _selectedGender;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<String> featureLabels = [
    'عدد مرات الحمل',
    'مستوى الجلوكوز',
    'ضغط الدم',
    'سمك الجلد',
    'مستوى الأنسولين',
    'مؤشر كتلة الجسم',
    'دالة التاريخ العائلي للسكري',
    'العمر'
  ];

  @override
  void initState() {
    super.initState();
    _selectedGender = null;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateField(int index, String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'الرجاء إدخال رقم صحيح';
    }

    switch (index) {
      case 0: // Pregnancies
        if (number < 0 || number > 20) return 'يجب أن تكون بين 0 و 20';
        break;
      case 1: // Glucose
        if (number < 50 || number > 200) return 'يجب أن تكون بين 50 و 200 mg/dL';
        break;
      case 2: // Blood Pressure
        if (number < 40 || number > 140) return 'يجب أن تكون بين 40 و 140 mmHg';
        break;
      case 3: // Skin Thickness
        if (number < 0 || number > 100) return 'يجب أن تكون بين 0 و 100 mm';
        break;
      case 4: // Insulin
        if (number < 0 || number > 846) return 'يجب أن تكون بين 0 و 846 μU/mL';
        break;
      case 5: // BMI
        if (number < 10.0 || number > 67.1) return 'يجب أن تكون بين 10.0 و 67.1 kg/m²';
        break;
      case 6: // Diabetes Pedigree Function
        if (number < 0.078 || number > 2.42) return 'يجب أن تكون بين 0.078 و 2.42';
        break;
      case 7: // Age
        if (number < 21 || number > 81) return 'يجب أن تكون بين 21 و 81 سنة';
        break;
      default:
        return null;
    }
    return null;
  }

  void _updatePregnanciesField() {
    if (_selectedGender == 'ذكر') {
      _controllers[0].text = '0'; // Set pregnancies to 0 for male
      if (mounted) setState(() {}); // Update UI if widget is still mounted
    }
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) {
      // Auto-scroll to the first error field
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    try {
      final features = _controllers.map((controller) {
        final value = double.tryParse(controller.text);
        if (value == null) throw FormatException('Invalid number format');
        return value;
      }).toList();

      // Add timeout to prevent hanging
      final result = await _service.predictDiabetes(features)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException('Connection timed out. Please try again.');
      });

      setState(() {
        _predictionResult = result;
      });
      if (result != null && result.containsKey('prediction')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحليل البيانات بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _getHintTextForField(int index) {
    switch (index) {
      case 0: return '0-20';
      case 1: return '50-200 mg/dL';
      case 2: return '40-140 mmHg';
      case 3: return '0-100 mm';
      case 4: return '0-846 μU/mL';
      case 5: return '10.0-67.1 kg/m²';
      case 6: return '0.078-2.42';
      case 7: return '21-81 سنة';
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('التنبؤ السكر',style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Gender Selection with animation
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOutQuart,
                        )),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: InputDecoration(
                                labelText: 'الجنس',
                                border: InputBorder.none,
                                labelStyle: TextStyle(color: primaryColor),
                              ),
                              items: ['ذكر', 'انثى']
                                  .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender, style: const TextStyle(fontSize: 16)),
                              ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                                _updatePregnanciesField();
                              },
                              validator: (value) =>
                              value == null ? 'الرجاء اختيار الجنس' : null,
                              style: TextStyle(color: primaryColor),
                              icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                              dropdownColor: backgroundColor,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Form Fields with staggered animation
                      for (int i = 0; i < featureLabels.length; i++)
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.1 + (i * 0.05), 1, curve: Curves.easeOutQuart),
                          )),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextFormField(
                                  controller: _controllers[i],
                                  decoration: InputDecoration(
                                    labelText: featureLabels[i],
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: primaryColor),
                                    hintText: _getHintTextForField(i),
                                    hintStyle: TextStyle(color: Colors.grey.shade500),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => _validateField(i, value),
                                  enabled: i != 0 || _selectedGender != 'ذكر',
                                  readOnly: i == 0 && _selectedGender == 'ذكر',
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Animated Submit Button
                      ScaleTransition(
                        scale: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.6, 1, curve: Curves.elasticOut),
                          ),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                Color.lerp(primaryColor, secondaryColor, 0.3)!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _isLoading ? null : () {
                                if (_formKey.currentState!.validate()) {
                                  _predict();
                                } else {
                                  Scrollable.ensureVisible(
                                    context,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.medical_services, size: 24, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'تحليل خطر الإصابة بالسكري',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Results Section with animation
                      if (_predictionResult != null) ...[
                        const SizedBox(height: 30),
                        FadeTransition(
                          opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: const Interval(0.7, 1),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(0.7, 1),
                              ),
                            ),
                            child: _buildResultCard(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final isPositive = _predictionResult!['prediction'] == 1;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isPositive ? secondaryColor.withOpacity(0.1) : primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPositive ? secondaryColor : primaryColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPositive ? Icons.warning_amber_rounded : Icons.check_circle,
                    color: isPositive ? secondaryColor : primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    ' ${isPositive ? 'احتمال إصابة بالسكري' : 'لا يوجد مؤشرات للإصابة'}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? secondaryColor : primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _predictionResult!['probability'],
              backgroundColor: backgroundColor,
              color: isPositive ? secondaryColor : primaryColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'نسبة الاحتمال: ${(_predictionResult!['probability'] * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),

            if (_predictionResult!['medical_advice'] != null)
              _buildAdviceSection(_predictionResult!['medical_advice']),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceSection(Map<String, dynamic> advice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 12),
        _buildSectionTitle('حالة المريض'),
        Text(
          advice['status'],
          style: TextStyle(
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        _buildSectionTitle('النصيحة العامة'),
        _buildBulletPoint(advice['advice']),

        if (advice['immediate_actions'] != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('الإجراءات الفورية'),
          ...advice['immediate_actions'].map((action) => _buildBulletPoint(action)).toList(),
        ],

        if (advice['treatment_plan'] != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('خطة العلاج'),
          _buildSubSectionTitle('النظام الغذائي:'),
          ...advice['treatment_plan']['diet'].map((item) => _buildDashPoint(item)).toList(),

          _buildSubSectionTitle('الأدوية:'),
          ...advice['treatment_plan']['medication'].map((item) => _buildDashPoint(item)).toList(),

          _buildSubSectionTitle('التمارين:'),
          ...advice['treatment_plan']['exercise'].map((item) => _buildDashPoint(item)).toList(),
        ],

        if (advice['prohibitions'] != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('الممنوعات', isWarning: true),
          ...advice['prohibitions'].map((item) => _buildWarningPoint(item)).toList(),
        ],

        if (advice['prevention_plan'] != null) ...[
          const SizedBox(height: 16),
          _buildSectionTitle('خطة الوقاية'),
          _buildSubSectionTitle('النظام الغذائي الوقائي:'),
          ...advice['prevention_plan']['diet'].map((item) => _buildDashPoint(item)).toList(),

          _buildSubSectionTitle('نمط الحياة:'),
          ...advice['prevention_plan']['lifestyle'].map((item) => _buildDashPoint(item)).toList(),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, {bool isWarning = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isWarning ? secondaryColor : primaryColor,
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildDashPoint(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('- ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildWarningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✗ ', style: TextStyle(color: secondaryColor, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}