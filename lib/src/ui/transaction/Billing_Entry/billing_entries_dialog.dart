import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/Billing_Entry/table_billing_entry.dart';
import 'package:mandimarket/src/widgets/select_date.dart';
import 'package:sizer/sizer.dart';

class BillingEntryDialog {
  late final _fromDateContrl = new TextEditingController(
    text: formatDate(
      DateTime.now(),
    ),
  );

  late final _selectDateBloc = new SelectDateBloc();

  // DIALOG
  selectDate(BuildContext _context) {
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
            onPressed: () {
              Pop(newContext);

              Push(
                _context,
                pushTo: BillingEntryTable(
                  date: _selectDateBloc.fromDateValue!,
                ),
              );
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
        Text("Mandi date : "),
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

  Future<void> _onTapFromDate(
    BuildContext newContext,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await showDate(
      newContext,
      title: 'Select',
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
