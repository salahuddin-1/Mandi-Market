import 'dart:typed_data';

import 'package:mandimarket/src/resources/open_gallery_camera.dart';
import 'package:rxdart/rxdart.dart';

class HandleGalleryCameraBloc {
  final _handleGalleryAndCamera = HandleGalleryAndCamera();
  final _streamCntrlGallery = BehaviorSubject<Uint8List>();

  Uint8List get getValue => _streamCntrlGallery.value;

  void selectFromGallery() async {
    try {
      final file = await _handleGalleryAndCamera.handleChooseFromGallery();
      final bytes = await file!.readAsBytes();
      _streamCntrlGallery.sink.add(bytes);
    } catch (e) {
      print(e);
    }
  }

  void selectFromCamera() async {
    try {
      final file = await _handleGalleryAndCamera.handleChooseFromCamera();
      final bytes = await file!.readAsBytes();
      _streamCntrlGallery.sink.add(bytes);
    } catch (e) {
      print(e);
    }
  }

  Stream<Uint8List> image() {
    return _streamCntrlGallery.stream;
  }

  void dispose() {
    _streamCntrlGallery.close();
  }
}
