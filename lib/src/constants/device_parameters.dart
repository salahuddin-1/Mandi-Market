import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DeviceParams {
  static int get heightWithoutAppbar => (100.h - kToolbarHeight).toInt();
}
