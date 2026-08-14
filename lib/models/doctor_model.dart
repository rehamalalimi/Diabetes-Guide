class DoctorModel {
  final String id;
  final String dName;
  final String dPhone;
  final String specialty;
  final String email;
  final String name;
  final String gender;
  final double rating;
  final String workingHours;
  final String location;
  final String dImageUrl;

  DoctorModel({
    required this.id,
    required this.dName,
    required this.dPhone,
    required this.specialty,
    required this.email,
    required this.name,
    required this.gender,
    required this.rating,
    required this.workingHours,
    required this.location,
    required this.dImageUrl,
  });

  factory DoctorModel.fromCombinedData({
    required String id,
    required Map<String, dynamic> userData,
    required Map<String, dynamic> doctorData,
  }) {
    return DoctorModel(
      id: id,
      dName: doctorData['D_name'] ?? '',
      dPhone: doctorData['D_Phone'] ?? '',
      specialty: doctorData['specialty'] ?? '',
      email: userData['email'] ?? '',
      name: userData['name'] ?? '',
      gender: userData['gender'] ?? '',
      rating: (doctorData['rating'] as num?)?.toDouble() ?? 0.0,
      workingHours: doctorData['workingHours'] ?? '9AM-5PM',
      location: doctorData['location'] ?? 'Main Hospital',
      dImageUrl: doctorData['D_imageUrl'] ?? 'https://example.com/default_doctor.jpg',

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'D_name': dName,
      'D_Phone': dPhone,
      'specialty': specialty,
      'rating': rating,
      'workingHours': workingHours,
      'location': location,
      'D_imageUrl': dImageUrl,
    };
  }
}