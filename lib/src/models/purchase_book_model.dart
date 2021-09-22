//

import 'package:mandimarket/src/resources/format_date.dart';

class PurchaseBookModel {
  final String bepariName;
  final String customerName;
  final String pediName;
  final String dawanName;
  final String unit;
  final String rate;
  final String dalali;
  final String discount;
  final String kacchiRakam;
  final String pakkiRakam;
  final int? documentId;
  final String timestamp;
  final String selectedTimestamp;

  PurchaseBookModel({
    required this.bepariName,
    required this.customerName,
    required this.pediName,
    required this.dawanName,
    required this.unit,
    required this.rate,
    required this.dalali,
    required this.discount,
    required this.kacchiRakam,
    required this.pakkiRakam,
    this.documentId,
    required this.selectedTimestamp,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'bepariName': this.bepariName,
      'customerName': this.customerName,
      'pediName': this.pediName,
      'dawanName': this.dawanName,
      'unit': this.unit,
      'rate': this.rate,
      'dalali': this.dalali,
      'discount': this.discount,
      'kacchiRakam': this.kacchiRakam,
      'pakkiRakam': this.pakkiRakam,
      'documentId': this.documentId,
      'timestamp': this.timestamp,
      'selectedTimestamp': this.selectedTimestamp,
    };

    return map;
  }

  factory PurchaseBookModel.fromJSON(Map<String, dynamic> map) {
    return PurchaseBookModel(
      bepariName: map['bepariName'],
      customerName: map['customerName'],
      pediName: map['pediName'],
      dawanName: map['dawanName'],
      unit: map['unit'],
      rate: map['rate'],
      dalali: map['dalali'],
      discount: map['discount'],
      kacchiRakam: map['kacchiRakam'],
      pakkiRakam: map['pakkiRakam'],
      selectedTimestamp: formatDate(
        DateTime.tryParse(
          map['selectedTimestamp'],
        ),
      ),
      timestamp: map['timestamp'],
      documentId: map['documentId'],
    );
  }
}
