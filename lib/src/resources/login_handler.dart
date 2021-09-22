import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/database/register_login_db.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/register_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
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

      try {
        var doc = await RegisterLoginDb.getUserByPhoneNumber(phoneNumber);

        if (doc.exists) {
          var qSnap = await RegisterLoginDb.getUserByPassword(
            password,
            phoneNumber,
          );

          if (qSnap.docs.isNotEmpty) {
            final userModel = RegisterModel.fromDoc(qSnap.docs.first);

            // print(qSnap.docs.first['phoneNumber']);
            SharedPref.storeUsersLoginInfo(
              phoneNumber,
              password,
            );

            userCredentials.saveUserCredentials(
              ownersPhoneNumber: phoneNumber,
              ownersPassword: password,
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

            WelcomeCard.welcomeCard(
              context,
              userModel,
            );
          } else if (qSnap.docs.isEmpty) {
            ShowToast.toast(
              "Invalid Password",
              context,
              3,
            );
          }
        } else {
          ShowToast.toast(
            "User does not exist",
            context,
            3,
          );
        }

        showCircularProgressBloc.showCircularProgress(false);
      } catch (e) {
        ErrorCustom.catchError(
          context,
          e.toString(),
        );
        showCircularProgressBloc.showCircularProgress(false);
      }
    }
  }
}
