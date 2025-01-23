import 'package:enhanzer/services/database_services.dart';
import 'package:logger/logger.dart';

class HomeController {
  final DatabaseService _databaseService;

  HomeController(this._databaseService);

  Future<List<Map<String, dynamic>>?> getUser() async {
    try {
      var data = await _databaseService.fetchUser();
      var logger = Logger();
      logger.e("message: $data");
      return data;
    } catch (e) {
      print('Error fetching users: $e');
    }
    return null;
  }

  Future<void> initDatabase() async {
    await _databaseService.initDatabase();
  }
}
