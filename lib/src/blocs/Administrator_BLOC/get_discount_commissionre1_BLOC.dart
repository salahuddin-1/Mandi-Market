import 'package:get/get.dart';
import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:rxdart/rxdart.dart';

class GetDiscountAndCommissionRe1BLOC {
  final _discountStreamCntrl = BehaviorSubject<String>();
  final _commissionRe1StreamCntrl = BehaviorSubject<String>();

  void dispose() {
    _discountStreamCntrl.close();
    _commissionRe1StreamCntrl.close();
  }
}

class GetXDiscountAndCommissionRe extends GetxController {
  double? _discount;
  double? _commissionRe1;

  double? get discount => _discount;
  double? get commissionRe1 => _commissionRe1;

  void setDiscount(double val) {
    this._discount = val;
  }

  void setCommissionRe1(double val) {
    this._commissionRe1 = val;
  }
}
