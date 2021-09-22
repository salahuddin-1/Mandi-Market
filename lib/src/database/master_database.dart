import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/models/master_model.dart';

class MasterDatabase {
  static Future<DocumentReference> addUserAndGetDocRef(
    MasterModel _,
    String ownersPhoneNumber,
    String type,
  ) async {
    return await Database.mastersRef
        .doc(ownersPhoneNumber)
        .collection(type)
        .add(_.toMap());
  }

  static Future<void> updateUserWithDocID(
    String ownersPhoneNumber,
    String type,
    String docId,
  ) async {
    return await Database.mastersRef
        .doc(ownersPhoneNumber)
        .collection(type)
        .doc(docId)
        .update({
      'documentId': docId,
    });
  }

  static Future<void> updateUser(
    MasterModel _,
    String ownersPhoneNumber,
    String type,
    String docId,
  ) async {
    return await Database.mastersRef
        .doc(ownersPhoneNumber)
        .collection(type)
        .doc(docId)
        .update(_.toMapUpdateQuery());
  }

  static Future<DocumentSnapshot> getUser(
    String phoneNumber,
    String docId,
    String type,
  ) async {
    return await Database.mastersRef
        .doc(phoneNumber)
        .collection(type.toLowerCase())
        .doc(docId)
        .get();
  }

  static Future<QuerySnapshot> getUserQuerysnap(
    String phoneNumber,
    String type,
    String comparingName,
  ) async {
    return await Database.mastersRef
        .doc(phoneNumber)
        .collection(type)
        .where('comparingName', isEqualTo: comparingName)
        .get();
  }

  static Stream<QuerySnapshot> getAllUsers(
    String phoneNumber,
    String type, {
    DocumentSnapshot? lastDoc,
  }) {
    final ref = Database.mastersRef
        .doc(phoneNumber)
        .collection(type.toLowerCase())
        .limit(3)
        .orderBy('partyName');
    if (lastDoc == null) {
      return ref.snapshots();
    }

    return ref.startAfterDocument(lastDoc).snapshots();
  }

  static Future<void> delete(
    String phoneNumber,
    String type,
    String docId,
  ) async {
    return await Database.mastersRef
        .doc(phoneNumber)
        .collection(type)
        .doc(docId)
        .delete();
  }

  static Future<void> insertEntry({
    required String phoneNumber,
    required String type,
    required String documentId,
    required Map<String, dynamic> map,
  }) async {
    return await Database.mastersRef
        .doc(phoneNumber)
        .collection(type)
        .doc(documentId)
        .set(map);
  }
}
