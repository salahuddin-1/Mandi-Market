import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class UploadImageToStorage {
  static var _storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImage(
    String phone,
    Uint8List image,
    String path,
  ) async {
    UploadTask _uploadTask =
        _storageRef.child("$phone/$path.jpg").putData(image);

    TaskSnapshot _storageSnapshot = await _uploadTask.whenComplete(() => null);

    return await _storageSnapshot.ref.getDownloadURL();
  }
}
