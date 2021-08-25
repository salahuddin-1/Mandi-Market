import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AppbarCustom {
  final String title;
  final BuildContext context;

  AppbarCustom({
    required this.title,
    required this.context,
  });

  AppBar widget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        this.title,
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
      elevation: 0,
      centerTitle: true,
    );
  }
}
