import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:rxdart/rxdart.dart';

class SagaBookBloc {
  final _noOfUnits = BehaviorSubject<int>.seeded(0);
  final _grossAmount = BehaviorSubject<double>.seeded(0);

  Stream<int> get noOfUnits => _noOfUnits.stream;
  Stream<double> get grossAmount => _grossAmount.stream;

  updateNoOfUnits(int val) {
    val = _noOfUnits.value + val;
    _noOfUnits.sink.add(val);
  }

  updateGrossAmount(double val) {
    val = _grossAmount.value + val;
    _grossAmount.sink.add(val);
  }

  void dispose() {
    _noOfUnits.close();
    _grossAmount.close();
  }
}

// -------------------- CHECK IF CALC PARAMS EXISTS ----------------------------

class IsCalcParamsNullBLOC {
  // INITIALIZERS
  final _streamCntrl = BehaviorSubject<ApiResponse<bool>>();

  // STREAM
  Stream<ApiResponse<bool>> get stream => _streamCntrl.stream;

  // METHODS
  isCalcParamsNull() async {
    _streamCntrl.add(ApiResponse.loading('loading'));

    try {
      bool response = await SQLresourcesCalcPara.isCalcParamsNull();
      _streamCntrl.add(ApiResponse.completed(response));
    } catch (e) {
      _streamCntrl.add(ApiResponse.error('error'));
    }
  }

  // DISPOSE
  void dispose() {
    _streamCntrl.close();
  }

  // CONSTRUCTOR
  IsCalcParamsNullBLOC() {
    isCalcParamsNull();
  }
}
