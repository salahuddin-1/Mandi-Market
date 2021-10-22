import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/Billing_Entry/select_dates_screen.dart';
import 'package:mandimarket/src/ui/transaction/Billing_Entry/table_billing_entry.dart';
import 'package:sizer/sizer.dart';

class BillingEntryDialog {
  late final _fromDateContrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime selectedDate;

  void dispose() {
    _fromDateContrl.dispose();
  }

  // DIALOG
  selectDate(BuildContext _context) {
    return showDialog(
      context: _context,
      builder: (newContext) => AlertDialog(
        title: Text('Select Date'),
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
              if (_formKey.currentState!.validate()) {
                Pop(newContext);

                Push(
                  _context,
                  pushTo: BillingEntryTable(
                    date: selectedDate,
                  ),
                );
              }
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 40.w,
              child: TextFormField(
                controller: _fromDateContrl,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Mandi date cannot be empty";
                  }
                },
                readOnly: true,
                onTap: () async {
                  await _gotoDates(newContext);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _gotoDates(BuildContext context) async {
    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDates(),
      ),
    );

    if (result != null) {
      final date = formatDate(DateTime.tryParse(result));

      _fromDateContrl.text = date;

      selectedDate = DateTime.tryParse(result)!;
    }
  }
}
