import 'package:rxdart/rxdart.dart';

class DebitCreditBloc {
  final _streamCntrl = BehaviorSubject<String>.seeded("Debit");

  void updateValue(String value) {
    _streamCntrl.sink.add(value);
  }

  Stream<String> getValue() {
    return _streamCntrl.stream;
  }

  void dispose() {
    _streamCntrl.close();
  }
}
