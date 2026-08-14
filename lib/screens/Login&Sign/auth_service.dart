import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String role,
    String? specialty,
    String? phone,
    String? workingHours,
    String? location,
  }) async {
    try {
      // 1. Create user account
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Update user display name
      await credential.user?.updateDisplayName(name);

      // 3. Create user document in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'id': credential.user!.uid,
        'email': email,
        'name': name,
        'gender': gender,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 4. If doctor, create doctor profile
      if (role == 'doctor' && specialty != null && phone != null) {
        await _firestore.collection('doctors').doc(credential.user!.uid).set({
          'D_name': 'Dr. $name',
          'D_Phone': phone,
          'specialty': specialty,
          'rating': 0.0,
          'workingHours': workingHours,
          'location': location,
          'D_imageUrl': 'https://example.com/default_doctor.jpg',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return credential.user;
    } catch (e) {
      // If anything fails, delete the user account to maintain consistency
      if (_auth.currentUser != null) {
        await _auth.currentUser!.delete();
      }
      rethrow;
    }
  }
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      String message = 'Authentication failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
      }
      throw FirebaseAuthException(code: e.code, message: message);
    }
  }


  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user data from Firestore
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // Get doctor profile data
  Future<DocumentSnapshot> getDoctorProfile(String uid) async {
    return await _firestore.collection('doctors').doc(uid).get();
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? gender,
    String? email,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (gender != null) updateData['gender'] = gender;
      if (email != null) updateData['email'] = email;

      await _firestore.collection('users').doc(uid).update(updateData);

      // Update auth email if changed
      if (email != null) {
        await _auth.currentUser?.updateEmail(email);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Update failed';
      switch (e.code) {
        case 'requires-recent-login':
          message = 'This operation requires recent authentication. Please log in again.';
          break;
        case 'email-already-in-use':
          message = 'The email address is already in use.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
      }
      throw FirebaseAuthException(code: e.code, message: message);
    }
  }

  // Update doctor profile
  Future<void> updateDoctorProfile({
    required String uid,
    String? name,
    String? phone,
    String? specialty,
    String? workingHours,
    String? location,
  }) async {
    final updateData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (name != null) updateData['D_name'] = 'Dr. $name';
    if (phone != null) updateData['D_Phone'] = phone;
    if (specialty != null) updateData['specialty'] = specialty;
    if (workingHours != null) updateData['workingHours'] = workingHours;
    if (location != null) updateData['location'] = location;

    await _firestore.collection('doctors').doc(uid).update(updateData);
  }
}