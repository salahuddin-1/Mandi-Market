import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';

import '/src/models/purchase_book_model.dart';
import 'package:rxdart/rxdart.dart';

class PurchaseBookStreamTable {
  PurchaseBookStreamTable() {
    feedEntriesToStream();
  }

  final _resources = new PurchaseBookSQLResources();

  final _streamCntrl = BehaviorSubject<List<PurchaseBookModel>>();

  Stream<List<PurchaseBookModel>> get stream => _streamCntrl.stream;

  feedEntriesToStream() async {
    _streamCntrl.sink.add(
      await _resources.getListModel(),
    );
  }

  void dispose() {
    _streamCntrl.close();
  }
}
