class OtpValidation {
  static String? validate(String val) {
    if (val.isEmpty) {
      return "Please enter the OTP";
    } else if (val.length != 6) {
      return "Enter a valid OTP";
    } else if (!val.contains(RegExp("^[0-9]+\$"))) {
      return "Enter a valid OTP";
    }

    return null;
  }
}
