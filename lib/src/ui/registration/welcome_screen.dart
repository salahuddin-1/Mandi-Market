import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/constants/images.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/login/login.dart';
import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(CustomImages.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildBlurContainer(context),
      ),
    );
  }

  Widget _buildBlurContainer(context) {
    return Container(
      height: 100.h,
      width: 100.w,
      color: Colors.white.withOpacity(0.8),
      child: ListView(
        children: [
          _title(context),
        ],
      ),
    );
  }

  Widget _title(context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 15.h),
      child: Column(
        children: [
          Text(
            "Welcome to ",
            style: GoogleFonts.josefinSlab(
              fontSize: 18.sp,
            ),
          ),
          Text(
            "Mandi Market",
            style: GoogleFonts.tenaliRamakrishna(
              fontSize: 36.sp,
            ),
          ),
          _info(context),
          SizedBox(height: 25.h),
          _registerButton(context),
        ],
      ),
    );
  }

  Widget _registerButton(context) {
    return Container(
      child: MaterialButton(
        minWidth: 72.w,
        onPressed: () {
          Push(context, pushTo: Login());
        },
        child: Text(
          "Get started",
          style: TextStyle(
            color: WHITE,
            fontSize: 11.sp,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: CYAN900,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 12,
            spreadRadius: -7,
          ),
        ],
      ),
    );
  }

  Widget _info(context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: 3.w,
        right: 2.5.w,
        top: 10.h,
      ),
      child: Text(
        "Mandi Market helps you to do all your accounting, calculations. Mandi Market promises data confidentiality, data integrity, data security.Your data gets securely stored in the cloud. Fetch your data whenever & wherever.",
        style: GoogleFonts.poiretOne(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}
