import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_project/screens/Home/Doctor_Button.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_project/screens/SplashScreen/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'screens/Login&Sign/LoginPage.dart';
import 'screens/Login&Sign/SignPage.dart';
import 'Widget/Doctoe&Book/firestore_service.dart';
import 'Widget/HomeWidget/bottom_nav.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'دليل السكر',

      locale: const Locale('ar'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(fontFamily: 'Cairo'),
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUpScreen(),
        '/user_home': (context) =>  BottomNav(),
        '/doctor_home': (context) => const DoctorDashboard(),
      },
      // Add this as fallback for any undefined routes
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) =>  SplashScreen(),
      ),
    );
  }
}