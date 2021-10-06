class CalcParaModel {
  int fromDateHash;
  int toDateHash;
  String fromDate;
  String toDate;
  String discount;
  String commissionRe1;
  String karkuni;
  String commission;
  String remark;
  String? documentId;
  String timestamp;

  CalcParaModel({
    required this.fromDateHash,
    required this.toDateHash,
    required this.discount,
    required this.commissionRe1,
    required this.karkuni,
    required this.commission,
    required this.remark,
    this.documentId,
    required this.fromDate,
    required this.toDate,
    required this.timestamp,
  });

  toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();

    if (documentId != null) {
      map['documentId'] = this.documentId;
    }

    map['fromDateHash'] = this.fromDateHash;
    map['toDateHash'] = this.toDateHash;
    map['discount'] = this.discount;
    map['commissionRe1'] = this.commissionRe1;
    map['karkuni'] = this.karkuni;
    map['commission'] = this.commission;
    map['remark'] = this.remark;
    map['fromDate'] = this.fromDate;
    map['toDate'] = this.toDate;
    map['timestamp'] = this.timestamp;

    return map;
  }

  factory CalcParaModel.fromJSON(Map<String, dynamic> map) {
    return CalcParaModel(
      fromDateHash: map['fromDateHash'],
      toDateHash: map['toDateHash'],
      discount: map['discount'],
      commissionRe1: map['commissionRe1'],
      karkuni: map['karkuni'],
      commission: map['commission'],
      remark: map['remark'],
      documentId: map['documentId'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      timestamp: map['timestamp'],
    );
  }
}
