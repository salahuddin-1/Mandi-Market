import 'package:get/get.dart';

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
