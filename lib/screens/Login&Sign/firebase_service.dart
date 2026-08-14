import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/doctor_model.dart';

class FirebaseService {
  // Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialization
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // ========== AUTHENTICATION METHODS ========== //

  static Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Sign in error: ${e.message}");
      return null;
    }
  }

  static User? get currentUser => _auth.currentUser;

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // ========== DIABETES TRACKING METHODS ========== //

  static Future<void> saveDiabetesMeasurement({
    required String userId,
    required DateTime date,
    required Map<String, dynamic> measurements,
  }) async {
    try {
      if (userId.isEmpty) throw 'User not authenticated';

      final formattedDate = _formatDate(date);

      await _firestore
          .collection('diabetes_tracker')
          .doc(userId)
          .collection('records')
          .doc(formattedDate)
          .set({
        'date': date,
        'measurements': measurements,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving measurement: $e');
      throw 'Failed to save data: $e';
    }
  }

  static Future<List<Map<String, dynamic>>> getDiabetesTrackerRecords(
      String userId, {
        DateTime? startDate,
        DateTime? endDate,
      }) async {
    try {
      Query query = _firestore
          .collection('diabetes_tracker')
          .doc(userId)
          .collection('records')
          .orderBy('date', descending: true);

      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'date': (data['date'] as Timestamp).toDate(),
          'measurements': Map<String, dynamic>.from(data['measurements'] as Map),
          'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
        };
      }).toList();
    } catch (e) {
      print('Error getting records: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getDiabetesRecordForDate(
      String userId,
      DateTime date,
      ) async {
    try {
      final doc = await _firestore
          .collection('diabetes_tracker')
          .doc(userId)
          .collection('records')
          .doc(_formatDate(date))
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'date': (data['date'] as Timestamp).toDate(),
        'measurements': Map<String, dynamic>.from(data['measurements'] as Map),
        'updatedAt': (data['updatedAt'] as Timestamp).toDate(),
      };
    } catch (e) {
      print('Error getting record: $e');
      return null;
    }
  }

  // ========== HELPER METHODS ========== //

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // ========== USER DATA METHODS ========== //

  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Additional method to delete a record
  static Future<void> deleteDiabetesRecord(String userId, String recordId) async {
    try {
      await _firestore
          .collection('diabetes_tracker')
          .doc(userId)
          .collection('records')
          .doc(recordId)
          .delete();
    } catch (e) {
      print('Error deleting record: $e');
      throw 'Failed to delete record: $e';
    }
  }
}