import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mandimarket/src/Data_Holder/Administrator/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Administrator_BLOC/get_discount_commissionre1_BLOC.dart';
import 'package:mandimarket/src/database/Firebase/Administrator/fb_db_calc_param.dart';
import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/no_internet_connection.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class HandleCalcParam {
  BuildContext? context;

  HandleCalcParam([this.context]);

  final _getX = Get.put(GetXDiscountAndCommissionRe());

  void addParameters(CalcParaModel calcParaModel) async {
    if (!await hasInternetConnectionAlert(context!)) return;

    try {
      await SQLresourcesCalcPara.insertEntry(calcParaModel.toMap());

      await CalcParamFbDB.insert(
        docID: calcParaModel.documentId.toString(),
        map: calcParaModel.toMap(),
      );

      CalcParamDataHolder.value.feedEntries();

      _getX.setDiscount(double.tryParse(calcParaModel.discount)!);
      _getX.setCommissionRe1(double.tryParse(calcParaModel.commissionRe1)!);

      ShowToast.toast(
        'Parameter added successfully',
        context!,
        3,
      );

      Pop(context!);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());

      print(e.toString());
    }
  }

  void editParameter(CalcParaModel calcParaModel) async {
    if (!await hasInternetConnectionAlert(context!)) return;

    try {
      await SQLresourcesCalcPara.editEntry(
        map: calcParaModel.toMap(),
        documentId: calcParaModel.documentId!,
      );

      await CalcParamFbDB.update(
        docID: calcParaModel.documentId.toString(),
        map: calcParaModel.toMap(),
      );

      CalcParamDataHolder.value.feedEntries();

      _getX.setDiscount(double.tryParse(calcParaModel.discount)!);
      _getX.setCommissionRe1(double.tryParse(calcParaModel.commissionRe1)!);

      ShowToast.toast(
        'Parameter Edited',
        context!,
        3,
      );

      Pop(context!);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());

      print(e.toString());
    }
  }

  void deleteParameter(String docId) async {
    if (!await hasInternetConnectionAlert(context!)) return;

    try {
      await SQLresourcesCalcPara.deleteEntry(docId);

      await CalcParamFbDB.delete(
        docID: docId,
      );
      CalcParamDataHolder.value.feedEntries();

      ShowToast.toast(
        'Deleted',
        context!,
        3,
      );

      Pop(context!);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());

      print(e.toString());
    }
  }
}
