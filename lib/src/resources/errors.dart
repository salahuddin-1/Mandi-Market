import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class ErrorCustom {
  static String error(errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many attempts. Try again later";

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";

      default:
        return "An unknown error occured. Try again later.";
    }
  }

  static void catchError(BuildContext context, String e) {
    ShowToast.toast(
      ErrorCustom.error(e),
      context,
      3,
    );
  }
}
