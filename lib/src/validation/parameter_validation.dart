class ParameterValidation {
  static String? commissionRe1(String val) {
    if (val.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }

  static String? karkuni(String val) {
    if (val.isEmpty) {
      return "Karkuni cannot be empty";
    }
    return null;
  }

  static String? commission(String val) {
    if (val.isEmpty) {
      return "Commssion cannot be empty";
    }
    return null;
  }

  static String? remark(String val) {
    if (val.isEmpty) {
      return "Remark cannot be empty";
    }

    return null;
  }

  static String? discount(String val) {
    if (val.isEmpty) {
      return "Discount cannot be empty";
    } else if (!val.contains(RegExp("[0-9]"))) {
      return "Enter a valid amount";
    }

    return null;
  }
}
