class SagaBookCalculations {
  double calculateKacchiRakam({required String rate, required String unit}) {
    var _rate = double.parse(rate);
    var _unit = double.parse(unit);

    var kacchiRakam = (_rate / 20) * _unit;
    kacchiRakam = getValueUpto2Precisions(kacchiRakam);
    return kacchiRakam;
  }

  double calculatePakkiRakam({
    required String discount,
    required String dalali,
    required String kacchiRakam,
  }) {
    var _discount = double.parse(discount);
    var _dalali = double.parse(dalali);
    var _kacchiRakam = double.parse(kacchiRakam);

    var pakkiRakam = (_kacchiRakam - _dalali) - _discount;

    pakkiRakam = getValueUpto2Precisions(pakkiRakam);

    return pakkiRakam;
  }

  double calculateDiscount({required String kacchiRakam}) {
    var _kacchiRakam = double.parse(kacchiRakam);
    var discount = _kacchiRakam * 0.05;
    discount = getValueUpto2Precisions(discount);
    return discount;
  }

  double getValueUpto2Precisions(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
