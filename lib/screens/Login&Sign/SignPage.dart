import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../Conist.dart';
import 'auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _workHoursController = TextEditingController();

  String? _selectedGender;
  String _selectedRole = 'user';
  bool _isLoading = false;
  bool _obscurePassword = true;

  final AuthService _authService = AuthService();

  // Phone number validator
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }
    if (value.length != 9 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'يجب أن يكون رقم الهاتف 9 أرقام فقط';
    }
    return null;
  }

  // Working hours picker
  Future<void> _selectWorkingHours(BuildContext context) async {
    final List<String> days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    final List<String> selectedDays = [];
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('ساعات العمل', textAlign: TextAlign.right),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('اختر الأيام:', textAlign: TextAlign.right),
                  ...days.map((day) => CheckboxListTile(
                    title: Text(day, textAlign: TextAlign.right),
                    value: selectedDays.contains(day),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
                  const SizedBox(height: 20),
                  const Text('اختر وقت البدء:', textAlign: TextAlign.right),
                  ListTile(
                    title: Text(
                      startTime?.format(context) ?? 'اختر الوقت',
                      textAlign: TextAlign.right,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => startTime = time);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('اختر وقت الانتهاء:', textAlign: TextAlign.right),
                  ListTile(
                    title: Text(
                      endTime?.format(context) ?? 'اختر الوقت',
                      textAlign: TextAlign.right,
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => endTime = time);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDays.isEmpty || startTime == null || endTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء اختيار الأيام والأوقات')),
                    );
                    return;
                  }

                  final hoursText = selectedDays.map((day) =>
                  '$day: ${startTime!.format(context)} - ${endTime!.format(context)}'
                  ).join('\n');

                  _workHoursController.text = hoursText;
                  Navigator.pop(context);
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Medical-themed Header (unchanged)
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [PrimaryColor.withOpacity(0.9), PrimaryColor],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 20,
                    top: 30,
                    child: Icon(Icons.medical_services, size: 60, color: Colors.white.withOpacity(0.2)),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 40,
                    child: Icon(Icons.health_and_safety, size: 50, color: Colors.white.withOpacity(0.2)),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_add_alt_1, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'تسجيل حساب جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ابدأ رحلتك الصحية معنا',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sign Up Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field (unchanged)
                    _buildSectionLabel('الاسم الكامل'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'أدخل اسمك الكامل',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم الكامل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Role Selection (unchanged)
                    _buildSectionLabel('التسجيل كـ'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildRoleOption(
                              'مريض',
                              'user',
                              Icons.person,
                            ),
                          ),
                          Expanded(
                            child: _buildRoleOption(
                              'طبيب',
                              'doctor',
                              Icons.medical_services,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gender Selection (unchanged)
                    _buildSectionLabel('الجنس'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildGenderOption(
                              'أنثى',
                              'Female',
                              Icons.female,
                            ),
                          ),
                          Expanded(
                            child: _buildGenderOption(
                              'ذكر',
                              'Male',
                              Icons.male,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Phone Number Field (updated with validation)
                    _buildSectionLabel('رقم الهاتف'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: 'أدخل رقم الهاتف (9 أرقام)',
                      icon: Icons.phone_iphone,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhoneNumber,
                    ),
                    const SizedBox(height: 20),

                    // Doctor-specific fields
                    if (_selectedRole == 'doctor') ...[
                      _buildSectionLabel('التخصص'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _specializationController,
                        hintText: 'أدخل تخصصك الطبي',
                        icon: Icons.medical_information,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال التخصص الطبي';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildSectionLabel('موقع العيادة'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _locationController,
                        hintText: 'أدخل موقع العيادة',
                        icon: Icons.location_pin,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال موقع العيادة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      _buildSectionLabel('ساعات العمل'),
                      const SizedBox(height: 8),
                      ListTile(
                        title: Text(
                          _workHoursController.text.isEmpty
                              ? 'أدخل ساعات العمل'
                              : _workHoursController.text.split('\n').first,
                          style: TextStyle(
                            color: _workHoursController.text.isEmpty
                                ? Colors.grey.shade500
                                : Colors.black,
                          ),
                        ),
                        trailing: const Icon(Icons.access_time_filled),
                        onTap: () => _selectWorkingHours(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        tileColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Email Field (unchanged)
                    _buildSectionLabel('البريد الإلكتروني'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'أدخل بريدك الإلكتروني',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!value.contains('@')) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password Field (unchanged)
                    _buildSectionLabel('كلمة المرور'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                   //   textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'أدخل كلمة المرور',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.lock_outline, color: PrimaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: PrimaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: PrimaryColor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Sign Up Button (unchanged)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedGender == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء تحديد الجنس'),
                                ),
                              );
                            } else {
                              setState(() => _isLoading = true);
                              try {
                                await _authService.signUpWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  name: _nameController.text.trim(),
                                  gender: _selectedGender!,
                                  role: _selectedRole,
                                  phone: _phoneController.text.trim(),
                                  specialty: _selectedRole == 'doctor'
                                      ? _specializationController.text.trim()
                                      : null,
                                  location: _selectedRole == 'doctor'
                                      ? _locationController.text.trim()
                                      : null,
                                  workingHours: _selectedRole == 'doctor'
                                      ? _workHoursController.text.trim()
                                      : null,
                                );

                                if (_selectedRole == 'doctor') {
                                  Navigator.pushNamed(context, '/doctor_setup');
                                } else {
                                  Navigator.pushNamed(context, '/user_home');
                                }
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = 'فشل إنشاء الحساب';
                                if (e.code == 'weak-password') {
                                  errorMessage = 'كلمة المرور ضعيفة جداً';
                                } else if (e.code == 'email-already-in-use') {
                                  errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
                                } else if (e.code == 'invalid-email') {
                                  errorMessage = 'البريد الإلكتروني غير صالح';
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('خطأ: ${e.toString()}')),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                            Icon(Icons.person_add_alt_1, size: 20,color: Colors.white,),
                            SizedBox(width: 8),
                            Text(
                              'إنشاء حساب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Option (unchanged)
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'لديك حساب بالفعل؟ ',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            fontFamily: 'Tajawal',
                          ),
                          children: [
                            TextSpan(
                              text: 'تسجيل الدخول',
                              style: TextStyle(
                                color: SecondryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods (unchanged)
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: PrimaryColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
    //  textDirection: TextDirection.,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: PrimaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: PrimaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: validator,
    );
  }

  Widget _buildRoleOption(String title, String value, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _selectedRole == value ? PrimaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedRole == value ? PrimaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: _selectedRole == value ? PrimaryColor : Colors.grey),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: _selectedRole == value ? PrimaryColor : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String title, String value, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _selectedGender == value ? PrimaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedGender == value ? PrimaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: _selectedGender == value ? PrimaryColor : Colors.grey),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: _selectedGender == value ? PrimaryColor : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _locationController.dispose();
    _workHoursController.dispose();
    super.dispose();
  }
}

// Add this extension for TimeOfDay formatting
extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext context) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat.jm('ar').format(dt);
  }
}