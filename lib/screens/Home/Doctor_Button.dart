import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../Conist.dart';
import '../DoctorReservation/ReservationScreen.dart';
import '../Login&Sign/auth_wrapper.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EFF1),
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
        title: const Text('لوحة الطبيب', style: TextStyle(color: Colors.white)),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined,color: Colors.white,),
            onPressed:  () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const AuthWrapper());
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick Stats Card
            _buildStatsCard(context),
            const SizedBox(height: 20),

            // Dashboard Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildDashboardItem(
                  context: context,
                  icon: Iconsax.people,
                  title: 'إدارة المرضى',
                  color: Colors.blueAccent,
                  route: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PatientsManagementScreen())
                  ),
                ),
                _buildDashboardItem(
                  context: context,
                  icon: Iconsax.health,
                  title: 'السجلات الطبية',
                  color: Colors.teal,
                  route: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MedicalRecordsScreen())
                  ),
                ),
                _buildDashboardItem(
                  context: context,
                  icon: Iconsax.calendar,
                  title: 'المواعيد',
                  color: const Color(0xffdf3b25),
                  route: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DoctorReservationPage())
                  ),
                ),
                _buildDashboardItem(
                  context: context,
                  icon: Iconsax.chart,
                  title: 'الإحصائيات',
                  color: Colors.purple,
                  route: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatisticsScreen())
                  ),
                ),
                _buildDashboardItem(
                  context: context,
                  icon: Iconsax.note,
                  title: 'الوصفات',
                  color: Colors.orange,
                  route: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrescriptionsScreen())
                  ),
                ),
                _buildDashboardItem(
                  context: context,
                  icon: Iconsax.notification,
                  title: 'الإشعارات',
                  color: Colors.green,
                  route: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen())
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('المواعيد اليوم', '12', const Color(0xff1c6ab1)),
              _buildStatItem('المرضى الجدد', '5', Colors.green),
              _buildStatItem('الوصفات', '8', const Color(0xffdf3b25)),
            ],
          ),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Color(0xFFF1EFF1),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1c6ab1)),
          ),
          const SizedBox(height: 5),
          const Text(
            '70% من المواعيد اليومية مكتملة',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback route,
  }) {
    return InkWell(
      onTap: route,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screens for navigation
class PatientsManagementScreen extends StatelessWidget {
  const PatientsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المرضى')),
      body: const Center(child: Text('قائمة إدارة المرضى')),
    );
  }
}

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السجلات الطبية')),
      body: const Center(child: Text('السجلات الطبية للمرضى')),
    );
  }
}



class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإحصائيات')),
      body: const Center(child: Text('الإحصائيات والتحليلات')),
    );
  }
}

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الوصفات')),
      body: const Center(child: Text('إدارة الوصفات الطبية')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: const Center(child: Text('الإشعارات والتنبيهات')),
    );
  }
}

