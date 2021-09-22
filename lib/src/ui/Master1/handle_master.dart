import 'package:flutter/material.dart';
import 'package:mandimarket/src/Data_Holder/Master/inherited_widget.dart';
import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/database/master_database.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class HandleMaster {
  final _phNo = userCredentials.ownersPhoneNumber;

  BuildContext? context;

  HandleMaster(this.context);

  void addParty(MasterModel masterModel, {required String type}) async {
    type = type.toLowerCase();

    print(type);
    try {
      await MasterSqlResources().insertEntry(
        map: masterModel.toMap(),
        type: type,
      );

      MasterDataHolder.value.feedEntries();

      await MasterDatabase.insertEntry(
        phoneNumber: _phNo,
        type: type,
        documentId: masterModel.documentId.toString(),
        map: masterModel.toMap(),
      );

      ShowToast.successToast(context!);
    } catch (e) {
      ErrorCustom.catchError(context!, e.toString());
      print(e);
    }
  }
}
