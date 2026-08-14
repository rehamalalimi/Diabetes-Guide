import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../Conist.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  final bool isDiabetic;
  final String testType;

  const InputScreen({Key? key, required this.isDiabetic, required this.testType}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _bgAnimation;

  static const Color backgroundColor = Color(0xFFF1EFF1);
  static const Color primaryColor = Color(0xff1c6ab1);
  static const Color secondaryColor = Color(0xffdf3b25);
  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF666666);

  String _testName = '';

  @override
  void initState() {
    super.initState();

    switch (widget.testType) {
      case '8-hours':
        _testName = 'فحص الصيام (8 ساعات)';
        break;
      case '2-hours':
        _testName = 'فحص بعد الأكل (ساعتين)';
        break;
      case 'cumulative':
        _testName = 'فحص السكر التراكمي';
        break;
    }

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.easeOutBack),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          _testName,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 80.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        backgroundColor: PrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title with animation
                        FadeTransition(
                          opacity: _opacityAnimation,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - _opacityAnimation.value)),
                            child: Column(
                              children: [
                                Text(
                                  'أدخل نتيجة الفحص',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                    fontFamily: 'Tajawal',
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'الرجاء إدخال قيمة السكر في الدم',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: lightTextColor,
                                    fontFamily: 'Tajawal',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

                        // Input field with animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.bloodtype,
                                      color: primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _valueController,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'قيمة السكر (mg/dL)',
                                        labelStyle: TextStyle(
                                          color: lightTextColor,
                                          fontFamily: 'Tajawal',
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'أدخل القيمة هنا',
                                        hintStyle: TextStyle(
                                          color: lightTextColor.withOpacity(0.6),
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: textColor,
                                        fontFamily: 'Tajawal',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال قيمة الفحص';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'الرجاء إدخال رقم صحيح';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),

                        // Submit button with animation
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                                shadowColor: primaryColor.withOpacity(0.3),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  double value = double.parse(_valueController.text);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          ResultScreen(
                                            isDiabetic: widget.isDiabetic,
                                            testType: widget.testType,
                                            value: value,
                                          ),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(0.0, 0.1);
                                        const end = Offset.zero;
                                        const curve = Curves.easeOutQuart;
                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          ),
                                        );
                                      },
                                      transitionDuration: Duration(milliseconds: 600),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'تحليل النتيجة',
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
                      ],
                    ),
                  ),
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
    _valueController.dispose();
    super.dispose();
  }
}