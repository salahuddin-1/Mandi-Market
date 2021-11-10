import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/src/constants/colors.dart';
import 'package:sizer/sizer.dart';

class TitleTable extends StatelessWidget {
  final String text;
  final double? fontSize;
  const TitleTable({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            color: WHITE,
          ),
        ),
      ),
    );
  }
}

class TitleWithFittedBox extends StatelessWidget {
  final String text;
  final double? fontSize;
  const TitleWithFittedBox({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w600,
              color: WHITE,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class SubtitleWithFittedBox extends StatelessWidget {
  final String text;
  final double? fontSize;

  const SubtitleWithFittedBox({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class SubtitleForTable extends StatelessWidget {
  final String text;
  final double? fontSize;

  const SubtitleForTable({
    Key? key,
    required this.text,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class DividerForTable extends StatelessWidget {
  const DividerForTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1);
  }
}

class EditViewButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  const EditViewButton({
    Key? key,
    required this.onPressed,
    this.text = "Edit/View",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: FittedBox(
        child: Container(
          alignment: Alignment.center,
          width: 25.w,
          // color: Colors.red,
          child: Text(
            this.text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BoxDecorationFor {
  static title() {
    return BoxDecoration(
      color: CYAN900,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }
}

class NoData extends StatelessWidget {
  const NoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("No data"),
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Something unexpected happened"),
    );
  }
}
