class LoginValidation {
  static String? phoneNumber(String val) {
    if (val.isEmpty) {
      return "Phone number must not be empty";
    } else if (!val.contains(RegExp("^[0-9]+\$"))) {
      return "Phone number not valid";
    }

    return null;
  }

  static String? password(String val) {
    if (val.isEmpty) {
      return "Password must not be empty";
    }
    return null;
  }
}
