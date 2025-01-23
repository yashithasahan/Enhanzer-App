import 'dart:convert';
import 'package:enhanzer/services/database_services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthService {
  static const String _loginUrl =
      'https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke';

  // Login API call

  static Future<Map<String, dynamic>?> login(
      Map<String, dynamic> payload) async {
    var logger = Logger();
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      logger.e("Error in AuthService login: $e");
      return null;
    }
  }

  // Save user data to SQLite
  static Future<void> saveUserInDataBase(Map<String, dynamic> userData) async {
    await DatabaseService.saveUserData(userData);
  }
}
