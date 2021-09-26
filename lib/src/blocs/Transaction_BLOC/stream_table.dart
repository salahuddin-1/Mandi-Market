import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';

import '/src/models/purchase_book_model.dart';
import 'package:rxdart/rxdart.dart';

class PurchaseBookStreamTable {
  late int fromDateHash;
  late int toDateHash;

  PurchaseBookStreamTable({
    required int fromDateHash,
    required int toDateHash,
  }) {
    this.fromDateHash = fromDateHash;
    this.toDateHash = toDateHash;
    feedEntriesToStream();
  }

  final _streamCntrl = BehaviorSubject<List<PurchaseBookModel>>();

  Stream<List<PurchaseBookModel>> get stream => _streamCntrl.stream;

  feedEntriesToStream() async {
    var listMaps = await PurchaseBookSQLResources.getEntriesUsingDateHash(
      fromDateHash: fromDateHash,
      toDateHash: toDateHash,
    );

    var listModel = await PurchaseBookSQLResources.convertMapIntoModels(
      listMaps,
    );

    _streamCntrl.sink.add(
      listModel,
    );
  }

  void dispose() {
    _streamCntrl.close();
  }
}
