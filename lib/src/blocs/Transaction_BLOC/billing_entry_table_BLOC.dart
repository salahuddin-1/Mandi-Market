import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:rxdart/rxdart.dart';

class BillingEntryTableBLOC {
  final _streamCntrl = BehaviorSubject<List<PurchaseBookModel>>();

  Stream<List<PurchaseBookModel>> get stream => _streamCntrl.stream;
  final purchaseBookResources = PurchaseBookSQLResources();

  getEntries() async {
    try {
      final list = await purchaseBookResources.getEntriesFromPurchaseBookByDate(
        date,
      );

      final listModel = list
          .map(
            (e) => PurchaseBookModel.fromJSON(e),
          )
          .toList();

      _streamCntrl.add(listModel);
    } catch (e) {
      print(e.toString());
    }
  }

  void dispose() {
    _streamCntrl.close();
  }

  late DateTime date;

  BillingEntryTableBLOC(DateTime date) {
    this.date = date;
    getEntries();
  }
}
