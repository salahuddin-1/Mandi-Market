import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/ui/home/homepage.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.yellow[700],
            accentColor: Colors.yellow[700],
            scaffoldBackgroundColor: Colors.white,
            buttonColor: Colors.yellow[700],
            textTheme: GoogleFonts.ralewayTextTheme(
              Theme.of(context).textTheme,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[700],
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: GoogleFonts.raleway(
                color: Colors.black,
              ),
              textTheme: TextTheme(
                headline6: GoogleFonts.raleway(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: "Mandi Market",
          home: HomePage(),
        );
      },
    );
  }
}
