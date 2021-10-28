// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart'
    show DataConnectionChecker;
import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/database/Firebase/Transaction/fb_db_billing_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/no_internet_connection.dart';
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

      print(billingEntryModel.documentId);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());
    }
  }

// ------------------------ UPDATE ENTRY ---------------------------------------
  Future<void> updateEntry({
    required Map<String, dynamic> map,
    required int documentId,
    BuildContext? context,
  }) async {
    assert(context != null);

    if (!await hasInternetConnectionAlert(context!)) return;

    try {
      await BillingEntriesSQLResources.updateEntry(
        map: map,
        documentId: documentId,
      );

      await _billingEntryFbDb.insertEntry(
        docID: documentId.toString(),
        map: map,
      );

      await getEntries();

      Pop(context);

      ShowToast.toast(
        'Entry Updated Successfully',
        context,
        3,
      );
    } catch (e) {
      ErrorCustom.catchError(context, e.toString());
    }
  }

// ------------------ DELETE ENTRY ---------------------------------------------

  void deleteEntry({
    required BuildContext context,
    required int documentId,
  }) async {
    if (!await hasInternetConnectionAlert(context)) return;

    try {
      await BillingEntriesSQLResources.deleteEntry(documentId);

      await _billingEntryFbDb.deleteEntry(docID: documentId.toString());

      await getEntries();

      Pop(context);

      ShowToast.toast(
        'Deleted',
        context,
        3,
      );
    } catch (e) {
      ErrorCustom.catchError(context, e.toString());
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

class BillingEntryEditBLOC {
  late int docId;
  final _streamCntrl = BehaviorSubject<ApiResponse<BillingEntryModel>>();

  Stream<ApiResponse<BillingEntryModel>> get stream => _streamCntrl.stream;

  getEntries() async {
    ApiResponse.loading('Loading');

    try {
      final listMap = await BillingEntriesSQLResources.getEntriesByDocId(docId);
      final Map<String, dynamic>? json = listMap[0];

      if (json != null) {
        final model = BillingEntryModel.fromJson(json);
        _streamCntrl.add(ApiResponse.completed(model));
      }
    } catch (e) {
      _streamCntrl.add(ApiResponse.error(ErrorCustom.error(e)));
    }
  }

  // DISPOSE
  void dispose() {
    _streamCntrl.close();
  }

  //CONSTRUCTOR
  BillingEntryEditBLOC(this.docId) {
    getEntries();
  }
}
