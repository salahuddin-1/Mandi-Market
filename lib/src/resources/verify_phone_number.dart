import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/phone_number_services.dart';
import 'package:mandimarket/src/ui/registration/registration_step_2.dart';
import 'package:mandimarket/src/validation/otp_validation.dart';
import 'package:mandimarket/src/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class VerifyPhoneNumber {
  final String name;
  final String phoneNumber;
  final String address;
  final String password;
  final ShowCircularProgressBloc showCircularProgressBloc;
  final _auth = FirebaseAuth.instance;

  final _phoneNumberServices = new PhoneNumberServices();

  VerifyPhoneNumber({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.password,
    required this.showCircularProgressBloc,
  });

  verifyPhone(String phoneNumber, BuildContext context) async {
    await _auth
        .verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      timeout: Duration(seconds: 90),
      verificationCompleted: (credential) async {
        _onVerificationCompleted(credential, context);
      },
      codeSent: (verificationId, [forceResendingToken]) {
        _showDialogForCodeSent(
          context,
          verificationId,
          forceResendingToken!,
        );
        showCircularProgressBloc.showCircularProgress(false);
      },
      verificationFailed: (exception) {
        ShowToast.toast(ErrorCustom.error(exception), context, 4);
        showCircularProgressBloc.showCircularProgress(false);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        showCircularProgressBloc.showCircularProgress(false);
      },
    )
        .catchError(
      (err) {
        ShowToast.toast(ErrorCustom.error(err), context, 4);
        showCircularProgressBloc.showCircularProgress(false);
      },
    );
  }

  void _onVerificationCompleted(
    AuthCredential credential,
    BuildContext context,
  ) async {
    await _phoneNumberServices.verificationCompleted(credential).then(
      (user) {
        if (user.uid == _auth.currentUser!.uid) {
          Push(
            context,
            pushTo: Step2(
              name: name,
              password: password,
              address: address,
              phoneNumber: phoneNumber,
            ),
          );
        } else {
          print("User not equals to");
        }
      },
    ).catchError(
      (err) {
        ShowToast.toast(ErrorCustom.error(err), context, 4);
      },
    );
    showCircularProgressBloc.showCircularProgress(false);
  }

  _onCodeSent(
    String verificationId,
    int token,
    BuildContext context,
    String otp,
  ) async {
    await _phoneNumberServices
        .codeSent(
      verificationId,
      token,
      smsCode: otp,
    )
        .then(
      (user) {
        if (user.uid == _auth.currentUser!.uid) {
          Push(
            context,
            pushTo: Step2(
              name: name,
              password: password,
              address: address,
              phoneNumber: phoneNumber,
            ),
          );
        } else {
          print("User not equals to");
        }
      },
    ).catchError(
      (err) {
        ShowToast.toast(ErrorCustom.error(err), context, 4);
      },
    );
  }

  final _otpCntrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showDialogForCodeSent(
    BuildContext context,
    String verificationId,
    int token,
  ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (newContext) {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AlertDialog(
            title: Text('Enter OTP'),
            content: TextFormField(
              controller: _otpCntrl,
              maxLength: 6,
              keyboardType: TextInputType.phone,
              validator: (val) => OtpValidation.validate(val!),
            ),
            actions: [
              MaterialButton(
                minWidth: 10.w,
                // color: YELLOW700,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _onCodeSent(
                      verificationId,
                      token,
                      context,
                      _otpCntrl.text.trim(),
                    );
                    Pop(newContext);
                  }
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
