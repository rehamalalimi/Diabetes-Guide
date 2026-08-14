// diabetes_record_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DiabetesRecord {
  final String id;
  final DateTime date;
  final Map<String, dynamic> measurements;
  final DateTime updatedAt;

  DiabetesRecord({
    required this.id,
    required this.date,
    required this.measurements,
    required this.updatedAt,
  });

  factory DiabetesRecord.fromMap(Map<String, dynamic> map) {
    return DiabetesRecord(
      id: map['id'],
      date: (map['date'] as Timestamp).toDate(),
      measurements: Map<String, dynamic>.from(map['measurements']),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'measurements': measurements,
      'updatedAt': updatedAt,
    };
  }
}