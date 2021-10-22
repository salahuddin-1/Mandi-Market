import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/Purchase_Book/table.dart';
import 'package:sizer/sizer.dart';

class OnTapPurchaseBook {
  BuildContext context;
  late final SelectDateBloc _selectDateBloc;
  late final TextEditingController _fromDateContrl;
  late final TextEditingController _toDateContrl;

  OnTapPurchaseBook(this.context) {
    _selectDateBloc = new SelectDateBloc();

    _fromDateContrl = new TextEditingController(
      text: formatDate(
        DateTime.now(),
      ),
    );

    _toDateContrl = new TextEditingController(
      text: formatDate(
        DateTime.now(),
      ),
    );
  }

  void dispose() {
    _selectDateBloc.dispose();
    _fromDateContrl.dispose();
    _toDateContrl.dispose();
  }

  onTap() {
    showDialog(
      context: context,
      builder: (newContext) => AlertDialog(
        title: Text('Select Date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2.h),
            _fromDate(newContext),
            SizedBox(height: 3.h),
            _toDate(newContext),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Pop(newContext);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              var toDate = calculateDateHash(_selectDateBloc.toDateValue!);
              var fromDate = calculateDateHash(_selectDateBloc.fromDateValue!);

              Push(
                context,
                pushTo: PurchaseBookTable(
                  fromDateHash: fromDate,
                  toDateHash: toDate,
                ),
              );
              Pop(newContext);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Row _toDate(BuildContext newContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("To : "),
        StreamBuilder<DateTime?>(
          stream: _selectDateBloc.streamToDate,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 40.w,
              child: TextFormField(
                controller: _toDateContrl,
                readOnly: true,
                onTap: () async {
                  await _onTapToDate(newContext, snapshot);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Row _fromDate(BuildContext newContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("From : "),
        StreamBuilder<DateTime?>(
          stream: _selectDateBloc.streamFromDate,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 40.w,
              child: TextFormField(
                controller: _fromDateContrl,
                readOnly: true,
                onTap: () async {
                  await _onTapFromDate(newContext, snapshot);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onTapToDate(
    BuildContext newContext,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await _showDate(
      newContext,
      title: 'To',
      selectedDate: snapshot.data!,
    );

    if (date != null) {
      _selectDateBloc.selectToDate(date);
      var pickedDate = formatDate(date);

      _toDateContrl.text = pickedDate;
    }
  }

  Future<void> _onTapFromDate(
    BuildContext newContext,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await _showDate(
      newContext,
      title: 'From',
      selectedDate: snapshot.data!,
    );

    if (date != null) {
      _selectDateBloc.selectFromDate(date);
      var pickedDate = formatDate(date);

      _fromDateContrl.text = pickedDate;
    }
  }

  Future<DateTime?> _showDate(
    context, {
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
}
