import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/Data_Holder/Purchase_book/inherited_widget.dart';
import 'package:mandimarket/src/database/Firebase/Transaction/fb_db_purchase_book.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class HandlePurchaseBook {
  BuildContext? context;

  HandlePurchaseBook(this.context);

  void addEntryInPurchaseBook(PurchaseBookModel purchaseBookModel) async {
    try {
      // Add in Local DB
      await PurchaseBookSQLResources().insertEntry(
        purchaseBookModel.toMap(),
      );
      // Add in Firestore
      await PurchaseBookFbDB().insertEntry(
        docID: purchaseBookModel.documentId.toString(),
        map: purchaseBookModel.toMap(),
      );

      PurchaseBookDataHolder.value.feedEntriesToStream();

      ShowToast.successToast(context!);
    } catch (e) {
      ErrorCustom.catchError(
        context!,
        e.toString(),
      );
    }
  }
}
