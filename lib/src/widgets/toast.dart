import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowToast {
  static toast(String msg, BuildContext context, int duration) {
    return showToast(
      msg,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: duration),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Colors.black87,
      textStyle: GoogleFonts.raleway(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  static errorToast(String msg, BuildContext context, int duration) {
    return showToast(
      msg,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: duration),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Colors.white,
      textStyle: GoogleFonts.raleway(
        fontWeight: FontWeight.w500,
        color: Colors.red,
      ),
    );
  }

  static successToast(BuildContext context) {
    return ShowToast.toast(
      "Success",
      context,
      3,
    );
  }
}
