import 'dart:convert';

import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';

class PaymentBepariInsertEntry {
  static Future<Map<String, dynamic>> updateEntryThroughBillingEntry(
    BillingEntryModel billingEntryModel, {
    required String bepariName,
  }) async {
    // We are getting that bill when it was added in Masters
    final masterBillMap = await PaymentBepariSQLResources.getBillByBepariName(
      bepariName,
    );

    print('Bill added Master : $masterBillMap');

    // Deserializing that bill
    final masterBillModel = PaymentBepariModel.fromJson(masterBillMap!);

    List<Map<String, dynamic>> bills = [];

    double pendingAmount = double.tryParse(
      masterBillModel.openingBalance!.pending!,
    )!;

    double paidAmount = double.tryParse(
      masterBillModel.openingBalance!.paid!,
    )!;

    // MORE THAN 1 BILL EXISTS
    if (masterBillModel.bills != null) {
      // Adding Previous bills
      masterBillModel.bills!.forEach(
        (bill) {
          bills.add(
            {
              'pending': bill.pending,
              'paid': bill.paid,
              'date': bill.date,
            },
          );

          pendingAmount = pendingAmount + double.tryParse(bill.pending!)!;
          paidAmount = paidAmount + double.tryParse(bill.paid!)!;
        },
      );
    }

    // Previous Entries
    int docId = masterBillModel.documentId!;
    String previousTimestamp = masterBillModel.timestamp!;
    final openingBalanceMap = masterBillModel.openingBalance!.toMap();

    // New Entries
    String billAmount = billingEntryModel.netAmount;
    String currentBillDate = billingEntryModel.selectedTimestamp;
    int currentDateHash = billingEntryModel.dateHash;
    pendingAmount = pendingAmount + double.tryParse(billAmount)!;

    // Adding New bill
    bills.add(
      {
        'pending': billAmount,
        'paid': '0',
        'date': currentBillDate,
      },
    );

    final map = {
      'documentId': docId,
      'timestamp': previousTimestamp,
      'dateHash': currentDateHash,
      // Bcoz selected Timestamp will be of current bill
      'selectedTimestamp': currentBillDate,
      'openingBalance': jsonEncode(openingBalanceMap),
      'bepariName': bepariName,
      'bills': jsonEncode(bills),
      'pendingAmount': pendingAmount.toString(),
      'paidAmount': paidAmount.toString(),
    };
    // } else {
    //   // Bepari name does not exists , that means bepari is not added in masters
    //   // TODO
    //   // bill is null
    // }

    print(map);

    return map;
  }

// -------------------- UPDATE FROM BILLING ENTRY ------------------------------

  insert(BillingEntryModel billingEntryModel) async {
    final openingBal = await MasterSqlResources.getOpeningBalance(
      billingEntryModel.bepariName,
    );

    final billsMap = await PaymentBepariSQLResources.getBills(
      billingEntryModel.bepariName,
    );

    Map<String, dynamic> map = {};

    // NEW BILL
    if (billsMap == null) {
      List<String> bills = [];

      bills.add(billingEntryModel.netAmount);

      map = {
        'documentId': getDocumentId,
        'timestamp': DateTime.now().toIso8601String(),
        'dateHash': billingEntryModel.dateHash,
        'selectedTimestamp': billingEntryModel.selectedTimestamp,
        'bepariName': billingEntryModel.bepariName,
        'openingBalance': openingBal['openingBalance'],
        'bills': jsonEncode(bills),
        'pendingAmount': billingEntryModel.netAmount,
        'paid Amount': '0',
      };
    }

    // BILL EXISTS
    if (billsMap != null) {
      final List<String> bills = jsonDecode(billsMap['bills']);
      bills.add(billingEntryModel.netAmount);

      // Calculate total amount pending

      double amountPending = 0;

      bills.forEach(
        (element) {
          double bill = double.parse(element);
          amountPending = amountPending + bill;
        },
      );

      // ADD
      map = {
        'bills': jsonEncode(bills),
        'pendingAmount': amountPending,
      };
    }

    // ADD
    await PaymentBepariSQLResources.insertEntry(map);
  }

// ------------- ADD THROUGH MASTER --------------------------------------------

  static Map<String, dynamic> addEntryThroughMaster(MasterModel masterModel) {
    List<Map<String, String>> bills = [];

    final openingBalance = masterModel.openingBalance.toString();

    // final billMap = {
    //   'pending' : '',
    //   'paid' : '',
    //   'date' : '',
    // };

    // bills.add(billMap);

    final DateTime timestamp = DateTime.tryParse(masterModel.timestamp!)!;

    String pendingAmount = openingBalance;
    String paidAmount = '0';

    if (masterModel.debitOrCredit.toLowerCase() == 'debit') {
      pendingAmount = '0';
      paidAmount = openingBalance;
    }

    final openingBalMap = {
      'pending': pendingAmount,
      'paid': paidAmount,
      'date': timestamp.toIso8601String(),
    };

    final map = {
      'documentId': getDocumentId,
      'timestamp': timestamp.toIso8601String(),
      'dateHash': calculateDateHash(timestamp),
      'selectedTimestamp': timestamp.toIso8601String(),
      'bepariName': masterModel.partyName,
      'openingBalance': jsonEncode(openingBalMap),
      'bills': jsonEncode(bills),
      'pendingAmount': pendingAmount,
      'paidAmount': paidAmount,
      // 'debitOrCredit': masterModel.debitOrCredit,
    };

    return map;
  }
}
