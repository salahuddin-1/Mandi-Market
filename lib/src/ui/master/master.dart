import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        padding: EdgeInsets.only(top: 1.5.h),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild("Bepari"),
                  _rightChild("Customer"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild("Gawal"),
                  _rightChild("Pedi"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild("Other Parties"),
                  _rightChild("Gawal Account"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild("Dawan"),
                  Expanded(
                    child: Container(),
                  ),
                  // _rightChild("Gawal Account"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _rightChild(String title) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 1.5.w, right: 3.w),
        height: 14.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        ),
        child: Text(
          title,
          textScaleFactor: 0.81.sp,
        ),
      ),
    );
  }

  Expanded _leftChild(String title) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 3.w, right: 1.5.w),
        height: 14.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        ),
        child: Text(
          title,
          textScaleFactor: 0.81.sp,
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        'Mandi Market',
        style: GoogleFonts.raleway(
            // fontWeight: FontWeight.w400,
            ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
