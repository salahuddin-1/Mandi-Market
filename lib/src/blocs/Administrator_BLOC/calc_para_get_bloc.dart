import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/errors.dart';
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

class CalcParaGetParaByDocIdBLOC {
  // INITIALIZERS
  late final BehaviorSubject<ApiResponse<CalcParaModel>> _streamCntrl;
  late final String docId;

  // STREAM
  Stream<ApiResponse<CalcParaModel>> get stream => _streamCntrl.stream;

  // METHODS
  getParamsForEditing() async {
    _streamCntrl.add(ApiResponse.loading('loading'));

    try {
      final listMap = await SQLresourcesCalcPara.getEntryByDocumentId(docId);

      final model = CalcParaModel.fromJSON(listMap[0]);

      _streamCntrl.add(ApiResponse.completed(model));
    } catch (e) {
      _streamCntrl.add(ApiResponse.error(ErrorCustom.error(e)));
    }
  }

  // DISPOSE
  void dispose() {
    _streamCntrl.close();
  }

  // CONSTRUCTOR
  CalcParaGetParaByDocIdBLOC(this.docId) {
    _streamCntrl = BehaviorSubject();
    getParamsForEditing();
  }
}
