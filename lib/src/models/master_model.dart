import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';

class MasterModel {
  String partyName;
  String address;
  String phoneNumber;
  String openingBalance;
  String debitOrCredit;
  String remark;
  String? documentId;
  String comparingName;
  Timestamp? timestamp;
  int? dateHash;

  MasterModel({
    required this.partyName,
    required this.address,
    required this.phoneNumber,
    required this.debitOrCredit,
    required this.openingBalance,
    required this.remark,
    this.documentId,
    this.timestamp,
    required this.comparingName,
    this.dateHash,
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
      comparingName: doc['comparingName'],
    );
    if (!doc.data().toString().contains('documentId')) {
      return masterModel;
    }

    masterModel.documentId = doc['documentId'];
    return masterModel;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    map['partyName'] = this.partyName;
    map['address'] = this.address;
    map['phoneNumber'] = this.phoneNumber;
    map['openingBalance'] = this.openingBalance;
    map['debitOrCredit'] = this.debitOrCredit;
    map['remark'] = this.remark;
    map['timestamp'] = DateTime.now();
    map['comparingName'] = this.comparingName;
    map['dateHash'] = calculateDateHash(DateTime.now());

    return map;
  }

  Map<String, dynamic> toMapUpdateQuery() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    map['partyName'] = this.partyName;
    map['address'] = this.address;
    map['phoneNumber'] = this.phoneNumber;
    map['openingBalance'] = this.openingBalance;
    map['debitOrCredit'] = this.debitOrCredit;
    map['remark'] = this.remark;
    map['comparingName'] = this.comparingName;

    return map;
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
      'comparingName': comparingName,
      'timestamp': timestamp,
      'docId': documentId,
    }.toString();
  }
}
