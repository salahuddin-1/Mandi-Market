// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart'
    show DataConnectionChecker;
import 'package:flutter/cupertino.dart';
import 'package:mandimarket/src/widgets/toast.dart';

Future<bool> hasInternetConnectionAlert(BuildContext context) async {
  if (!await DataConnectionChecker().hasConnection) {
    ShowToast.toast(
      'No Internet Connection',
      context,
      4,
    );

    return false;
  }

  return true;
}
