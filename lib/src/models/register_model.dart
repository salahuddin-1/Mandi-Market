import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel {
  final String name;
  final String phoneNumber;
  final String address;
  final String password;
  final String companyName;
  final String occupation;
  final Uint8List? companyLogo;
  final Uint8List? profilePhoto;
  final String? companyLogoUrl;
  final String? profilePhotoUrl;

  RegisterModel({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.password,
    required this.companyName,
    required this.occupation,
    this.companyLogo,
    this.profilePhoto,
    this.companyLogoUrl,
    this.profilePhotoUrl,
  });

  factory RegisterModel.fromDoc(DocumentSnapshot doc) {
    return RegisterModel(
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      address: doc['address'],
      password: doc['password'],
      companyName: doc['companyName'],
      occupation: doc['occupation'],
      companyLogoUrl: doc['companyLogoUrl'],
      profilePhotoUrl: doc['profilePhotoUrl'],
    );
  }
}
