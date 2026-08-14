import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Conist.dart';
import '../Login&Sign/LoginPage.dart';
import '../Main/bottom_nav.dart'; // Make sure this import is correct for your BottomNav screen
import '../DoctorReservation/ReservationScreen.dart'; // Import for doctor home screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay for the splash screen
    await Future.delayed(Duration(seconds: 2));

    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in - check their role
      await _redirectBasedOnUserRole(user.uid);
    } else {
      // No user logged in - go to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  Future<void> _redirectBasedOnUserRole(String userId) async {
    try {
      // Get user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final role = userDoc.data()?['role'] ?? 'user';
        
        if (role == 'doctor') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DoctorReservationPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        }
      } else {
        // User document doesn't exist - go to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      // If any error occurs, redirect to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/22.png',
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}