import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../Screens/Login&Sign/auth_service.dart';
import '../../screens/Login&Sign/auth_wrapper.dart';
import '../../screens/Setting/Setting.dart';

class DrawerClass extends StatefulWidget {
  const DrawerClass({super.key});

  @override
  State<DrawerClass> createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {
  Map<String, dynamic>? userData;
  final AuthService _authService = AuthService();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final data = await _authService.getUserData(user.uid);
      setState(() {
        userData = data as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerItems = [
      {
        'icon': Icons.home_filled,
        'text': "الرئيسية",
        'onTap': () => Navigator.pop(context)
      },
      // {
      //   'icon': Icons.monitor_heart_outlined,
      //   'text': "تتبع السكر",
      //   'onTap': () {}
      // },
      // {
      //   'icon': Icons.medical_services_outlined,
      //   'text': "الأدوية",
      //   'onTap': () {}
      // },
      // {
      //   'icon': Icons.restaurant_outlined,
      //   'text': "النظام الغذائي",
      //   'onTap': () {}
      // },
      // {
      //   'icon': Icons.fitness_center_outlined,
      //   'text': "التمارين الرياضية",
      //   'onTap': () {}
      // },
      // {
      //   'icon': Icons.assignment_outlined,
      //   'text': "التقارير",
      //   'onTap': () {}
      // },
      {
        'icon': Icons.settings_outlined,
        'text': "الإعدادات",
        'onTap': () {
          Get.to(() => SettingsPage());
        }
      },
      {
        'icon': Icons.help_outline,
        'text': "المساعدة",
        'onTap': () {}
      },
      {
        'icon': Icons.exit_to_app,
        'text': "تسجيل الخروج",
        'color': SecondryColor,
        'onTap': () async {
          await FirebaseAuth.instance.signOut();
          Get.offAll(() => const AuthWrapper());
        }
      },
    ];

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: BackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with medical theme
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: PrimaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/medical_pattern.png"), // Add a subtle medical pattern
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: Icon(
                    Icons.medical_services,
                    size: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          Icons.person_outline,
                          size: 30,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(duration: 500.ms).scale(),
                      SizedBox(height: 15),
                      Text(
                        userData?['name'] ?? "مرحبًا بك",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().slideX(begin: 0.5, duration: 500.ms),
                      Text(
                        userData?['email'] ?? "",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ).animate().slideX(begin: 0.5, duration: 600.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: drawerItems.map((item) {
                return MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: item['onTap'],
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _isHovered ? Colors.white.withOpacity(0.2) : Colors.transparent,
                          ),
                          child: ListTile(
                            leading: Icon(
                              item['icon'],
                              color: item['color'] ?? PrimaryColor,
                            ),
                            title: Text(
                              item['text'],
                              style: TextStyle(
                                color: item['color'] ?? Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (drawerItems.indexOf(item) * 100).ms),
                  ),
                );
              }).toList(),
            ),
          ),

          // Footer with app version
          // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: Text(
          //     "دليل السكر - v1.0.0",
          //     style: TextStyle(
          //       color: Colors.grey[600],
          //       fontSize: 12,
          //     ),
          //   ).animate().fadeIn(delay: 800.ms),
          // ),
        ],
      ),
    );
  }
}