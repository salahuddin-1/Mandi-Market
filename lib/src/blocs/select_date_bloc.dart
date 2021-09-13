import 'package:rxdart/rxdart.dart';

final _dateTime = DateTime.now();

class SelectDateBloc {
  final _todateCntrl = BehaviorSubject<DateTime?>.seeded(_dateTime);
  final _fromDateCntrl = BehaviorSubject<DateTime?>.seeded(_dateTime);

  selectToDate(DateTime date) {
    _todateCntrl.sink.add(date);
  }

  DateTime? get toDateValue => _todateCntrl.value;

  DateTime? get fromDateValue => _fromDateCntrl.value;

  selectFromDate(DateTime? date) {
    _fromDateCntrl.sink.add(date);
  }

  Stream<DateTime?> get streamToDate => _todateCntrl.stream;
  Stream<DateTime?> get streamFromDate => _fromDateCntrl.stream;

  void dispose() {
    _todateCntrl.close();
    _fromDateCntrl.close();
  }
}
