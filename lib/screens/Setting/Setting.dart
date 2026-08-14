import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/Widget/SettingWidget/Edit_Profile.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color BackgroundColor = Color(0xFFF1EFF1);
const Color PrimaryColor = Color(0xff1c6ab1);
const Color SecondryColor = Color(0xffdf3b25);

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  bool _darkMode = false;
  bool _notifications = true;
  String _selectedLanguage = "English";
  final List<String> _languages = ["English", "العربية"];
  String _userEmail = "Loading...";
  String _userName = "Loading...";
  String? _userPhotoUrl;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadUserData();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: PrimaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool("darkMode") ?? false;
      _notifications = prefs.getBool("notifications") ?? true;
      _selectedLanguage = prefs.getString("language") ?? "English";
    });
  }

  void _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    }
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? "No email";
        _userName = user.displayName ?? "User";
        _userPhotoUrl = user.photoURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Scaffold(
              backgroundColor: BackgroundColor,
              appBar: AppBar(
                title: Text("الإعدادات", style: TextStyle(fontWeight: FontWeight.bold)),
                centerTitle: true,
                toolbarHeight: 80,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                elevation: 0,
                backgroundColor: PrimaryColor,
                foregroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // User Profile Card with medical icon
                    _buildAnimatedCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: _userPhotoUrl != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(_userPhotoUrl!),
                          radius: 20,
                        )
                            : Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: PrimaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, size: 30, color: PrimaryColor),
                        ),
                        title: Text(_userName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(_userEmail),
                        trailing: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SecondryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: SecondryColor),
                        ),
                        onTap: () {
                          Get.to(() => EditProfile());
                        },
                      ),
                      delay: 0,
                    ),

                    SizedBox(height: 20),

                    // Settings Cards
                    _buildAnimatedCard(
                      child: Column(
                        children: [
                          _buildSettingItem(
                            icon: Icons.language,
                            title: "اللغة",
                            trailing: DropdownButton<String>(
                              value: _selectedLanguage,
                              dropdownColor: BackgroundColor,
                              underline: Container(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedLanguage = newValue!;
                                  _savePreference("language", newValue);
                                });
                              },
                              items: _languages.map((lang) {
                                return DropdownMenuItem<String>(
                                  value: lang,
                                  child: Text(lang),
                                );
                              }).toList(),
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey[200]),
                          _buildSettingItem(
                            icon: Icons.dark_mode,
                            title: "الوضع الليلي",
                            trailing: Switch(
                              activeColor: SecondryColor,
                              value: _darkMode,
                              onChanged: (value) {
                                setState(() {
                                  _darkMode = value;
                                  _savePreference("darkMode", value);
                                });
                              },
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey[200]),
                          _buildSettingItem(
                            icon: Icons.notifications,
                            title: "الإشعارات",
                            trailing: Switch(
                              activeColor: SecondryColor,
                              value: _notifications,
                              onChanged: (value) {
                                setState(() {
                                  _notifications = value;
                                  _savePreference("notifications", value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      delay: 100,
                    ),

                    SizedBox(height: 20),

                    // Logout Button
                    _buildAnimatedCard(
                      child: _buildSettingItem(
                        icon: Icons.logout,
                        title: "تسجيل الخروج",
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          // Add navigation logic if needed
                        },
                      ),
                      delay: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required Widget child, int delay = 0}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay / 1000, 1, curve: Curves.easeOut),
        ),
      ),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: PrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: PrimaryColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}