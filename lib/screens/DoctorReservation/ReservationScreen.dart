import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_firebase_project/Widget/Doctoe&Book/firestore_service.dart';
import 'package:provider/provider.dart';

class DoctorReservationPage extends StatefulWidget {
  const DoctorReservationPage({super.key});

  @override
  _DoctorReservationPageState createState() => _DoctorReservationPageState();
}

class _DoctorReservationPageState extends State<DoctorReservationPage> with SingleTickerProviderStateMixin {
  late Stream<QuerySnapshot> _appointmentsStream;
  late final FirestoreService _firestoreService;
  final user = FirebaseAuth.instance.currentUser;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _firestoreService = Provider.of<FirestoreService>(context, listen: false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _updateAppointmentsStream();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAppointmentsStream() {
    if (user != null) {
      setState(() {
        _appointmentsStream = _firestoreService.getDoctorAppointments(user!.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EFF1),
      appBar: AppBar(
        title: const Text("مواعيد الطبيب", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff1c6ab1),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updateAppointmentsStream,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: user == null
            ? const Center(
          child: Text('الرجاء تسجيل الدخول لعرض المواعيد',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        )
            : StreamBuilder<QuerySnapshot>(
          stream: _appointmentsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('حدث خطأ: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1c6ab1)),
                ),
              );
            }

            final appointments = snapshot.data!.docs;

            if (appointments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('لا توجد مواعيد بعد',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              // In ReservationScreen.dart, update the itemBuilder in ListView.builder:
              // In the ListView.builder's itemBuilder:
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                final data = appointment.data() as Map<String, dynamic>;

                return _buildAppointmentCard(
                  context,
                  appointmentId: appointment.id,
                  doctorName: data['doctorName'] ?? 'غير معروف',
                  patientName: data['patientName'] ?? 'مريض',  // Show patient name
                  date: DateFormat.yMMMd('ar').format(
                      (data['appointmentDate'] as Timestamp).toDate()
                  ),
                  time: DateFormat.jm('ar').format(
                      (data['appointmentDate'] as Timestamp).toDate()
                  ),
                  status: data['status'] ?? 'pending',
                  onAccept: () => updateAppointmentStatus(appointment.id, 'confirmed'),
                  onReject: () => _showRejectionDialog(context, appointment.id),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, {
        required String appointmentId,
        required String doctorName,
        required String patientName,
        required String date,
        required String time,
        required String status,
        required VoidCallback onAccept,
        required VoidCallback onReject,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'مريض: $patientName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1c6ab1),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(status),
                      style: TextStyle(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.calendar_today, 'التاريخ: $date'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.access_time, 'الوقت: $time'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.person, 'الطبيب: $doctorName'),
              const SizedBox(height: 16),
              if (status == 'pending')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: const Color(0xffdf3b25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: onReject,
                      child: const Text('رفض'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1c6ab1).withOpacity(0.1),
                        foregroundColor: const Color(0xff1c6ab1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: onAccept,
                      child: const Text('قبول'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'rejected':
        return const Color(0xffdf3b25);
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'مؤكد';
      case 'rejected':
        return 'مرفوض';
      case 'pending':
        return 'قيد الانتظار';
      default:
        return status;
    }
  }

  Future<void> createAppointment(Map<String, dynamic> data) async {
    final requiredFields = [
      'userId', 'patientId', 'patientName',
      'doctorId', 'doctorName', 'appointmentDate'
    ];

    final missingFields = requiredFields.where((field) =>
    data[field] == null).toList();

    if (missingFields.isNotEmpty) {
      throw Exception('Missing required fields: ${missingFields.join(', ')}');
    }

    await FirebaseFirestore.instance.collection('appointments').add({
      ...data,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  Future<void> migrateAppointments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data['doctorId'] == null || data['patientId'] == null) {
        // Update with default values or delete invalid records
        batch.update(doc.reference, {
          'status': 'pending',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
  }

  // In ReservationScreen.dart - update the updateAppointmentStatus method
  // Future<void> updateAppointmentStatus(
  //     String appointmentId,
  //     String newStatus, {
  //       String? rejectionReason, // Add this optional parameter
  //     }) async {
  //   try {
  //     await _firestoreService.updateAppointmentStatus(
  //       appointmentId: appointmentId,
  //       status: newStatus == 'confirmed' ? 'approved' : 'rejected',
  //       rejectionReason: rejectionReason, patientId: '', doctorName: '',
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(newStatus == 'confirmed'
  //             ? 'تم قبول الموعد بنجاح'
  //             : 'تم رفض الموعد بنجاح'),
  //         backgroundColor: newStatus == 'confirmed' ? Colors.green : Colors.red,
  //       ),
  //     );
  //
  //     _updateAppointmentsStream();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('فشل التحديث: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> updateAppointmentStatus(
      String appointmentId,
      String newStatus, {
        String? rejectionReason,
      }) async {
    try {
      // Get the appointment data first
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!appointmentDoc.exists) {
        throw Exception('Appointment not found');
      }

      final appointmentData = appointmentDoc.data() as Map<String, dynamic>;
      final patientId = appointmentData['patientId'];
      final patientName = appointmentData['patientName'];
      final doctorName = appointmentData['doctorName'];
      final appointmentDate = appointmentData['appointmentDate'] as Timestamp;

      // Update the appointment status
      await _firestoreService.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: newStatus == 'confirmed' ? 'approved' : 'rejected',
        rejectionReason: rejectionReason,
        patientId: patientId,
        doctorName: doctorName,
      );

      // Create a notification for the user
      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'userId': patientId,
        'title': 'حالة الموعد الطبي',
        'body': newStatus == 'confirmed'
            ? 'تم قبول موعدك مع د. $doctorName'
            : 'تم رفض موعدك مع د. $doctorName ${rejectionReason != null ? '($rejectionReason)' : ''}',
        'type': 'appointment_status',
        'appointmentId': appointmentId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus == 'confirmed'
              ? 'تم قبول الموعد بنجاح وإرسال الإشعار للمريض'
              : 'تم رفض الموعد بنجاح وإرسال الإشعار للمريض'),
          backgroundColor: newStatus == 'confirmed' ? Colors.green : Colors.red,
        ),
      );

      _updateAppointmentsStream();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل التحديث: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
// Update the _showRejectionDialog to use the new parameter
  void _showRejectionDialog(BuildContext context, String appointmentId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('سبب الرفض'),
            content: TextField(
              controller: reasonController,
              decoration: const InputDecoration(hintText: 'أدخل سبب الرفض'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (reasonController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء إدخال سبب الرفض')),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  await updateAppointmentStatus(
                    appointmentId,
                    'rejected',
                    rejectionReason: reasonController.text,
                  );
                },
                child: const Text('تأكيد الرفض'),
              ),
            ],
          ),
    );
  }
  }