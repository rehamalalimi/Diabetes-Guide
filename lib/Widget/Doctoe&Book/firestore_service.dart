import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/doctor_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all doctors with their details
  Stream<List<DoctorModel>> getDoctors() {
    return _firestore.collection('users')
        .where('role', isEqualTo: 'doctor')
        .snapshots()
        .asyncMap((snapshot) async {
      List<DoctorModel> doctors = [];
      for (var userDoc in snapshot.docs) {
        var doctorDoc = await _firestore.collection('doctors').doc(userDoc.id).get();
        if (doctorDoc.exists) {
          doctors.add(DoctorModel.fromCombinedData(
            id: userDoc.id,
            userData: userDoc.data() as Map<String, dynamic>,
            doctorData: doctorDoc.data() as Map<String, dynamic>,
          ));
        }
      }
      return doctors;
    });
  }

  // Get a single doctor by ID
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(doctorId).get();
      final doctorDoc = await _firestore.collection('doctors').doc(doctorId).get();

      if (userDoc.exists && doctorDoc.exists) {
        return DoctorModel.fromCombinedData(
          id: doctorId,
          userData: userDoc.data() as Map<String, dynamic>,
          doctorData: doctorDoc.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch doctor: $e');
    }
  }

  // Book appointment with date and time selection
  Future<void> bookAppointment({
    required String doctorId,
    required String doctorName,
    required DateTime appointmentDate,
    required String patientId,
    required String patientName,
  }) async {
    try {
      await _firestore.collection('appointments').add({
        'doctorId': doctorId,
        'doctorName': doctorName,
        'appointmentDate': appointmentDate,
        'patientId': patientId, // This needs to be the logged-in user's UID
        'patientName': patientName,
        'status': 'pending', // Ensure the status is set to 'pending'
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error booking appointment: $e");
      rethrow;
    }
  }
  Stream<QuerySnapshot> getDoctorAppointments(String doctorId) {
    return _firestore.collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('appointmentDate') // Add this back after index exists
        .snapshots();
  }

  // Get appointments for a specific doctorStream<QuerySnapshot> getDoctorAppointments(String doctorId) {
  //   return _firestore.collection('appointments')
  //       .where('doctorId', isEqualTo: doctorId)
  //       .orderBy('appointmentDate')
  //       .snapshots();
  // }

  // Update appointment status
  // Future<void> updateAppointmentStatus({
  //   required String appointmentId,
  //   required String status,
  //   required String doctorName,
  //   required String patientId,
  //   String? rejectionReason,
  // }) async {
  //   final updateData = {
  //     'status': status,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //
  //   };
  //
  //   if (rejectionReason != null) {
  //     updateData['rejectionReason'] = rejectionReason;
  //   }
  //
  //   await _firestore.collection('appointments').doc(appointmentId).update(updateData);
  // }
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
    String? rejectionReason,
    required String patientId,
    required String doctorName,
  }) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'status': status,
      'rejectionReason': rejectionReason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }


  // Register a new doctor
  Future<void> registerDoctor({
    required String userId,
    required String email,
    required String name,
    required String gender,
    required String dName,
    required String dPhone,
    required String specialty,
    String? imageUrl,
    String? workingHours,
    String? location,
  }) async {
    final batch = _firestore.batch();

    // Create user document
    final userRef = _firestore.collection('users').doc(userId);
    batch.set(userRef, {
      'email': email,
      'name': name,
      'gender': gender,
      'role': 'doctor',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Create doctor profile
    final doctorRef = _firestore.collection('doctors').doc(userId);
    batch.set(doctorRef, {
      'D_name': dName,
      'D_Phone': dPhone,
      'specialty': specialty,
      'rating': 0.0,
      'workingHours': workingHours ?? '9AM-5PM',
      'location': location ?? 'Main Hospital',
      'D_imageUrl': imageUrl ?? 'https://example.com/default_doctor.jpg',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Update doctor profile
  Future<void> updateDoctorProfile({
    required String userId,
    String? dName,
    String? dPhone,
    String? specialty,
    String? workingHours,
    String? location,
    String? imageUrl,
  }) async {
    final updateData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (dName != null) updateData['D_name'] = dName;
    if (dPhone != null) updateData['D_Phone'] = dPhone;
    if (specialty != null) updateData['specialty'] = specialty;
    if (workingHours != null) updateData['workingHours'] = workingHours;
    if (location != null) updateData['location'] = location;
    if (imageUrl != null) updateData['D_imageUrl'] = imageUrl;

    await _firestore.collection('doctors').doc(userId).update(updateData);
  }

  // Get user data
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String appointmentId, {String? reason}) async {
    final updateData = {
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (reason != null) {
      updateData['cancellationReason'] = reason;
    }

    await _firestore.collection('appointments').doc(appointmentId).update(updateData);
  }
}