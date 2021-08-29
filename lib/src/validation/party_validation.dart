class PartyValidation {
  static String? name(String val) {
    if (val.isEmpty) {
      return "Party name cannot be empty";
    } else if (val.trim().length > 35) {
      return "Party name too long";
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

  static String? openingBalance(String val) {
    if (val.isEmpty) {
      return "Opening balance cannot be empty";
    }

    return null;
  }

  static String? address(String val) {
    if (val.length > 200) {
      return 'Address too long';
    }
    return null;
  }

  static String? remark(String val) {
    if (val.length > 50) {
      return "Remark too long";
    }
    return null;
  }
}
