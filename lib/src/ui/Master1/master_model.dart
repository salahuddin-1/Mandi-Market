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
  String openingBalancePaid;
  String openingBalanceReceived;

  MasterModel({
    required this.partyName,
    required this.address,
    required this.phoneNumber,
    required this.debitOrCredit,
    required this.openingBalance,
    required this.remark,
    required this.documentId,
    this.timestamp,
    required this.openingBalancePaid,
    required this.openingBalanceReceived,
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
      openingBalancePaid: doc['openingBalancePaid'],
      openingBalanceReceived: doc['openingBalanceReceived'],
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
    map['openingBalancePaid'] = this.openingBalancePaid;
    map['openingBalanceReceived'] = this.openingBalanceReceived;

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
      openingBalancePaid: map['openingBalancePaid'],
      openingBalanceReceived: map['openingBalanceReceived'],
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
