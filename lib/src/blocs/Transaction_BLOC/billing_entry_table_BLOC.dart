// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart'
    show DataConnectionChecker;
import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/database/Firebase/Transaction/fb_db_billing_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/toast.dart';
import 'package:rxdart/rxdart.dart';

class BillingEntryTableBLOC {
  // VARIABLES
  final _streamCntrl = BehaviorSubject<List<BillingEntryModel>>();
  BillingEntryFbDb _billingEntryFbDb = new BillingEntryFbDb();
  Stream<List<BillingEntryModel>> get stream => _streamCntrl.stream;
  late DateTime date;

  // METHODS
  getEntries() async {
    try {
      final list = await BillingEntriesSQLResources.getEntriesByDate(date);

      final listModel = list
          .map(
            (e) => BillingEntryModel.fromJson(e),
          )
          .toList();

      print(list);

      _streamCntrl.add(listModel);
    } catch (e) {
      print(e.toString());
    }
  }

  // ---------------- ADD ENTRY ---------------------------------------

  Future<void> addEntry(
    BillingEntryModel billingEntryModel, {
    BuildContext? context,
  }) async {
    if (!await DataConnectionChecker().hasConnection) {
      ShowToast.toast(
        'No Internet Connection',
        context!,
        4,
      );

      return;
    }

    try {
      await BillingEntriesSQLResources.insertEntry(
        billingEntryModel.toMap(),
      );

      await _billingEntryFbDb.insertEntry(
        docID: billingEntryModel.documentId.toString(),
        map: billingEntryModel.toMap(),
      );

      await getEntries();

      Pop(context!);

      ShowToast.toast(
        'Entry Added Successfully',
        context,
        3,
      );
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());
    }
  }

// DISPOSE
  void dispose() {
    _streamCntrl.close();
  }

// CONSTRUCTOR
  BillingEntryTableBLOC(DateTime date) {
    this.date = date;

    getEntries();
  }
}
