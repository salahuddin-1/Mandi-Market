import 'package:mandimarket/src/blocs/Administrator_BLOC/calc_para_get_bloc.dart';

// Especially made for bloc
// This class just Holds the data
// The data can be anything (instance, String)
// And this data will be accessible to all the parent children
class CalcParamDataHolder {
  static CalcParaGetBLOC? _calcParaGetBLOC;

  static CalcParaGetBLOC get value => _calcParaGetBLOC!;

  CalcParamDataHolder.setValue(CalcParaGetBLOC value) {
    _calcParaGetBLOC = value;
  }
}
