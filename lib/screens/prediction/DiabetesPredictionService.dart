import 'dart:convert';
import 'package:http/http.dart' as http;

class DiabetesPredictionService {
  // static const String baseUrl = 'http://10.0.2.2:5000'; // For emulator
  static const String baseUrl = 'http://192.168.8.249:5000'; // For emulator
  // static const String baseUrl = 'http://localhost:5000'; // For physical device on same network

  Future<Map<String, dynamic>> predictDiabetes(List<double> features) async {
    final url = Uri.parse('$baseUrl/predict');
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'features': features}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}