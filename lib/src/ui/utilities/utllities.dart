import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/authenticated_user/welcome_card.dart';
import 'package:mandimarket/src/ui/login/login.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text('Welcome'),
              onPressed: () {
                WelcomeCard.welcomeCard(context);
              },
            ),
            TextButton(
              child: Text('Log out'),
              onPressed: () {
                PushAndRemoveUntilWithoutNavBar.push(
                  context,
                  screen: Login(),
                  withNavBar: false,
                );

                SharedPref.clearPrefs();
              },
            ),
          ],
        ),
      ),
    );
  }
}
