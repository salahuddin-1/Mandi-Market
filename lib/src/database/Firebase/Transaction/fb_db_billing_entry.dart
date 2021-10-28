import 'package:mandimarket/src/dependency_injection/user_credentials.dart';

import '../../database_constants.dart';

class BillingEntryFbDb {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;

  Future<void> insertEntry({
    required String docID,
    required Map<String, dynamic> map,
  }) async {
    return await Database.transactionRef
        .doc(ownersPhoneNumber)
        .collection('billingEntry')
        .doc(docID)
        .set(map);
  }

  Future<void> updateEntry({
    required String docID,
    required Map<String, dynamic> map,
  }) async {
    return await Database.transactionRef
        .doc(ownersPhoneNumber)
        .collection('billingEntry')
        .doc(docID)
        .update(map);
  }

  Future<void> deleteEntry({
    required String docID,
  }) async {
    return await Database.transactionRef
        .doc(ownersPhoneNumber)
        .collection('billingEntry')
        .doc(docID)
        .delete();
  }
}
