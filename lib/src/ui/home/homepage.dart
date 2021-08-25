import 'package:flutter/material.dart';
import 'package:mandimarket/src/models/login_model.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/authenticated_user/welcome_card.dart';
import 'package:mandimarket/src/ui/home/initial_screen.dart';
import 'package:mandimarket/src/ui/login/login.dart';
import 'package:mandimarket/src/ui/registration/registration_step_2.dart';
import 'package:mandimarket/src/ui/registration/welcome_screen.dart';

import '../persisitent_bnb_using_library.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginModel>(
      future: SharedPref.getUserPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InititalScreen();
        }

        return WelcomeScreen();
      },
    );
  }
}

class TrialWidget extends StatelessWidget {
  const TrialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Common color'),
            ElevatedButton(onPressed: () {}, child: Text("Button")),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
                focusColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container container(double width, double height) {
    return Container(
      color: Colors.red,
      width: width.toDouble(),
      height: height.toDouble(),
    );
  }
}
