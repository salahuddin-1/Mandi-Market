import 'package:rxdart/rxdart.dart';

class PurchaseBookGetUserBLOC {
  final _bepariStreamCntrl = BehaviorSubject<String>.seeded('');
  final _customerStreamCntrl = BehaviorSubject<String>.seeded('');
  final _dawanStreamCntrl = BehaviorSubject<String>.seeded('');

  updateTextFields({
    required String val,
    required String type,
  }) {
    type = type.toLowerCase();
    if (type == 'bepari') {
      _bepariStreamCntrl.sink.add(val);
    } else if (type == 'customer') {
      _customerStreamCntrl.sink.add(val);
    } else if (type == 'dawan') {
      _dawanStreamCntrl.sink.add(val);
    }
  }

  void dispose() {
    _bepariStreamCntrl.close();
    _customerStreamCntrl.close();
    _dawanStreamCntrl.close();
  }

  BehaviorSubject<String> get bepariCntrl => _bepariStreamCntrl;
  BehaviorSubject<String> get customerStreamCntrl => _customerStreamCntrl;
  BehaviorSubject<String> get dawanStreamCntrl => _dawanStreamCntrl;
}
