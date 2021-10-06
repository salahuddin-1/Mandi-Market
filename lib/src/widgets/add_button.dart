import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AddButton extends StatelessWidget {
  final Function onPressed;
  final Color textColor;

  const AddButton({
    Key? key,
    required this.onPressed,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => this.onPressed(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Add",
              style: GoogleFonts.raleway(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            TextSpan(text: " "),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(-2.0, -5.0),
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: this.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
