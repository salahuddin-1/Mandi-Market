import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/database/register_login_db.dart';
import 'package:mandimarket/src/models/register_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/shared_pref.dart';
import 'package:mandimarket/src/resources/verify_phone_number.dart';
import 'package:mandimarket/src/ui/home/initial_screen.dart';
import 'package:mandimarket/src/ui/registration/welcome_screen.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class RegistrationHandler {
  void submitStepOne(
    String name,
    String phoneNumber,
    String address,
    String password,
    GlobalKey<FormState> key,
    BuildContext context,
    ShowCircularProgressBloc showCircularProgressBloc,
  ) async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      showCircularProgressBloc.showCircularProgress(true);

      await RegisterLoginDb.getUserByPhoneNumber(phoneNumber).then(
        (doc) async {
          if (doc.exists) {
            ShowToast.toast(
              "User already registered",
              context,
              4,
            );
            showCircularProgressBloc.showCircularProgress(false);
          } else if (!doc.exists) {
            final verifyPhoneNumber = new VerifyPhoneNumber(
              name: name,
              phoneNumber: phoneNumber,
              address: address,
              password: password,
              showCircularProgressBloc: showCircularProgressBloc,
            );
            try {
              await verifyPhoneNumber.verifyPhone(
                phoneNumber,
                context,
              );
            } catch (e) {
              ShowToast.toast(
                ErrorCustom.error(e),
                context,
                4,
              );
            }
          }
        },
      );
    }
  }

  register(
    String name,
    String phoneNumber,
    String address,
    String password,
    String companyName,
    String occupation,
    Uint8List companyLogo,
    Uint8List profilePhoto,
    GlobalKey<FormState> key,
    BuildContext context,
    ShowCircularProgressBloc? _showCircularProgressBloc,
  ) async {
    if (key.currentState!.validate()) {
      _showCircularProgressBloc!.showCircularProgress(true);
      key.currentState!.save();
      final registerModel = new RegisterModel(
        name: name,
        phoneNumber: phoneNumber,
        password: password,
        address: address,
        companyName: companyName,
        occupation: occupation,
        companyLogo: companyLogo,
        profilePhoto: profilePhoto,
      );
      await RegisterLoginDb.register(registerModel).then(
        (value) {
          SharedPref.storeUsersLoginInfo(
            phoneNumber,
            password,
          );
          ShowToast.toast(
            "Success",
            context,
            3,
          );
          PushAndRemoveUntil(
            context,
            pushAndRemoveTo: InititalScreen(),
          );
        },
      ).catchError(
        (err) {
          print(err);
        },
      );
      _showCircularProgressBloc.showCircularProgress(false);
    }
  }
}
