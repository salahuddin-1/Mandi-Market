import 'package:mandimarket/src/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static void storeUsersLoginInfo(String phoneNumber, String password) async {
    final sharedPref = await SharedPreferences.getInstance();

    await sharedPref.setBool("isLoggedIn", true);
    await sharedPref.setString("phoneNumber", phoneNumber);
    await sharedPref.setString("password", password);
  }

  static Future<LoginModel> getUserPrefs() async {
    final sharedPref = await SharedPreferences.getInstance();

    final isLoggedIn = sharedPref.getBool("isLoggedIn");
    final phoneNumber = sharedPref.getString("phoneNumber");
    final password = sharedPref.getString("password");

    if (isLoggedIn != null &&
        isLoggedIn &&
        phoneNumber != null &&
        password != null) {
      return LoginModel(phoneNumber: phoneNumber, password: password);
    }
    throw "Unable to load preferences";
  }

  static void clearPrefs() async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
    print("Prefs Cleared");
  }
}
