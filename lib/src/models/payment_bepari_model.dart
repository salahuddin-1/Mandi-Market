import 'dart:convert';

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
  });

  PaymentBepariModel.fromJson(Map<String, dynamic> json) {
    this.documentId = json['documentId'];
    this.timestamp = json['timestamp'];
    this.selectedTimestamp = json['selectedTimestamp'];
    this.dateHash = json['dateHash'];
    this.bepariName = json['bepariName'];
    this.paidAmount = json['paidAmount'];
    this.pendingAmount = json['pendingAmount'];

    List<dynamic> bills = jsonDecode(json['bills']);

    if (bills.isNotEmpty) {
      this.bills = bills.map((map) => Bills.fromJson(map)).toList();
    }

    Map<String, dynamic> openingBalMap = jsonDecode(json['openingBalance']);
    final openingBalModel = OpeningBalance.fromJson(openingBalMap);

    this.openingBalance = openingBalModel;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentId'] = this.documentId;
    data['timestamp'] = this.timestamp;
    data['selectedTimestamp'] = this.selectedTimestamp;
    data['dateHash'] = this.dateHash;
    data['bepariName'] = this.bepariName;
    data['paidAmount'] = this.paidAmount;
    data['pendingAmount'] = this.pendingAmount;
    return data;
  }
}

class OpeningBalance {
  String? pending;
  String? paid;
  String? date;

  OpeningBalance({this.pending, this.paid, this.date});

  factory OpeningBalance.fromJson(Map<String, dynamic> json) {
    return OpeningBalance(
      pending: json['pending'],
      paid: json['paid'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['paid'] = this.paid;
    data['date'] = this.date;
    return data;
  }
}

class Bills {
  String? pending;
  String? paid;
  String? date;

  Bills({
    this.pending,
    this.paid,
    this.date,
  });

  factory Bills.fromJson(Map<String, dynamic> json) {
    return Bills(
      pending: json['pending'],
      paid: json['paid'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['paid'] = this.paid;
    data['date'] = this.date;
    return data;
  }
}
