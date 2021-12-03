import 'package:flutter/material.dart';
import 'package:mandimarket/src/Data_Holder/Master/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/Payment_Bepari_BLOC/payment_bepari_insert_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/database/master_database.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:mandimarket/src/widgets/no_internet_connection.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class HandleMaster {
  final _phNo = userCredentials.ownersPhoneNumber;

  BuildContext? context;

  HandleMaster(this.context);

  void addParty(MasterModel masterModel, {required String type}) async {
    if (!await hasInternetConnectionAlert(context!)) return;

    try {
      var partyExists = await MasterSqlResources.getUserByName(
        type,
        masterModel.partyName.toLowerCase(),
      );

      if (partyExists) {
        ShowToast.errorToast('Party Already Exists', context!, 3);
        return;
      }

      if (masterModel.debitOrCredit.toLowerCase() == "debit") {
        masterModel.openingBalancePaid = masterModel.openingBalance.toString();
      }

      await MasterSqlResources().insertEntry(
        map: masterModel.toMap(),
        type: type,
      );

      await MasterDataHolder.value.feedEntries();

      await MasterDatabase.insertEntry(
        phoneNumber: _phNo,
        type: type,
        documentId: masterModel.documentId.toString(),
        map: masterModel.toMap(),
      );

// ------------------ ADD PAYMENT TO BEPARI------------
      if (type == 'bepari') {
        await _addBillInPaymentToBepari(masterModel);
      }
// ---------------------------------------------------

      ShowToast.toast(
        'Party Added Successfully',
        context!,
        3,
      );

      Pop(context!);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());
      print(e);
    }
  }

  // ------------- ADD BILL IN PAYMENT TO BEPARI -------------------------------

  Future<int> _addBillInPaymentToBepari(MasterModel masterModel) async {
    final Map<String, dynamic> billMap =
        PaymentBepariInsertEntry.addEntryThroughMaster(masterModel);

    print(billMap);

    return await PaymentBepariSQLResources.insertEntry(billMap);
  }

  // ---------------------------------------------------------------------------

  void updateParty(MasterModel masterModel, {required String type}) async {
    try {
      //SQL
      await MasterSqlResources().updateEntry(
        type: type,
        docId: masterModel.documentId!,
        map: masterModel.toMap(),
      );

      // Firebase
      await MasterDatabase.updateEntry(
        phoneNumber: _phNo,
        type: type,
        documentId: masterModel.documentId.toString(),
        map: masterModel.toMap(),
      );

      MasterDataHolder.value.feedEntries();

      ShowToast.toast(
        'Party Updated Successfully',
        context!,
        3,
      );

      Pop(context!);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());

      print(e);
    }
  }

  void delete({required String type, required String docId}) async {
    try {
      await MasterSqlResources().deleteEntry(
        type: type,
        docId: int.tryParse(docId)!,
      );

      await MasterDatabase.deleteEntry(
        phoneNumber: _phNo,
        type: type,
        documentId: docId,
      );

      MasterDataHolder.value.feedEntries();

      ShowToast.toast(
        'Party Deleted Successfully',
        context!,
        3,
      );

      Pop(context!);
    } catch (e) {
      print(e);
    }
  }
}
