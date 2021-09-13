import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:google_fonts/google_fonts.dart';

Future<DateTime?> showDate(
  BuildContext context, {
  required String title,
  required DateTime selectedDate,
}) async {
  var datePicked = await DatePicker.showSimpleDatePicker(
    context,
    initialDate: selectedDate,
    firstDate: DateTime(2020),
    lastDate: DateTime(2100),
    dateFormat: "dd-MMMM-yyyy",
    looping: false,
    titleText: "$title date",
    itemTextStyle: GoogleFonts.raleway(
      fontWeight: FontWeight.w400,
    ),
  );

  return datePicked;
}
