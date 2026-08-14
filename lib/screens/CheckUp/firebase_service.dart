import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل الدخول
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // حفظ بيانات الفحص
  Future<void> saveExaminationData({
    required String userId,
    required String examType,
    required String period,
    required String result,
    String? notes,
  }) async {
    await _firestore.collection('examinations').add({
      'userId': userId,
      'examType': examType,
      'period': period,
      'result': result,
      'notes': notes,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // جلب سجل الفحوصات
  Stream<QuerySnapshot> getExaminations(String userId) {
    return _firestore
        .collection('examinations')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}