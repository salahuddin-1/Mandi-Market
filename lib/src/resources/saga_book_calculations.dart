import 'package:get/get.dart';
import 'package:mandimarket/src/blocs/Administrator_BLOC/get_discount_commissionre1_BLOC.dart';
import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';

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
    var discount = _getX.discount ?? this._discount;

    var _kacchiRakam = double.parse(kacchiRakam);

    discount = _kacchiRakam * (discount / 100);
    discount = getValueUpto2Precisions(discount);

    return discount;
  }

  double calculateDalali({required num units}) {
    var commissionRe1 = _getX.commissionRe1 ?? this._commissionRe1;

    return commissionRe1! * units;
  }

  double getValueUpto2Precisions(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  final _getX = Get.put(GetXDiscountAndCommissionRe());

  var _discount;
  _getDiscount() async {
    var map = await SQLresourcesCalcPara.getDiscountAndCommissionRe1();

    var discount = double.tryParse(map['discount']);

    this._discount = discount;
  }

  double? _commissionRe1;
  _getCommissionRe1() async {
    var map = await SQLresourcesCalcPara.getDiscountAndCommissionRe1();

    var commissionRe1 = double.tryParse(map['commissionRe1']);

    this._commissionRe1 = commissionRe1;
  }

  SagaBookCalculations() {
    _getDiscount();
    _getCommissionRe1();
  }
}
