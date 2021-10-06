import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:rxdart/rxdart.dart';

class BillingEntryAddEntryBLOC {
  final _streamCntrl = BehaviorSubject<List<BillingEntryModel>>();

  void addEntry(BillingEntryModel billingEntryModel) {
    BillingEntriesSQLResources.insertEntry(
      billingEntryModel.toMap(),
    );

    BillingEntriesSQLResources.getEntries();
  }

  void dispose() {
    _streamCntrl.close();
  }
}
