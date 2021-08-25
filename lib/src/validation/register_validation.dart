class RegisterValidation {
  static String? name(String val) {
    if (val.isEmpty) {
      return "Name cannot be empty";
    } else if (val.trim().length > 35) {
      return "Name too long";
    } else if (val.length <= 3) {
      return "Name too short";
    }
    return null;
  }

  static String? phoneNumber(String val) {
    if (val.isEmpty) {
      return "Phone number cannot be empty";
    } else if (!val.contains(RegExp("^[0-9]+\$"))) {
      return "Phone number not valid";
    }

    return null;
  }

  static String? address(String val) {
    if (val.isEmpty) {
      return "Address cannot be empty";
    } else if (val.length > 200) {
      return 'Address too long';
    }
    return null;
  }

  static String? password(String val) {
    if (val.isEmpty) {
      return "Password cannot be empty";
    } else if (val.length <= 10) {
      return "Password too short";
    } else if (val.length > 15) {
      return "Password too long";
    }
    return null;
  }

  static String? confirmPassword(String val, String password) {
    if (val != password) {
      return "Passwords don't match";
    }
    return null;
  }
}
