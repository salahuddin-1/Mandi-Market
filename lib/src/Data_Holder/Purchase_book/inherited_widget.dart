import 'package:mandimarket/src/blocs/Transaction_BLOC/stream_table.dart';

// Especially made for bloc
// This class just Holds the data
// The data can be anything (instance, String)
// And this data will be accessible to all the parent children
class PurchaseBookDataHolder {
  static PurchaseBookStreamTable? _purchaseBookStreamTable;

  static PurchaseBookStreamTable get value => _purchaseBookStreamTable!;

  PurchaseBookDataHolder.setValue(PurchaseBookStreamTable value) {
    _purchaseBookStreamTable = value;
  }
}
