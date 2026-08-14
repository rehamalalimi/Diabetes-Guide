import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Conist.dart';
import 'SignPage.dart';
import 'auth_service.dart';
import 'dart:io';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();


  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Animated Header
            _buildAnimatedHeader(size),
            // Animated Form
            _buildAnimatedForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(Size size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _fadeAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              height: size.height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    PrimaryColor.withOpacity(0.9),
                    PrimaryColor,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60 * _scaleAnimation.value),
                  bottomRight: Radius.circular(60 * _scaleAnimation.value),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1 * _fadeAnimation.value),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Pulse animation for medical icons
                  Positioned(
                    right: 30,
                    top: 40,
                    child: ScaleTransition(
                      scale: _controller.drive(
                        TweenSequence([
                          TweenSequenceItem(
                            tween: Tween(begin: 0.5, end: 1.2),
                            weight: 50,
                          ),
                          TweenSequenceItem(
                            tween: Tween(begin: 1.2, end: 1.0),
                            weight: 50,
                          ),
                        ]),
                      ),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Icon(
                          Icons.medical_services,
                          size: 70,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    bottom: 50,
                    child: ScaleTransition(
                      scale: _controller.drive(
                        TweenSequence([
                          TweenSequenceItem(
                            tween: Tween(begin: 0.5, end: 1.2),
                            weight: 50,
                          ),
                          TweenSequenceItem(
                            tween: Tween(begin: 1.2, end: 1.0),
                            weight: 50,
                          ),
                        ]),
                      ),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Icon(
                          Icons.health_and_safety,
                          size: 60,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2 * _fadeAnimation.value),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.login_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            'مرحباً بعودتك',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'سجل الدخول لاستئناف رحلتك الصحية',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
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
      },
    );
  }

  Widget _buildAnimatedForm() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05 * _fadeAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bouncing login title
                      _buildLoginTitle(),
                      const SizedBox(height: 25),
                      // Email field
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      // Password field
                      _buildPasswordField(),
                      const SizedBox(height: 10),
                      // Forgot password
                      _buildForgotPassword(),
                      const SizedBox(height: 20),
                      // Login button
                      _buildLoginButton(),
                      const SizedBox(height: 25),
                      // Divider
                      _buildDivider(),
                      const SizedBox(height: 25),
                      // Sign up prompt
                      _buildSignUpPrompt(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginTitle() {
    return ScaleTransition(
      scale: _controller.drive(
        TweenSequence([
          TweenSequenceItem(
            tween: Tween(begin: 0.8, end: 1.1),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 1.1, end: 1.0),
            weight: 50,
          ),
        ]),
      ),
      child: Center(
        child: Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: PrimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'كلمة المرور',
            labelStyle: TextStyle(
              color: Colors.grey.shade600,
              fontFamily: 'Tajawal',
            ),
            prefixIcon: Icon(Icons.lock_outline, color: PrimaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: PrimaryColor,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            filled: true,
            fillColor: BackgroundColor.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: PrimaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () => _showResetPasswordDialog(context),
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              color: SecondryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ScaleTransition(
      scale: _controller.drive(
        TweenSequence([
          TweenSequenceItem(
            tween: Tween(begin: 0.95, end: 1.05),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 1.05, end: 1.0),
            weight: 50,
          ),
        ]),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: PrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              shadowColor: PrimaryColor.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login, size: 22,color: Colors.white,),
                SizedBox(width: 10),
                Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'أو',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'ليس لديك حساب؟ ',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontFamily: 'Tajawal',
            ),
            children: [
              TextSpan(
                text: 'إنشاء حساب جديد',
                style: TextStyle(
                  color: SecondryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.to(() => const SignUpScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontFamily: 'Tajawal',
        ),
        prefixIcon: Icon(icon, color: PrimaryColor),
        filled: true,
        fillColor: BackgroundColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: PrimaryColor,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Check internet connection
    final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      _showErrorSnackbar('لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك');
      return;
    }

    // Validate email
    if (_emailController.text.isEmpty) {
      _showErrorSnackbar('الرجاء إدخال البريد الإلكتروني');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      _showErrorSnackbar('الرجاء إدخال بريد إلكتروني صحيح');
      return;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      _showErrorSnackbar('الرجاء إدخال كلمة المرور');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackbar('يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        final role = userData.get('role') ?? 'user';
        if (role == 'doctor') {
          Navigator.pushNamed(context, '/doctor_home');
        } else {
          Navigator.pushNamed(context, '/user_home');
        }
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      _showErrorSnackbar('حدث خطأ غير متوقع: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'لا يوجد مستخدم بهذا البريد الإلكتروني';
        break;
      case 'wrong-password':
        message = 'كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى';
        break;
      case 'invalid-email':
        message = 'البريد الإلكتروني غير صالح';
        break;
      case 'user-disabled':
        message = 'هذا الحساب معطل. يرجى التواصل مع الدعم';
        break;
      case 'too-many-requests':
        message = 'تم تجاوز عدد المحاولات المسموح بها. يرجى المحاولة لاحقاً';
        break;
      case 'network-request-failed':
        message = 'فشل في الاتصال بالشبكة. يرجى التحقق من اتصال الإنترنت';
        break;
      default:
        message = 'فشل تسجيل الدخول: ${e.message ?? e.code}';
    }
    _showErrorSnackbar(message);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: SecondryColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إعادة تعيين كلمة المرور',
                style: TextStyle(
                  color: PrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Tajawal',
                  ),
                  prefixIcon: Icon(Icons.email, color: PrimaryColor),
                  filled: true,
                  fillColor: BackgroundColor.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: PrimaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty) {
                        _showErrorSnackbar('الرجاء إدخال البريد الإلكتروني');
                        return;
                      }

                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
                        _showErrorSnackbar('الرجاء إدخال بريد إلكتروني صحيح');
                        return;
                      }

                      final hasConnection = await _checkInternetConnection();
                      if (!hasConnection) {
                        _showErrorSnackbar('لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك');
                        return;
                      }

                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: emailController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
                              style: const TextStyle(fontFamily: 'Tajawal'),
                            ),
                            backgroundColor: PrimaryColor,
                          ),
                        );
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        _handleFirebaseAuthError(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SecondryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إرسال',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}