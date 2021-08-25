import 'dart:typed_data';
import 'package:flutter/services.dart';

Future<Uint8List> convertAssetToFile(String path) async {
  final byteData = await rootBundle.load(path);

  final bytes = byteData.buffer.asUint8List(
    byteData.offsetInBytes,
    byteData.lengthInBytes,
  );

  return bytes;
}
