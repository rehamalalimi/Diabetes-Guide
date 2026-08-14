import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../Conist.dart';
import '../DoctorReservation/AppointmentCard.dart';
import 'input_screen.dart';

class FastingOptionsScreen extends StatefulWidget {
  final bool isDiabetic;

  const FastingOptionsScreen({Key? key, required this.isDiabetic}) : super(key: key);

  @override
  _FastingOptionsScreenState createState() => _FastingOptionsScreenState();
}

class _FastingOptionsScreenState extends State<FastingOptionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _optionsAnimation;
  late Animation<Color?> _bgAnimation;


  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF666666);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _optionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
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
        backgroundColor: PrimaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'اختبار سكر الدم',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with animation
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _titleAnimation.value)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'نوع الصيام',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              fontFamily: 'Tajawal',
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'اختر طريقة الصيام المناسبة لك',
                            style: TextStyle(
                              fontSize: 16,
                              color: lightTextColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Options with animation
                  ScaleTransition(
                    scale: _optionsAnimation,
                    child: FadeTransition(
                      opacity: _optionsAnimation,
                      child: Column(
                        children: [
                          _buildFastingOption(
                            title: "صيام 8 ساعات",
                            subtitle: "بدون أكل أو شرب (عدا الماء)",
                            icon: Icons.access_time,
                            color: primaryColor,
                            delay: 0.0,
                            onTap: () => _navigateToInputScreen(context, '8-hours'),
                          ),
                          SizedBox(height: 16),
                          _buildFastingOption(
                            title: "بعد الأكل بساعتين",
                            subtitle: "قياس مستوى السكر بعد الوجبة",
                            icon: Icons.restaurant,
                            color: secondaryColor,
                            delay: 0.2,
                            onTap: () => _navigateToInputScreen(context, '2-hours'),
                          ),
                          SizedBox(height: 16),
                          _buildFastingOption(
                            title: "فحص تراكمي",
                            subtitle: "قياس معدل السكر التراكمي",
                            icon: Icons.timeline,
                            color: primaryColor,
                            delay: 0.4,
                            onTap: () => _navigateToInputScreen(context, 'cumulative'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFastingOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double delay,
    required VoidCallback onTap,
  }) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay, 1.0, curve: Curves.easeOutQuart),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: Opacity(
              opacity: animation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1 * animation.value),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: lightTextColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_left,
                      color: lightTextColor,
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

  Future<void> _navigateToInputScreen(BuildContext context, String testType) async {
    await _controller.reverse();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => InputScreen(
          isDiabetic: widget.isDiabetic,
          testType: testType,
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
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
    if (mounted) {
      _controller.forward();
    }
  }
}