class BillingEntryValidation {
  static String? bepariName(String val) {
    if (val.isEmpty) {
      return "Bepari name cannot be empty";
    }

    return null;
  }

  static String? aadmi(String val) {
    if (val.isEmpty) {
      return "Aadmi cannot be empty";
    }

    return null;
  }

  static String? fees(String val) {
    if (val.isEmpty) {
      return "Fees cannot be empty";
    }

    return null;
  }

  static String? gavalsName(String val) {
    if (val.isEmpty) {
      return "Gaval's name cannot be empty";
    }

    return null;
  }

  static String? gavali(String val) {
    if (val.isEmpty) {
      return "Gavali cannot be empty";
    }

    return null;
  }

  static String? motor(String val) {
    if (val.isEmpty) {
      return "Motor cannot be empty";
    }

    return null;
  }

  static String? rok(String val) {
    if (val.isEmpty) {
      return "Rok cannot be empty";
    }

    return null;
  }

  static String? balance(String val) {
    if (val.isEmpty) {
      return "Balance cannot be empty";
    }

    return null;
  }

  static String? miscExp(String val) {
    if (val.isEmpty) {
      return "Miscellaneous Expenses cannot be empty";
    }

    return null;
  }
}
