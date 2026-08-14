import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_service.dart';

class HealthExaminationScreen extends StatefulWidget {
  @override
  _HealthExaminationScreenState createState() => _HealthExaminationScreenState();
}

class _HealthExaminationScreenState extends State<HealthExaminationScreen>
    with SingleTickerProviderStateMixin {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseService _firebaseService = FirebaseService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Colors
  static const Color backgroundColor = Color(0xFFF1EFF1);
  static const Color primaryColor = Color(0xff1c6ab1);
  static const Color secondaryColor = Color(0xffdf3b25);
  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF666666);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA000);

  // State variables
  String? selectedExaminationType;
  String? selectedPeriod;
  bool showResultOptions = false;
  bool showFinalResult = false;
  String finalResultMessage = '';

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _bgAnimation;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'examination_channel',
      'فحوصات دورية',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'تنبيه فحص دوري',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _handleExaminationSelection(String type) {
    setState(() {
      selectedExaminationType = type;
      selectedPeriod = null;
      showResultOptions = false;
      showFinalResult = false;
    });
  }

  void _handlePeriodSelection(String period) {
    setState(() {
      selectedPeriod = period;

      if (selectedExaminationType == 'التراكمي') {
        showResultOptions = false;
        showFinalResult = true;

        switch (period) {
          case 'أقل من 3 أشهر':
            finalResultMessage = 'تم تفعيل التنبيه للفحص بعد 3 اشهر';
            _showNotification('تنبيه: يجب عمل فحص التراكمي (بعد 3 أشهر)');
            break;
          case '3 أشهر':
            finalResultMessage = 'حان وقت فحص التراكمي';
            _showNotification('حان وقت الفحص التراكمي');
            break;
          case '6 أشهر':
            finalResultMessage = 'حان وقت فحص التراكمي';
            _showNotification('حان وقت الفحص التراكمي');
            break;
          case 'سنة':
            finalResultMessage = 'حان وقت فحص التراكمي';
            _showNotification('حان وقت الفحص التراكمي');
            break;
          case 'لم أقم':
            finalResultMessage = 'تم تفعيل التنبيهات - يرجى عمل الفحص حالاً';
            _showNotification('يجب عمل فحص التراكمي حالاً');
            break;
        }
      }
      else if (selectedExaminationType == 'الكلى' && period == 'لم أقم') {
        showResultOptions = false;
        showFinalResult = true;
        finalResultMessage = 'يجب عمل الفحوصات التالية:\n- الكرياتين\n- اليوريا\n- تحليل البول';
        _showNotification('يجب عمل فحوصات الكلى (الكرياتين، اليوريا، البول) حالاً');
      }
      else if (selectedExaminationType == 'الدهون' && period == 'لم أقم') {
        showResultOptions = false;
        showFinalResult = true;
        finalResultMessage = 'يجب عمل الفحوصات التالية:\n- الكوليسترول الكلي\n- الدهون الثلاثية\n- LDL\n- HDL';
        _showNotification('يجب عمل فحوصات الدهون (الكوليسترول، الدهون الثلاثية) حالاً');
      }
      else if (selectedExaminationType == 'الشبكية' && period == 'لم أقم') {
        showResultOptions = false;
        showFinalResult = true;
        finalResultMessage = 'تم تفعيل التنبيهات - يرجى عمل الفحص حالاً';
        _showNotification('يجب عمل فحص التراكمي حالاً');
      }
      else {
        showResultOptions = true;
        showFinalResult = false;
      }
    });
  }

  void _handleResultSelection(String result) async {
    setState(() {
      showFinalResult = true;
      showResultOptions = false;
    });

    String message = '';

    if (result == 'طبيعي') {
      finalResultMessage = 'بناءً على اختيارك ($selectedPeriod) والنتيجة الطبيعية:\n'
          'يجب عليك عمل الفحص سنوياً أو كما يقول لك الطبيب المعالج';
      message = 'بناءً على اختيارك ($selectedPeriod) والنتيجة الطبيعية:\n'
          'يجب عليك عمل الفحص سنوياً أو كما يقول لك الطبيب المعالج';
    } else {
      finalResultMessage = 'بناءً على اختيارك ($selectedPeriod) والنتيجة غير الطبيعية:\n'
          'يجب عليك إعادة الفحوصات بعد 3 أشهر أو كما يقول لك الطبيب المعالج';
      message = 'بناءً على اختيارك ($selectedPeriod) والنتيجة غير الطبيعية:\n'
          'يجب عليك إعادة الفحوصات بعد 3 أشهر أو كما يقول لك الطبيب المعالج';
    }

    if (result == 'غير طبيعي') {
      String notificationMsg = 'يجب إعادة فحص $selectedExaminationType بعد 3 أشهر';
      if (selectedExaminationType == 'الكلى') {
        notificationMsg += '\n(الكرياتين، اليوريا، البول)';
      } else if (selectedExaminationType == 'الدهون') {
        notificationMsg += '\n(الكوليسترول، الدهون الثلاثية)';
      }
      _showNotification(notificationMsg);
    }

    // Save data to Firebase
    await _firebaseService.saveExaminationData(
      userId: _currentUser!.uid,
      examType: selectedExaminationType!,
      period: selectedPeriod!,
      result: result,
      notes: message,
    );

    setState(() {
      finalResultMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('الفحوصات الدورية',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            )),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ), // Closing parenthesis for AppBar
      body: AnimatedBuilder( // body parameter now correctly in Scaffold
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (selectedExaminationType == null) ...[
                    _buildExaminationTypeSelection(),
                  ] else ...[
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedExaminationType = null;
                              selectedPeriod = null;
                              showResultOptions = false;
                              showFinalResult = false;
                            });
                          },
                          child: Text('← رجوع',
                              style: TextStyle(color: primaryColor)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'نوع الفحص: $selectedExaminationType',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: textColor,
                                  fontFamily: 'Tajawal',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!showResultOptions && !showFinalResult)
                      _buildPeriodSelection(),
                    if (showResultOptions)
                      _buildResultSelection(),
                    if (showFinalResult)
                      _buildFinalResult(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExaminationTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeTransition(
          opacity: _opacityAnimation,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _opacityAnimation.value)),
            child: Text(
              'اختر نوع الفحص:',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: textColor,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 30),
        _buildExaminationButton('فحص التراكمي (الهيموجلوبين A1C)', Icons.bloodtype),
        const SizedBox(height: 16),
        _buildExaminationButton('فحص الكلى', Icons.healing),
        const SizedBox(height: 16),
        _buildExaminationButton('فحص الشبكية', Icons.remove_red_eye),
        const SizedBox(height: 16),
        _buildExaminationButton('فحص الدهون', Icons.monitor_heart),
      ],
    );
  }

  Widget _buildExaminationButton(String text, IconData icon) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ElevatedButton(
          onPressed: () => _handleExaminationSelection(text.split(' ')[1]),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontFamily: 'Tajawal',
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelection() {
    List<String> periods = [];

    if (selectedExaminationType == 'التراكمي') {
      periods = ['أقل من 3 أشهر', '3 أشهر', '6 أشهر', 'سنة', 'لم أقم'];
    } else if (selectedExaminationType == 'الكلى' ||
        selectedExaminationType == 'الدهون') {
      periods = ['أقل من 6 أشهر', '6 أشهر', 'سنة', 'لم أقم'];
    } else if (selectedExaminationType == 'الشبكية') {
      periods = ['أقل من 6 أشهر', '6 أشهر', 'سنة', 'لم أقم'];
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'متى اخر مره فعلت الفحص ؟',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: textColor,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...periods.map((period) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                onPressed: () => _handlePeriodSelection(period),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(period,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                      )),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: period == 'لم أقم' ? secondaryColor : primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSelection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ماذا قال لك الطبيب ؟',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: textColor,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _handleResultSelection('طبيعي'),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('طبيعي',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                    )),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: successColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _handleResultSelection('غير طبيعي'),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('غير طبيعي',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                    )),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    bool isWarning = selectedExaminationType == 'التراكمي' && selectedPeriod == 'لم أقم';
    bool isNormalResult = selectedExaminationType != 'التراكمي' &&
        finalResultMessage.contains('طبيعي');

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isWarning
                      ? warningColor.withOpacity(0.1)
                      : isNormalResult
                      ? successColor.withOpacity(0.1)
                      : secondaryColor.withOpacity(0.1),
                  isWarning
                      ? warningColor.withOpacity(0.2)
                      : isNormalResult
                      ? successColor.withOpacity(0.2)
                      : secondaryColor.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    isWarning
                        ? Icons.warning_amber_rounded
                        : isNormalResult
                        ? Icons.check_circle
                        : Icons.error,
                    size: 60,
                    color: isWarning
                        ? warningColor
                        : isNormalResult
                        ? successColor
                        : secondaryColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    finalResultMessage,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedExaminationType = null;
                        selectedPeriod = null;
                        showResultOptions = false;
                        showFinalResult = false;
                      });
                    },
                    child: Text('حسناً',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontFamily: 'Tajawal',
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
  }
}