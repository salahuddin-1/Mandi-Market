import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/database/database_constants.dart';

class GetUserCredentialsFbDB {
  static Future<DocumentSnapshot> getUser(String phonenumber) {
    return Database.usersRef.doc(phonenumber).get();
  }
}
