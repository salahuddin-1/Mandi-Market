class RegistrationStep2Validation {
  static String? companyName(String val) {
    if (val.isEmpty) {
      return "Company name cannot be empty";
    } else if (val.length > 35) {
      return "Company name too long";
    }

    return null;
  }

  static String? occupaton(String val) {
    if (val.isEmpty) {
      return "Occupation cannot be empty";
    } else if (val.length > 15) {
      return "Occupation too long";
    }
    return null;
  }
}
