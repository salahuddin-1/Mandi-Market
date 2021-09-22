import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';

class PurchaseBookFbDB {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;

  Future<void> insertEntry({
    required String docID,
    required Map<String, dynamic> map,
  }) async {
    return await Database.transactionRef
        .doc(ownersPhoneNumber)
        .collection('purchaseBook')
        .doc(docID)
        .set(map);
  }

  Future<void> updateEntryInPurchaseBookWithDocRef(String docId) async {
    return await Database.transactionRef
        .doc(ownersPhoneNumber)
        .collection('purchaseBook')
        .doc(docId)
        .update({
      'documentId': docId,
    });
  }

  Future<QuerySnapshot> getUsersUsingDatehash({
    required DateTime fromDate,
    required DateTime toDate,
    required String type,
    required String phoneNumber,
  }) async {
    var ref = Database.mastersRef.doc(phoneNumber).collection(type);

    if (toDate == fromDate) {
      return await ref
          .where('dateHash', isEqualTo: calculateDateHash(fromDate))
          .orderBy('timestamp')
          .get();
    }

    return await ref
        .where('dateHash', isLessThanOrEqualTo: calculateDateHash(toDate))
        .where('dateHash', isGreaterThanOrEqualTo: calculateDateHash(fromDate))
        .orderBy('timestamp')
        .get();
  }

  Future<QuerySnapshot> getUsersFromMaster({
    required String type,
    required String phoneNumber,
  }) async {
    return await Database.mastersRef
        .doc(phoneNumber)
        .collection(type)
        .orderBy('comparingName')
        .limit(5)
        .get();
  }

  searchUsers(String name) {
    name = name.toLowerCase();
    var snapshots = Database.mastersRef
        .doc('8898911744')
        .collection('bepari')
        .where('comparingName', isGreaterThanOrEqualTo: name)
        .where('comparingName', isLessThan: name + 'z')
        .snapshots();

    snapshots.forEach((snap) {
      if (snap.docs.isEmpty) {
        print('Empty');
      } else {
        snap.docs.forEach((doc) {
          print(doc['partyName']);
        });
      }
    });
  }
}
