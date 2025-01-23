import '../services/auth_services.dart';
import 'package:logger/logger.dart';

class AuthController {
  static Future<bool> login(String username, String password) async {
    var logger = Logger();

    try {
      // payload
      final payload = {
        "API_Body": [
          {
            "Unique_Id": "",
            "Pw": password,
          },
        ],
        "Api_Action": "GetUserData",
        "Company_Code": username,
      };

      // Call AuthService to perform the API request
      final response = await AuthService.login(payload);
      // Log the response and payload
      logger.i("Response: $response");
      logger.i("Response: $payload");
      // if the response is successful
      if (response != null && response['Status_Code'] == 200) {
        await AuthService.saveUserInDataBase(response['Response_Body'][0]);
        return true;
      }
      return false;
    } catch (e) {
      logger.e("Error in AuthController: $e");
      return false;
    }
  }
}
