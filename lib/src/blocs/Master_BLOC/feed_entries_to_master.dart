import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:rxdart/rxdart.dart';

class FeedEntriesToMasterBLOC {
  late String type;
  FeedEntriesToMasterBLOC(String type) {
    this.type = type.toLowerCase();
    feedEntries();
  }
  final _masterResources = new MasterSqlResources();
  final _streamCntrl = new BehaviorSubject<List<MasterModel>>();

  Stream<List<MasterModel>> get stream => _streamCntrl.stream;

  void dispose() => _streamCntrl.close();

  Future<void> feedEntries() async {
    var list = await _masterResources.getListsOfModel(type);
    _streamCntrl.sink.add(list);
  }
}
