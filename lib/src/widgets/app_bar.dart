import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:sizer/sizer.dart';

import 'add_button.dart';

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

class AppBarCustom {
  BuildContext context;
  AppBarCustom(this.context);

  AppBar appbar({
    required String title,
    required List<Widget> actions,
    Function? onPressedAdd,
  }) {
    return AppBar(
      backgroundColor: Colors.brown[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
        iconSize: 15.sp,
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: actions.isEmpty
          ? [
              AddButton(
                onPressed: () => onPressedAdd!(),
                textColor: Colors.white,
              )
            ]
          : actions,
    );
  }
}
