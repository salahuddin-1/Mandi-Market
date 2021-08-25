import 'package:rxdart/rxdart.dart';

class ShowHidePasswordBloc {
  bool _isHidden = true;
  final _streamCntrlBool = BehaviorSubject<bool>.seeded(true);

  void setShowOrHide() {
    _streamCntrlBool.sink.add(!_isHidden);
    _isHidden = !_isHidden;
  }

  Stream<bool> showOrHide() {
    return _streamCntrlBool.stream;
  }

  void dispose() {
    _streamCntrlBool.close();
  }
}
