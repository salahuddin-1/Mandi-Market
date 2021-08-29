import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/models/bepari_model.dart';

class BepariDatabase {
  static Future<void> addBepari(BepariModel _, String ownersPhoneNumber) async {
    return await Database.mastersRef
        .doc(ownersPhoneNumber)
        .collection('bepari')
        .doc(_.partyName)
        .set(_.toMap());
  }

  static Future<DocumentSnapshot> getBepari(
    String phoneNumber,
    String bepariName,
  ) async {
    return await Database.mastersRef
        .doc(phoneNumber)
        .collection('bepari')
        .doc(bepariName)
        .get();
  }

  static Stream<QuerySnapshot> getAllBepari(String phoneNumber) {
    return Database.mastersRef
        .doc(phoneNumber)
        .collection('bepari')
        .snapshots();
  }
}
