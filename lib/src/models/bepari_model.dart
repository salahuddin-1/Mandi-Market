import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class BepariModel {
  final String partyName;
  final String address;
  final String phoneNumber;
  final String openingBalance;
  final String debitOrCredit;
  final String remark;

  BepariModel({
    required this.partyName,
    required this.address,
    required this.phoneNumber,
    required this.debitOrCredit,
    required this.openingBalance,
    required this.remark,
  });

  factory BepariModel.fromDocument(DocumentSnapshot doc) {
    return BepariModel(
      partyName: doc['partyName'],
      address: doc['address'],
      phoneNumber: doc['phoneNumber'],
      openingBalance: doc['openingBalance'],
      debitOrCredit: doc['debitOrCredit'],
      remark: doc['remark'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    map['partyName'] = this.partyName;
    map['address'] = this.address;
    map['phoneNumber'] = this.phoneNumber;
    map['openingBalance'] = this.openingBalance;
    map['debitOrCredit'] = this.debitOrCredit;
    map['remark'] = this.remark;

    return map;
  }
}
