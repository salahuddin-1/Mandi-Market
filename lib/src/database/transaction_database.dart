import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/database_constants.dart';

class TransactionDatabase {
  Future<QuerySnapshot> getUsersFromMaster({
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
}
