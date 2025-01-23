import '../services/auth_services.dart';
import 'package:logger/logger.dart';

class AuthController {
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    var logger = Logger();

    try {
      // Prepare payload
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

      // API request
      final response = await AuthService.login(payload);

      // Log the response and payload
      logger.i("API Response: $response");
      logger.i("API Payload: $payload");

      // Check the response structure
      if (response != null) {
        if (response['Status_Code'] == 200) {
          final responseBody = response['Response_Body'];
          if (responseBody != null &&
              responseBody.isNotEmpty &&
              !responseBody[0].containsKey('Doc_Msg')) {
            // Save the user data to the database only if there is no error
            await AuthService.saveUserInDataBase(responseBody[0]);
            return {'success': true};
          } else {
            // Handle error
            return {
              'success': false,
              'message': responseBody[0]['Doc_Msg'] ?? 'Unknown error occurred',
            };
          }
        } else {
          // Handle generic API errors (e.g., wrong status code)
          return {
            'success': false,
            'message': response['Message'] ?? 'Unexpected error occurred',
          };
        }
      }

      // Handle unexpected null or invalid response
      return {'success': false, 'message': 'Unexpected error occurred'};
    } catch (e) {
      logger.e("Error in AuthController.login: $e");
      return {'success': false, 'message': 'Something went wrong'};
    }
  }
}

// ;12m│ 💡 API Response: {Status_Code: 200, Sync_Time: , Message: GetUserData Mobile API Executed Successfully., Response_Body: [{User_Code: EZCMP1/EZUSR-1, User_Display_Name: eZuite Admin, Email: info@enhanzer.com, User_Employee_Code: EZCMP1/EZLOC2/EMP-7, Company_Code: EZCMP-1, User_Locations: [{Location_Code: EZCMP1/EZLOC-29}, {Location_Code: EZCMP1/EZLOC-16}, {Location_Code: EZCMP1/EZLOC-19}, {Location_Code: EZCMP1/EZLOC-22}, {Location_Code: EZCMP1/EZLOC-34}, {Location_Code: EZCMP1/EZLOC-4}, {Location_Code: EZCMP1/EZLOC-33}, {Location_Code: EZCMP1/EZLOC-9}, {Location_Code: EZCMP1/EZLOC-24}, {Location_Code: EZCMP1/EZLOC-25}, {Location_Code: EZCMP1/EZLOC-23}, {Location_Code: EZCMP1/EZLOC-5}, {Location_Code: EZCMP1/EZLOC-32}, {Location_Code: EZCMP1/EZLOC-21}, {Location_Code: EZCMP1/EZLOC-17}, {Location_Code: EZCMP1/EZLOC-31}, {Location_Code: EZCMP1/EZLOC-12}, {Location_Code: EZCMP1/EZLOC-14}, {Location_Code: EZCMP1/EZLOC-27}, {Location_Code: EZCMP1/EZLOC-18}, {Location_Code: <…>
