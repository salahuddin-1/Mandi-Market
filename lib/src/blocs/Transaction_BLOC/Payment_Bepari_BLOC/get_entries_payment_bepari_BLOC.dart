import 'dart:convert';

import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:rxdart/rxdart.dart';

class GetEntriesPaymentBepariBLOC {
  // INITIALIZERS
  final _streamCntrl = BehaviorSubject<ApiResponse<PaymentBepariModel>>();

  // STREAM
  Stream<ApiResponse<PaymentBepariModel>> get stream => _streamCntrl.stream;

  // SINK
  getEntries() async {
    final bills = await BillingEntriesSQLResources.getNetAmount();
    final lengthOfBeparis = await MasterSqlResources.getLengthOfBeparis(
      'bepari',
    );

    List<Map<String, dynamic>> amountPending = bills;

    Set<String> beparis = {};
    List<Map<String, String>> openingBalances = [];

    for (int i = 0; i < lengthOfBeparis; i++) {
      if (beparis.contains(bills[i]['bepariName'])) continue;

      final openingBal = await MasterSqlResources.getOpeningBalance(
        bills[i]['bepariName'],
      );

      // amountPending[i]['pending'] = openingBal[i]['openingBalance'] + bills[i]['openingBalance'];

      openingBalances.add(
        {
          'openingBalance': openingBal['openingBalance'].toString(),
          'bepariName': bills[i]['bepariName'],
        },
      );

      beparis.add(bills[i]['bepariName']);
    }

    // This will get encoded and stored in SQL
    Map<String, List<Map<String, dynamic>>> dataBills = {};

    bills.forEach(
      (map) {
        String bepariName = map['bepariName'];

        final bill = dataBills[bepariName];

        if (bill != null) {
          bill.add({
            'pending': map['netAmount'],
            'paid': '0',
            'date': map['selectedTimestamp'],
          });
        } else {
          dataBills[bepariName] = [
            {
              'pending': map['netAmount'],
              'paid': '0',
              'date': map['selectedTimestamp'],
            }
          ];
        }
      },
    );

    beparis.clear();

    bills.forEach(
      (map) {
        if (!beparis.contains(map['bepariName'])) {
          final Map<String, dynamic> dataMap = {
            'documentId': map['documentId'],
            'timestamp': DateTime.now().toIso8601String(),
            'dateHash': 0,
            'selectedTimestamp': '',
            'bepariName': map['bepariName'],
            'openingBalance': '',
            'bills': jsonEncode(dataBills[map['bepariName']]),
            'paid Amount': '',
            'pendingAmount': '',
          };
        }

        beparis.add(map['bepariName']);
      },
    );

    // await PaymentBepariSQLResources.insertEntry(map);
  }

  // DISPOSE

  void dispose() {
    _streamCntrl.close();
  }

  // CONSTRUCTOR
  GetEntriesPaymentBepariBLOC() {
    // getEntries();
    // TODO
  }
}
