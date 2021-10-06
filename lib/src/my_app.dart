import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/ui/home/homepage.dart';
import 'package:sizer/sizer.dart';

import 'constants/colors.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: _themeData(context),
          debugShowCheckedModeBanner: false,
          title: "Mandi Market",
          home: HomePage(),
        );
      },
    );
  }

  ThemeData _themeData(BuildContext context) {
    return ThemeData(
      primaryColor: YELLOW700,
      accentColor: YELLOW700,
      scaffoldBackgroundColor: Colors.white,
      buttonColor: YELLOW700,
      textTheme: _textTheme(context),
      textButtonTheme: _textButtonTheme(),
      appBarTheme: _appbarTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      textSelectionTheme: _cusrsorTheme(),
    );
  }

  TextSelectionThemeData _cusrsorTheme() {
    return TextSelectionThemeData(
      cursorColor: Colors.black,
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
      ),
    );
  }

  TextTheme _textTheme(BuildContext context) {
    return GoogleFonts.ralewayTextTheme(
      Theme.of(context).textTheme,
    );
  }

  TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
            color: YELLOW700,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  AppBarTheme _appbarTheme() {
    return AppBarTheme(
      centerTitle: true,
      titleTextStyle: GoogleFonts.raleway(
        color: BLACK,
      ),
      textTheme: TextTheme(
        headline6: GoogleFonts.raleway(
          color: BLACK,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
