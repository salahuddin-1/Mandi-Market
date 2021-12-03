import 'dart:convert';

import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';

class PaymentBepariInsertEntry {
  static Future<Map<String, dynamic>> pdateEntryThroughBillingEntry(
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

    double balAmtToPay = double.parse(masterBillModel.balAmtToPay!);
    double balAmtToReceive = double.parse(masterBillModel.balAmtToReceive!);

    double pendingAmount = double.tryParse(
      masterBillModel.openingBalance!.amount!,
    )!;

    // If amount is receiving we don't want to add it in pending amount
    if (masterBillModel.openingBalance!.isReceiving!) {
      pendingAmount = 0;
    }

    double paidAmount = 0;

    double receivingAmount = double.tryParse(
      masterBillModel.receivingAmount!,
    )!;

    double receivedAmount = double.tryParse(
      masterBillModel.receivedAmount!,
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

    balAmtToPay = balAmtToPay + double.parse(billAmount);

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
      'receivedAmount': receivedAmount,
      'receivingAmount': receivingAmount,
      'balanceAmountToPay': balAmtToPay,
      'balanceAmountToReceive': balAmtToReceive,
    };

    print(map);

    return map;
  }

// ------------- ADD THROUGH MASTER --------------------------------------------

  static Map<String, dynamic> addEntryThroughMaster(MasterModel masterModel) {
    List<Map<String, String>> bills = [];

    final openingBalance = masterModel.openingBalance.toString();

    final DateTime timestamp = DateTime.tryParse(masterModel.timestamp!)!;

    String balanceRemaingOpenBal = openingBalance;
    String pendingAmount = openingBalance;
    String receivingAmount = '0';

    // INITIALLY 0
    String paidAmount = '0';
    String receivedAmount = '0';

    String balAmtToPay = pendingAmount;
    String balAmtToReceive = '0';

    bool isReceiving = false;

    //  ----------  RECEIVING  ----------------
    if (masterModel.debitOrCredit.toLowerCase() == 'debit') {
      pendingAmount = '0';
      receivingAmount = openingBalance;
      isReceiving = true;
      balAmtToPay = '0';
      balAmtToReceive = receivingAmount;
    }
    // ----------------------------------------
    final openingBalMap = {
      'amount': openingBalance,
      'clearedAmount': '0',
      'date': timestamp.toIso8601String(),
      'isReceiving': isReceiving,
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
      'receivedAmount': receivedAmount,
      'receivingAmount': receivingAmount,
      'balanceAmountToPay': balAmtToPay,
      'balanceAmountToReceive': balAmtToReceive,

      // 'debitOrCredit': masterModel.debitOrCredit,
    };

    return map;
  }
}

class UpdateEntryThroughBill {
  UpdateEntryThroughBill(this.bepariName);

  late String bepariName;

  Future<Map<String, dynamic>> updateEntryThroughBill(
    BillingEntryModel billingEntryModel,
  ) async {
    PaymentBepariModel paymentBepariModel = await _getPaymentBepariModel();

    //  ------ Balance Amount to Pay ------
    double _currentBillAmount = double.parse(billingEntryModel.netAmount);

    double balanceAmtToPay = _currentBillAmount +
        double.parse(
          paymentBepariModel.balAmtToPay!,
        );
    // -------------------------------------

    // ------- Pending Amount ---------
    double pendingAmt = double.parse(paymentBepariModel.pendingAmount!);
    pendingAmt = _currentBillAmount + pendingAmt;
    // ---------------------------------

    // -------- Paid Amount ------------
    double paidAmt = double.parse(paymentBepariModel.paidAmount!);
    // ----------------------------------

    final map = {
      'documentId': paymentBepariModel.documentId,
      'timestamp': paymentBepariModel.timestamp,
      'dateHash': billingEntryModel.dateHash,
      // Bcoz selected Timestamp will be of current bill
      'selectedTimestamp': billingEntryModel.selectedTimestamp,
      'bepariName': bepariName,
      'pendingAmount': pendingAmt.toString(),
      'paidAmount': paidAmt.toString(),
      'receivedAmount': paymentBepariModel.receivedAmount,
      'receivingAmount': paymentBepariModel.receivingAmount,
      'balanceAmountToPay': balanceAmtToPay.toString(),
      'balanceAmountToReceive': paymentBepariModel.balAmtToReceive,
    };

    print(map);
    return map;
  }

  // We are getting that bill when it was added in Masters
  Future<PaymentBepariModel> _getPaymentBepariModel() async {
    final paymentBepariMap =
        await PaymentBepariSQLResources.getBillByBepariName(bepariName);

    // Deserializing that bill
    return PaymentBepariModel.fromJson(paymentBepariMap!);
  }
}
