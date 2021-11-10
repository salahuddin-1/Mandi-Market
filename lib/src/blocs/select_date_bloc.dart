import 'package:rxdart/rxdart.dart';

class SelectDateBloc {
  final _dateTime = DateTime.now();
  DateTime? _fromDate;
  DateTime? _toDate;

  late final BehaviorSubject<DateTime?> _todateCntrl;
  late final BehaviorSubject<DateTime?> _fromDateCntrl;

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

  // SelectDateBloc({
  //   this.fromDate,
  //   this.toDate,
  // });

  SelectDateBloc({DateTime? fromDate, DateTime? toDate}) {
    if (fromDate == null && toDate == null) {
      this._fromDate = _dateTime;
      this._toDate = _dateTime;
    } else {
      this._fromDate = fromDate;
      this._toDate = toDate;
    }

    _fromDateCntrl = BehaviorSubject<DateTime?>.seeded(this._fromDate);
    _todateCntrl = BehaviorSubject<DateTime?>.seeded(this._toDate);
  }
}
