import 'package:flutter/material.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/login_model.dart';
import 'package:mandimarket/src/resources/Internet_Connection.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/home/initial_screen.dart';
import 'package:mandimarket/src/ui/registration/welcome_screen.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CheckInternet _checkInternet;

  @override
  void initState() {
    _checkInternet = CheckInternet();
    _checkInternet.checkConnection(context);
    super.initState();
  }

  @override
  void dispose() {
    _checkInternet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginModel>(
      future: SharedPref.getUserPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          injectUserCredentials(snapshot.data!);
          return InitialScreen();
        }

        return WelcomeScreen();
      },
    );
  }

  void injectUserCredentials(LoginModel loginModel) {
    userCredentials.saveUserCredentials(
      ownersPhoneNumber: loginModel.phoneNumber,
      ownersPassword: loginModel.password,
    );
  }
}
