import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';

class CalcParamFbDB {
  static final ownersPhoneNumber = userCredentials.ownersPhoneNumber;

  static Future<void> insert({
    required String docID,
    required Map<String, dynamic> map,
  }) async {
    return await Database.administratorRef
        .doc(ownersPhoneNumber)
        .collection('calculationParameters')
        .doc(docID)
        .set(map);
  }
}
