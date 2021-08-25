import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget circularProgressForButton() {
  return Container(
    height: 5.w,
    width: 5.w,
    child: CircularProgressIndicator(
      color: Colors.black,
      strokeWidth: 1.5,
    ),
  );
}

Widget circularProgressForWholeScreen({
  String text = "Loading",
  Color color = Colors.white,
}) {
  return Container(
    height: 100.h,
    width: 100.w,
    color: Colors.black.withOpacity(0.5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          strokeWidth: 1.5,
          color: color,
        ),
        SizedBox(height: 20),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ),
      ],
    ),
  );
}
