class TransactionValidation {
  static String? bepariName(String val) {
    if (val.isEmpty) {
      return "Bepari name cannot be empty";
    }
    return null;
  }

  static String? customerName(String val) {
    if (val.isEmpty) {
      return "Customer name cannot be empty";
    }
    return null;
  }

  static String? dawanName(String val) {
    if (val.isEmpty) {
      return "Dawan name cannot be empty";
    }
    return null;
  }

  static String? unit(String val) {
    if (val.isEmpty) {
      return "Unit cannot be empty";
    }

    return null;
  }

  static String? rate(String val) {
    if (val.isEmpty) {
      return "Rate cannot be empty";
    }

    return null;
  }

  static String? dalali(String val) {
    if (val.isEmpty) {
      return "Dalali cannot be empty";
    }

    return null;
  }

  static String? discount(String val) {
    if (val.isEmpty) {
      return "Discount cannot be empty";
    }

    return null;
  }
}
