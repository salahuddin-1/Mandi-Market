import 'dart:convert';

import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';

class PaymentBepariModel {
  int? documentId;
  String? timestamp;
  String? selectedTimestamp;
  int? dateHash;
  String? bepariName;
  OpeningBalance? openingBalance;
  List<Bills>? bills;
  String? paidAmount;
  String? pendingAmount;
  String? receivingAmount;
  String? receivedAmount;
  String? balAmtToPay;
  String? balAmtToReceive;
  List<BillingEntryModel>? billEntryModels;
  MasterModel? masterModel;

  PaymentBepariModel({
    this.documentId,
    this.timestamp,
    this.selectedTimestamp,
    this.dateHash,
    this.bepariName,
    this.openingBalance,
    this.bills,
    this.paidAmount,
    this.pendingAmount,
    this.receivingAmount,
    this.receivedAmount,
    this.balAmtToPay,
    this.balAmtToReceive,
    this.billEntryModels,
    this.masterModel,
  });

  PaymentBepariModel.fromJson(Map<String, dynamic> json) {
    this.documentId = json['documentId'];
    this.timestamp = json['timestamp'];
    this.selectedTimestamp = json['selectedTimestamp'];
    this.dateHash = json['dateHash'];
    this.bepariName = json['bepariName'];
    this.paidAmount = json['paidAmount'];
    this.pendingAmount = json['pendingAmount'];
    this.receivedAmount = json['receivedAmount'];
    this.receivingAmount = json['receivingAmount'];
    this.balAmtToPay = json['balanceAmountToPay'];
    this.balAmtToReceive = json['balanceAmountToReceive'];

    // this.billEntryModels =

    // List<dynamic> bills = jsonDecode(json['bills']);

    // if (bills.isNotEmpty) {
    //   this.bills = bills.map((map) => Bills.fromJson(map)).toList();
    // }

    // Map<String, dynamic> openingBalMap = jsonDecode(json['openingBalance']);
    // final openingBalModel = OpeningBalance.fromJson(openingBalMap);

    // this.openingBalance = openingBalModel;
  }

  // factory PaymentBepariModel.fromJson(Map<String, dynamic> json) {
  //   List<dynamic> bills = jsonDecode(json['bills']);

  //   bills = bills.map((map) => Bills.fromJson(map)).toList();

  //   Map<String, dynamic> openingBalMap = jsonDecode(json['openingBalance']);
  //   final openingBalModel = OpeningBalance.fromJson(openingBalMap);

  //   return PaymentBepariModel(
  //     documentId: json['documentId'],
  //     timestamp: json['timestamp'],
  //     selectedTimestamp: json['selectedTimestamp'],
  //     dateHash: json['dateHash'],
  //     bepariName: json['bepariName'],
  //     paidAmount: json['paidAmount'],
  //     pendingAmount: json['pendingAmount'],
  //     receivedAmount: json['receivedAmount'],
  //     receivingAmount: json['receivingAmount'],
  //     balAmtToPay: json['balanceAmountToPay'],
  //     balAmtToReceive: json['balanceAmountToReceive'],
  //     bills: bills as List<Bills>,
  //     openingBalance: openingBalModel,
  //   );
  // }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['timestamp'] = this.timestamp;
    data['selectedTimestamp'] = this.selectedTimestamp;
    data['dateHash'] = this.dateHash;
    data['bepariName'] = this.bepariName;
    data['paidAmount'] = this.paidAmount;
    data['pendingAmount'] = this.pendingAmount;
    data['receivingAmount'] = this.receivingAmount;
    data['receivedAmount'] = this.receivedAmount;
    data['balanceAmountToPay'] = this.balAmtToPay;
    data['balanceAmountToReceive'] = this.balAmtToReceive;

    if (this.billEntryModels != null) {
      final billingEntryMap = this
          .billEntryModels!
          .map((billingEntryModel) => billingEntryModel.toMap())
          .toList();

      data['billEntryModels'] = jsonEncode(billingEntryMap);
    }

    if (masterModel != null) {
      data['masterModel'] = jsonEncode(masterModel!.toMap());
    }

    return data;
  }
}

class OpeningBalance {
  String? amount;
  String? clearedAmount;
  String? balance;
  String? date;
  bool? isReceiving;

  OpeningBalance({
    this.amount,
    this.clearedAmount,
    this.date,
    this.isReceiving,
    this.balance,
  });

  factory OpeningBalance.fromJson(Map<String, dynamic> json) {
    return OpeningBalance(
      amount: json['amount'],
      clearedAmount: json['clearedAmount'],
      date: json['date'],
      isReceiving: json['isReceiving'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['clearedAmount'] = this.clearedAmount;
    data['date'] = this.date;
    data['isReceiving'] = this.isReceiving;
    data['balance'] = this.balance;
    return data;
  }
}

class Bills {
  String? pending;
  String? paid;
  String? balance;
  String? date;

  Bills({
    this.pending,
    this.paid,
    this.date,
    this.balance,
  });

  factory Bills.fromJson(Map<String, dynamic> json) {
    return Bills(
      pending: json['pending'],
      paid: json['paid'],
      date: json['date'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['paid'] = this.paid;
    data['date'] = this.date;
    data['balance'] = this.balance;
    return data;
  }
}
