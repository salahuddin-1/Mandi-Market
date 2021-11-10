import 'package:rxdart/rxdart.dart';

class DebitCreditBloc {
  late BehaviorSubject<String> _streamCntrl;

  void updateValue(String value) {
    _streamCntrl.sink.add(value);
  }

  Stream<String> getValue() {
    return _streamCntrl.stream;
  }

  void dispose() {
    _streamCntrl.close();
  }

  String get value => _streamCntrl.value;

  DebitCreditBloc({required String type}) {
    type = type.toLowerCase();

    String _value = "Debit";

    if (type == "Customer" || type == "Pedi") {
      _value = "Credit";
    }

    if (type == 'bepari') {
      _value = "Credit";
    }

    _streamCntrl = BehaviorSubject<String>.seeded(_value);
  }
}
