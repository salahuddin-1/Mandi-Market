import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/authenticated_user/welcome_card.dart';

class InititalScreen extends StatelessWidget {
  const InititalScreen({Key? key}) : super(key: key);

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
                SharedPref.clearPrefs();
              },
            ),
          ],
        ),
      ),
    );
  }
}
