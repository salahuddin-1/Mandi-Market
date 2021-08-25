import 'package:rxdart/rxdart.dart';

class ShowCircularProgressBloc {
  final _streamCntrl = BehaviorSubject<bool>.seeded(false);

  showCircularProgress(bool val) {
    _streamCntrl.sink.add(val);
  }

  Stream<bool> get streamCircularProgress => _streamCntrl.stream;

  void dispose() {
    _streamCntrl.close();
  }
}
