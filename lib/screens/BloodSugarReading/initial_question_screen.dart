import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../DoctorReservation/AppointmentCard.dart';
import 'fasting_options_screen.dart';

class InitialQuestionScreen extends StatefulWidget {
  @override
  _InitialQuestionScreenState createState() => _InitialQuestionScreenState();
}

class _InitialQuestionScreenState extends State<InitialQuestionScreen>
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
      duration: Duration(milliseconds: 1200),
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with animation
                  FadeTransition(
                    opacity: _titleAnimation,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _titleAnimation.value)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 60),
                          Text(
                            'حالتك مع السكري',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'اختر الإجابة التي تصف حالتك الصحية',
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

                  Spacer(),

                  // Options with animation
                  ScaleTransition(
                    scale: _optionsAnimation,
                    child: FadeTransition(
                      opacity: _optionsAnimation,
                      child: Column(
                        children: [
                          _buildOptionCard(
                            title: "مريض سكري",
                            subtitle: "لدي تشخيص طبي بمرض السكري",
                            icon: Icons.medical_services,
                            color: secondaryColor,
                            delay: 0.0,
                            onTap: () => _navigateToFastingOptions(context, true),
                          ),
                          SizedBox(height: 20),
                          _buildOptionCard(
                            title: "غير مريض",
                            subtitle: "ليس لدي تشخيص بمرض السكري",
                            icon: Icons.health_and_safety,
                            color: primaryColor,
                            delay: 0.2,
                            onTap: () => _navigateToFastingOptions(context, false),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Spacer(flex: 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionCard({
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
            offset: Offset(0, 40 * (1 - animation.value)),
            child: Opacity(
              opacity: animation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1 * animation.value),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 26,
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
                              fontWeight: FontWeight.w700,
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
                      size: 28,
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

  Future<void> _navigateToFastingOptions(BuildContext context, bool isDiabetic) async {
    await _controller.reverse();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FastingOptionsScreen(isDiabetic: isDiabetic),
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
    if (mounted) {
      _controller.forward();
    }
  }
}