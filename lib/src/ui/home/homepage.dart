import 'package:flutter/material.dart';
import 'package:mandimarket/src/Inherited_Widget/Example/example.dart';
import 'package:mandimarket/src/Inherited_Widget/Example/screen.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/login_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/home/initial_screen.dart';
import 'package:mandimarket/src/ui/registration/welcome_screen.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
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

class InheritedWidgetPassingTheData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            HoldTheData().setData('The Data');
            Push(
              context,
              pushTo: All(),
            );
          },
          child: Text('Push'),
        ),
      ),
    );
  }
}
