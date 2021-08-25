import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LoginButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Widget? widget;
  final bool? wantWidget;

  LoginButton({
    required this.onPressed,
    required this.title,
    this.widget,
    this.wantWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      alignment: Alignment.centerRight,
      child: Container(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: MaterialButton(
            onPressed: () => this.onPressed(),
            child: wantWidget!
                ? widget
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$title ",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
          ),
        ),
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
      ),
    );
  }
}
