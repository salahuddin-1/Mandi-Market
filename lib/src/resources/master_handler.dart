import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/blocs/master_list_pagination.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/database/master_database.dart';
import 'package:mandimarket/src/models/master_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class MasterHandler {
  void addMaster(
    MasterModel masterModel,
    String ownersPhoneNumber,
    BuildContext context,
    ShowCircularProgressBloc showCircularProgressBloc, {
    required String type,
    MasterPaginationBloc? masterPaginationBloc,
  }) async {
    try {
      type = type.toLowerCase();
      showCircularProgressBloc.showCircularProgress(true);
      final snapshot = await MasterDatabase.getUserQuerysnap(
        ownersPhoneNumber,
        type,
        masterModel.comparingName,
      );

      if (snapshot.docs.isNotEmpty) {
        ShowToast.errorToast(
          "Party already exists",
          context,
          4,
        );
        showCircularProgressBloc.showCircularProgress(false);

        return;
        // Function terminated
      }
      final docRef = await MasterDatabase.addUserAndGetDocRef(
        masterModel,
        ownersPhoneNumber,
        type,
      );

      await MasterDatabase.updateUserWithDocID(
        ownersPhoneNumber,
        type,
        docRef.id,
      );

      ShowToast.toast(
        "Party added successfully !",
        context,
        4,
      );

      Pop(context);
      showCircularProgressBloc.showCircularProgress(false);
      //
      masterModel.documentId = docRef.id;
      masterPaginationBloc!.addAnItemToCacheList(masterModel);
    } catch (e) {
      ShowToast.toast(
        ErrorCustom.error(e),
        context,
        4,
      );
      showCircularProgressBloc.showCircularProgress(false);
    }
  }

  Future<void> updateMaster(
    MasterModel masterModel,
    String ownersPhoneNumber,
    BuildContext context,
    ShowCircularProgressBloc showCircularProgressBloc, {
    required String type,
    required String docId,
    required MasterPaginationBloc masterPaginationBloc,
  }) async {
    try {
      showCircularProgressBloc.showCircularProgress(true);

      masterPaginationBloc.editAUser(masterModel);

      await MasterDatabase.updateUser(
        masterModel,
        ownersPhoneNumber,
        type.toLowerCase(),
        docId,
      );

      ShowToast.toast(
        "Party updated successfully !",
        context,
        4,
      );

      Pop(context);
      showCircularProgressBloc.showCircularProgress(false);
    } catch (e) {
      ShowToast.toast(
        ErrorCustom.error(e),
        context,
        4,
      );
      showCircularProgressBloc.showCircularProgress(false);
    }
  }

  void delete(
    String phoneNumber,
    String type,
    String docId,
    BuildContext context,
    MasterPaginationBloc masterPaginationBloc,
  ) {
    try {
      masterPaginationBloc.deleteAUserFromList(docId);
      MasterDatabase.delete(phoneNumber, type.toLowerCase(), docId);
      ShowToast.toast(
        "Party deleted sucessfully",
        context,
        4,
      );
      Pop(context);
    } catch (e) {
      ShowToast.toast(
        ErrorCustom.error(e.toString()),
        context,
        4,
      );
    }
  }

  List<MasterModel> getMasterModelList(QuerySnapshot snapshot) {
    final masterList = snapshot.docs.map(
      (doc) {
        MasterModel masterModel = MasterModel.fromDocument(doc);
        return masterModel;
      },
    ).toList();
    return masterList;
  }

  DocumentSnapshot getLastDocument(QuerySnapshot snapshot) {
    return snapshot.docs.last;
  }
}
