import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/resources/format_date.dart';

class TransactionDatabase {
  int dateInNumbers(DateTime dateTime) {
    final day = dateTime.day.toString();
    final month = dateTime.month.toString();
    final year = dateTime.year.toString();
    int date = int.parse(day + month + year);

    return date;
  }

  Future<QuerySnapshot> getUsersFromMaster(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    var ref = Database.mastersRef.doc('8898911744').collection('bepari');

    if (toDate == fromDate) {
      return await ref
          .where('dateHash', isEqualTo: calculateDateHash(fromDate))
          .get();
    }

    return await ref
        .where('dateHash', isLessThanOrEqualTo: calculateDateHash(toDate))
        .where('dateHash', isGreaterThanOrEqualTo: calculateDateHash(fromDate))
        .get();
  }
}
