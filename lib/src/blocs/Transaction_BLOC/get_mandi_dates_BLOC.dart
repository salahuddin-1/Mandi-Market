import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:rxdart/rxdart.dart';

class GetMandiDatesBLOC {
  final _streamCntrl = BehaviorSubject<List<String>>();

  Stream<List<String>> get stream => _streamCntrl.stream;

  getDates() async {
    var listDates = await PurchaseBookSQLResources.getDates();

    var list = listDates
        .map(
          (map) => map['selectedTimestamp'] as String,
        )
        .toList();

    _streamCntrl.add(list);
  }

  void dispose() {
    _streamCntrl.close();
  }

  static get intance => GetMandiDatesBLOC();

  GetMandiDatesBLOC() {
    getDates();
  }
}
