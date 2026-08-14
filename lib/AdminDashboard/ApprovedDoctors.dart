import 'package:flutter/material.dart';

import '../screens/DoctorReservation/AppointmentCard.dart';

class ApprovedDoctorsScreen extends StatelessWidget {
  const ApprovedDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This would come from your backend in a real app
    final approvedDoctors = [
      {
        'name': 'Dr. Khalid Hassan',
        'specialization': 'Endocrinologist',
        'hospital': 'King Saud Hospital',
        'email': 'khalid.h@example.com',
        'approvalDate': '2023-05-10',
        'status': 'Active',
      },
      {
        'name': 'Dr. Fatima Al-Rashid',
        'specialization': 'Diabetologist',
        'hospital': 'Al Habib Hospital',
        'email': 'fatima.ar@example.com',
        'approvalDate': '2023-05-12',
        'status': 'Active',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Approved Doctors',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: approvedDoctors.length,
              itemBuilder: (context, index) {
                final doctor = approvedDoctors[index];
                return DoctorCard(doctor: doctor);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorCard({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctor['specialization'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(doctor['status']),
                  backgroundColor: doctor['status'] == 'Active'
                      ? Colors.green[100]
                      : Colors.grey[200],
                  labelStyle: TextStyle(
                    color: doctor['status'] == 'Active'
                        ? Colors.green[800]
                        : Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.medical_services, doctor['hospital']),
            _buildDetailRow(Icons.email, doctor['email']),
            _buildDetailRow(Icons.verified_user, 'Approved on: ${doctor['approvalDate']}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // View details action
                  },
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // Deactivate action
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: secondaryColor,
                    side: BorderSide(color: secondaryColor),
                  ),
                  child: const Text('Deactivate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}