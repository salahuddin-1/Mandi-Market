import 'package:rxdart/rxdart.dart';

class SagaBookBloc {
  final _noOfUnits = BehaviorSubject<int>.seeded(0);
  final _grossAmount = BehaviorSubject<double>.seeded(0);

  Stream<int> get noOfUnits => _noOfUnits.stream;
  Stream<double> get grossAmount => _grossAmount.stream;

  updateNoOfUnits(int val) {
    val = _noOfUnits.value + val;
    _noOfUnits.sink.add(val);
  }

  updateGrossAmount(double val) {
    val = _grossAmount.value + val;
    _grossAmount.sink.add(val);
  }

  void dispose() {
    _noOfUnits.close();
    _grossAmount.close();
  }
}
