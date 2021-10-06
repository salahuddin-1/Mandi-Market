import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/select_date.dart';
import 'package:sizer/sizer.dart';

class EnterOpeningBalance {
  BuildContext _context;

  EnterOpeningBalance(this._context);

  late final _fromDateContrl = new TextEditingController(
    text: formatDate(
      DateTime.now(),
    ),
  );

  late final _cashInHandCntrl = new TextEditingController();
  late final _capitalCntrl = new TextEditingController();

  late final _selectDateBloc = new SelectDateBloc();

  showdialog() {
    return showDialog(
      context: _context,
      builder: (newContext) => AlertDialog(
        // title: Text('Select Date'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 2.h),
              _fromDate(newContext),
              SizedBox(height: 2.h),
              _cashInHand(),
              SizedBox(height: 2.h),
              _capital(),
            ],
          ),
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
              var fromDate = calculateDateHash(_selectDateBloc.fromDateValue!);

              Pop(newContext);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Row _fromDate(BuildContext newContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Book start date : "),
        Expanded(
          child: StreamBuilder<DateTime?>(
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
        ),
      ],
    );
  }

  Row _cashInHand() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Cash in hand : "),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            width: 40.w,
            child: TextFormField(
              controller: _cashInHandCntrl,
            ),
          ),
        ),
      ],
    );
  }

  Row _capital() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Capital : "),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: 40.w,
          child: TextFormField(
            controller: _capitalCntrl,
          ),
        ),
      ],
    );
  }

  Future<void> _onTapFromDate(
    BuildContext newContext,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await showDate(
      newContext,
      title: 'From',
      selectedDate: snapshot.data!,
    );
    _selectDateBloc.selectFromDate(date!);
    var pickedDate = formatDate(date);

    _fromDateContrl.text = pickedDate;
  }

  void dispose() {
    _selectDateBloc.dispose();
    _fromDateContrl.dispose();
  }
}
