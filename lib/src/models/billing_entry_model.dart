class BillingEntryModel {
  String selectedTimestamp;
  String timestamp;
  int dateHash;
  String bepariName;
  String unit;
  String aadmi;
  String dalali;
  String discount;
  String karkuni;
  String fees;
  String subAmount;
  String netAmount;
  String gavalsName;
  String gavali;
  String motor;
  String rok;
  String baki;
  String description;
  String miscExpenses;
  String documentId;

  BillingEntryModel({
    required this.selectedTimestamp,
    required this.timestamp,
    required this.dateHash,
    required this.bepariName,
    required this.unit,
    required this.aadmi,
    required this.dalali,
    required this.discount,
    required this.karkuni,
    required this.fees,
    required this.subAmount,
    required this.netAmount,
    required this.gavalsName,
    required this.gavali,
    required this.motor,
    required this.rok,
    required this.baki,
    required this.description,
    required this.miscExpenses,
    required this.documentId,
  });

  factory BillingEntryModel.fromJson(Map<String, dynamic> json) {
    return BillingEntryModel(
      selectedTimestamp: json['selectedTimestamp'],
      timestamp: json['timestamp'],
      dateHash: json['dateHash'],
      bepariName: json['bepariName'],
      unit: json['unit'],
      aadmi: json['aadmi'],
      dalali: json['dalali'],
      discount: json['discount'],
      karkuni: json['karkuni'],
      fees: json['fees'],
      subAmount: json['subAmount'],
      netAmount: json['netAmount'],
      gavalsName: json['gavalsName'],
      gavali: json['gavali'],
      motor: json['motor'],
      rok: json['rok'],
      baki: json['baki'],
      description: json['description'],
      miscExpenses: json['miscExpenses'],
      documentId: json['documentId'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedTimestamp'] = this.selectedTimestamp;
    data['timestamp'] = this.timestamp;
    data['dateHash'] = this.dateHash;
    data['bepariName'] = this.bepariName;
    data['unit'] = this.unit;
    data['aadmi'] = this.aadmi;
    data['dalali'] = this.dalali;
    data['discount'] = this.discount;
    data['karkuni'] = this.karkuni;
    data['fees'] = this.fees;
    data['subAmount'] = this.subAmount;
    data['netAmount'] = this.netAmount;
    data['gavalsName'] = this.gavalsName;
    data['gavali'] = this.gavali;
    data['motor'] = this.motor;
    data['rok'] = this.rok;
    data['baki'] = this.baki;
    data['description'] = this.description;
    data['miscExpenses'] = this.miscExpenses;
    data['documentId'] = this.documentId;
    return data;
  }
}
