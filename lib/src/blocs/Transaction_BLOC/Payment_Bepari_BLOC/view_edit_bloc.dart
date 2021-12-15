import 'package:rxdart/rxdart.dart';

class PaymentCheckedBLOC {
  final streamCntrl = BehaviorSubject<bool>.seeded(false);
  final _readOnlyTextFieldCntrl = BehaviorSubject<bool>.seeded(false);
  final _showUndoButtonCntrl = BehaviorSubject<bool>.seeded(false);

  void sink(bool value) {
    streamCntrl.add(value);

    final checked = streamCntrl.value;

    if (checked) {
      _readOnlyTextFieldCntrl.add(checked);
      _showUndoButtonCntrl.add(checked);
      return;
    }

    // Add False
    _readOnlyTextFieldCntrl.add(checked);
    _showUndoButtonCntrl.add(checked);
  }

  Stream<bool> get stream => streamCntrl.stream;
  Stream<bool> get readOnlyTextfieldStream => _readOnlyTextFieldCntrl.stream;
  Stream<bool> get undoButtonStream => _showUndoButtonCntrl.stream;

  void dispose() {
    streamCntrl.close();
    _readOnlyTextFieldCntrl.close();
    _showUndoButtonCntrl.close();
  }
}
