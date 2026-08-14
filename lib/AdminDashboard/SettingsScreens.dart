import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/DoctorReservation/AppointmentCard.dart';
import '../screens/Login&Sign/auth_wrapper.dart';

class AdminStatsScreen extends StatelessWidget {
  const AdminStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.analytics, size: 60, color: primaryColor),
          const SizedBox(height: 20),
          const Text(
            'Admin Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Doctors: 24',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          Text(
            'Pending Approvals: 2',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings, size: 60, color: primaryColor),
          const SizedBox(height: 20),
          const Text(
            'Admin Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logout action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
            ),
            child:  TextButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const AuthWrapper());
            }, child: Text("Logout"))
          ),
        ],
      ),
    );
  }
}