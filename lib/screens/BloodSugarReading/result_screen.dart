import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class ResultScreen extends StatefulWidget {
  final bool isDiabetic;
  final String testType;
  final double value;

  const ResultScreen({
    Key? key,
    required this.isDiabetic,
    required this.testType,
    required this.value,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _bgAnimation;

  static const Color backgroundColor = Color(0xFFF1EFF1);
  static const Color primaryColor = Color(0xff1c6ab1);
  static const Color secondaryColor = Color(0xffdf3b25);
  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF666666);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuint,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _bgAnimation = ColorTween(
      begin: backgroundColor.withOpacity(0),
      end: backgroundColor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  String _getResultMessage() {
    if (widget.isDiabetic) {
      return _getDiabeticResult();
    } else {
      return _getNonDiabeticResult();
    }
  }

  String _getDiabeticResult() {
    switch (widget.testType) {
      case '8-hours':
        if (widget.value < 70) {
          return 'منخفض - لديك هبوط سكر ويجب عليك أكل شيء سكري ليرتفع';
        } else if (widget.value >= 70 && widget.value <= 130) {
          return 'طبيعي - مستوى السكر لديك ضمن المعدل الطبيعي';
        } else {
          return 'مرتفع - مستوى السكر لديك أعلى من المعدل الطبيعي';
        }
      case '2-hours':
      case 'cumulative':
        if (widget.value < 70) {
          return 'منخفض - لديك هبوط سكر';
        } else if (widget.value >= 70 && widget.value <= 160) {
          return 'طبيعي - مستوى السكر لديك ضمن المعدل الطبيعي';
        } else {
          return 'مرتفع - مستوى السكر لديك أعلى من المعدل الطبيعي';
        }
      default:
        return 'نتيجة غير معروفة';
    }
  }

  String _getNonDiabeticResult() {
    switch (widget.testType) {
      case '8-hours':
        if (widget.value < 70) {
          return 'منخفض - لديك هبوط سكر';
        } else if (widget.value >= 70 && widget.value <= 100) {
          return 'طبيعي - سوف يتم تحويلك إلى واجهة اختبار الخطورة';
        } else if (widget.value > 100 && widget.value <= 125) {
          return 'مرحلة ما قبل السكري - سيتم تحويلك إلى واجهة اختبار الخطورة وإلى واجهة الدليل التوعوي';
        } else {
          return 'مرتفع - من الضروري الذهاب إلى أقرب طبيب';
        }
      case '2-hours':
        if (widget.value < 70) {
          return 'منخفض - لديك هبوط سكر';
        } else if (widget.value >= 70 && widget.value <= 130) {
          return 'طبيعي - مستوى السكر لديك ضمن المعدل الطبيعي';
        } else if (widget.value > 130 && widget.value <= 199) {
          return 'مرحلة ما قبل السكري';
        } else {
          return 'مريض سكر - من الضروري مراجعة الطبيب';
        }
      case 'cumulative':
        if (widget.value <= 5.4) {
          return 'طبيعي - مستوى السكر لديك ضمن المعدل الطبيعي';
        } else if (widget.value > 5.4 && widget.value <= 6.4) {
          return 'مرحلة ما قبل السكري - من الضروري زيارة الطبيب وسيتم توجيهك لواجهة اختبار خطورة وإلى واجهة الدليل التوعوي';
        } else {
          return 'مريض سكر - من الضروري مراجعة الطبيب';
        }
      default:
        return 'نتيجة غير معروفة';
    }
  }

  Color _getResultColor() {
    String message = _getResultMessage();
    if (message.contains('منخفض')) return Colors.orange;
    if (message.contains('طبيعي')) return Colors.green;
    if (message.contains('مرحلة ما قبل السكري')) return Colors.orange[800]!;
    return secondaryColor;
  }

  @override
  Widget build(BuildContext context) {
    String message = _getResultMessage();
    Color color = _getResultColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'نتيجة الفحص',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _bgAnimation.value ?? backgroundColor,
                  Colors.white,
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Result card with animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: color.withOpacity(0.1),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Icon(
                                  color == Colors.green ? Icons.check_circle : Icons.warning,
                                  color: color,
                                  size: 80,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Tajawal',
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'قيمة الفحص: ${widget.value.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Show records button (for diabetics only)
                    if (widget.isDiabetic)
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () {
                              // Navigate to records screen
                            },
                            child: Text(
                              'عرض السجلات السابقة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 20),

                    // Home button with animation
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightTextColor.withOpacity(0.1),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: lightTextColor.withOpacity(0.3)),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: Text(
                            'العودة إلى الصفحة الرئيسية',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}