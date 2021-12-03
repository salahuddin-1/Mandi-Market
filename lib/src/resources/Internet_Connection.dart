import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/toast.dart';

class CheckInternet {
  late StreamSubscription<DataConnectionStatus> _listener;
  var _internetStatus = "Unknown";

  checkConnection(BuildContext context) async {
    _listener = DataConnectionChecker().onStatusChange.listen(
      (status) async {
        switch (status) {
          case DataConnectionStatus.connected:
            _internetStatus = "Connected to the Internet";

            ShowToast.toast(_internetStatus, context, 5);
            break;
          case DataConnectionStatus.disconnected:
            _showNoInternetDialog(context);

            break;
        }
      },
    );
    return await DataConnectionChecker().connectionStatus;
  }

  _showNoInternetDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          actions: [
            TextButton(
              onPressed: () async {
                bool _hasInternet = await DataConnectionChecker().hasConnection;

                if (_hasInternet) {
                  Pop(context);
                  return;
                }

                ShowToast.toast(
                  'First turn on your Internet Connection',
                  context,
                  4,
                );
              },
              child: Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  void dispose() {
    _listener.cancel();
  }
}
