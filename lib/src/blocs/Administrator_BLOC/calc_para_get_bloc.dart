import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:rxdart/rxdart.dart';

class CalcParaGetBLOC {
  CalcParaGetBLOC() {
    feedEntries();
  }

  final _streamContrl = BehaviorSubject<List<CalcParaModel>>();

  feedEntries() async {
    var listMaps = await SQLresourcesCalcPara.getEntries();

    _streamContrl.sink.add(
      await SQLresourcesCalcPara.convertMapsIntoModel(listMaps),
    );
  }

  Stream<List<CalcParaModel>> get stream => _streamContrl.stream;

  void dispose() {
    _streamContrl.close();
  }
}
