import 'package:shared_preferences/shared_preferences.dart';

class SessionServices {
  static Future<void> saveUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
  }

  static Future<void> saveSignupUser(String Signupemail,String SignupPassword) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Signupemail', Signupemail);
    await prefs.setString('SignupPassword', SignupPassword);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {'email': prefs.getString('email') ?? ''};
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
