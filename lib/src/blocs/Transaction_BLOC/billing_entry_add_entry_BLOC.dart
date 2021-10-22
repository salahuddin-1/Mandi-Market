import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:rxdart/rxdart.dart';

class BillingEntryAddEntryBLOC {
  final _streamCntrl = BehaviorSubject<List<BillingEntryModel>>();

  void addEntry(BillingEntryModel billingEntryModel) async {
    BillingEntriesSQLResources.insertEntry(
      billingEntryModel.toMap(),
    );

    _streamCntrl.add(await getEntries());
  }

  void dispose() {
    _streamCntrl.close();
  }

  Future<List<BillingEntryModel>> getEntries() async {
    var listMaps = await BillingEntriesSQLResources.getEntriesByDate(date);

    return listMaps
        .map(
          (map) => BillingEntryModel.fromJson(map),
        )
        .toList();
  }

  late DateTime date;

  // Constructor
  BillingEntryAddEntryBLOC(DateTime date) {
    this.date = date;
  }
}
