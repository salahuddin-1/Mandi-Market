import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/database/upload_image_to_storage.dart';
import 'package:mandimarket/src/models/register_model.dart';

class RegisterLoginDb {
  static Future<void> register(RegisterModel _) async {
    String profilePhotoUrl = await UploadImageToStorage().uploadImage(
      _.phoneNumber,
      _.profilePhoto!,
      "profilePhoto",
    );

    String companyLogoUrl = await UploadImageToStorage().uploadImage(
      _.phoneNumber,
      _.companyLogo!,
      "companyLogo",
    );

    return Database.usersRef.doc(_.phoneNumber).set(
      {
        "name": _.name,
        "phoneNumber": _.phoneNumber,
        "password": _.password,
        "address": _.address,
        "companyName": _.companyName,
        "occupation": _.occupation,
        "timestamp": DateTime.now(),
        "companyLogoUrl": companyLogoUrl,
        "profilePhotoUrl": profilePhotoUrl,
      },
    );
  }

  static Future<DocumentSnapshot> getUserByPhoneNumber(
    String phoneNumber,
  ) async {
    return await Database.usersRef.doc(phoneNumber).get();
  }

  static Future<QuerySnapshot> getUserByPassword(String password) async {
    return await Database.usersRef.where("password", isEqualTo: password).get();
  }
}
