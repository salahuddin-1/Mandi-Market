import 'dart:typed_data';

import 'package:mandimarket/src/constants/images.dart';
import 'package:mandimarket/src/resources/asset_image_to_uint8list.dart';
import 'package:mandimarket/src/resources/open_gallery_camera.dart';
import 'package:rxdart/rxdart.dart';

class SelectLogoBloc {
  final _handleGalleryAndCamera = HandleGalleryAndCamera();

  final _streamCntrl = BehaviorSubject<SelectedLogoModel>();

  void selectLogo(int index, String path) {
    _streamCntrl.sink.add(
      SelectedLogoModel(index: index, path: path),
    );
  }

  Future<Uint8List> getLogoImage() async {
    if (_streamCntrl.value.index == -1) {
      return _streamCntrl.value.bytes!;
    }
    // Converting here asset to uint8list
    // bcoz the logo files are assets and from gallery
    final imagePath = CustomImages.logos[_streamCntrl.value.index];
    return await convertAssetToFile(imagePath);
  }

  void selectFromGallery() async {
    try {
      final file = await _handleGalleryAndCamera.handleChooseFromGallery();
      final bytes = await file!.readAsBytes();

      _streamCntrl.sink.add(
        SelectedLogoModel(index: -1, path: "", bytes: bytes),
      );
    } catch (e) {
      print(e);
    }
  }

  Stream<SelectedLogoModel> get getLogo => _streamCntrl.stream;

  void dispose() {
    _streamCntrl.close();
  }
}

class SelectedLogoModel {
  final int index;
  final String path;
  Uint8List? bytes;

  SelectedLogoModel({
    required this.index,
    required this.path,
    this.bytes,
  });
}
