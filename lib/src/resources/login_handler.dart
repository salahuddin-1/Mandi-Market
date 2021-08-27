import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/database/register_login_db.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/ui/authenticated_user/welcome_card.dart';
import 'package:mandimarket/src/ui/home/initial_screen.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class LoginHandler {
  login(
    String phoneNumber,
    String password,
    BuildContext context,
    GlobalKey<FormState> key,
    ShowCircularProgressBloc showCircularProgressBloc,
  ) async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      showCircularProgressBloc.showCircularProgress(true);

      await RegisterLoginDb.getUserByPhoneNumber(phoneNumber).then(
        (doc) async {
          if (doc.exists) {
            await RegisterLoginDb.getUserByPassword(password).then(
              (snapshot) {
                if (snapshot.docs.isNotEmpty) {
                  SharedPref.storeUsersLoginInfo(
                    phoneNumber,
                    password,
                  );
                  ShowToast.toast(
                    "Successfully logged in",
                    context,
                    3,
                  );
                  Push(
                    context,
                    pushTo: InitialScreen(),
                  );
                  WelcomeCard.welcomeCard(context);
                } else if (snapshot.docs.isEmpty) {
                  ShowToast.toast(
                    "Invalid Password",
                    context,
                    3,
                  );
                }
              },
            );
          } else {
            ShowToast.toast(
              "User does not exist",
              context,
              3,
            );
          }
          showCircularProgressBloc.showCircularProgress(false);
        },
      );
    }
  }
}
