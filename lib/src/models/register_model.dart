import 'dart:typed_data';

class RegisterModel {
  final String name;
  final String phoneNumber;
  final String address;
  final String password;
  final String companyName;
  final String occupation;
  final Uint8List? companyLogo;
  final Uint8List? profilePhoto;

  RegisterModel({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.password,
    required this.companyName,
    required this.occupation,
    this.companyLogo,
    this.profilePhoto,
  });
}
