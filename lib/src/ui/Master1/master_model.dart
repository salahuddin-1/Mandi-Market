import 'package:cloud_firestore/cloud_firestore.dart';

class MasterModel {
  String partyName;
  String address;
  String phoneNumber;
  int openingBalance;
  String debitOrCredit;
  String remark;
  int? documentId;
  String? timestamp;

  MasterModel({
    required this.partyName,
    required this.address,
    required this.phoneNumber,
    required this.debitOrCredit,
    required this.openingBalance,
    required this.remark,
    required this.documentId,
    this.timestamp,
  });

  factory MasterModel.fromDocument(DocumentSnapshot doc) {
    final masterModel = MasterModel(
      partyName: doc['partyName'],
      address: doc['address'],
      phoneNumber: doc['phoneNumber'],
      openingBalance: doc['openingBalance'],
      debitOrCredit: doc['debitOrCredit'],
      remark: doc['remark'],
      timestamp: doc['timestamp'],
      documentId: doc['documentId'],
    );

    return masterModel;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    if (this.timestamp != null) {
      map['timestamp'] = this.timestamp;
    }

    map['partyName'] = this.partyName;
    map['address'] = this.address;
    map['phoneNumber'] = this.phoneNumber;
    map['openingBalance'] = this.openingBalance;
    map['debitOrCredit'] = this.debitOrCredit;
    map['remark'] = this.remark;
    map['documentId'] = this.documentId;

    return map;
  }

  factory MasterModel.fromJSON(Map<String, dynamic> map) {
    return MasterModel(
      partyName: map['partyName'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      openingBalance: map['openingBalance'],
      debitOrCredit: map['debitOrCredit'],
      remark: map['remark'],
      timestamp: map['timestamp'],
      documentId: map['documentId'],
    );
  }

  @override
  String toString() {
    return {
      'partyName': partyName,
      'address': address,
      'phoneNumber': phoneNumber,
      'debitOrCredit': debitOrCredit,
      'openingBalance': openingBalance,
      'remark': remark,
      'timestamp': timestamp,
      'docId': documentId,
    }.toString();
  }
}
