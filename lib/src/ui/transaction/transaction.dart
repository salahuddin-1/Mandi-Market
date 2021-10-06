import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:sizer/sizer.dart';
import 'Billing_Entry/billing_entries_dialog.dart';
import 'Billing_Entry/table_billing_entry.dart';
import 'purchase_book/table.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late final TextEditingController fromDateContrl;
  late final TextEditingController toDateContrl;
  late final SelectDateBloc selectDateBloc;
  late final BillingEntryDialog _billingEntryDialog;

  @override
  void initState() {
    fromDateContrl = new TextEditingController(
      text: formatDate(
        DateTime.now(),
      ),
    );
    toDateContrl = new TextEditingController(
      text: formatDate(
        DateTime.now(),
      ),
    );
    selectDateBloc = new SelectDateBloc();

    _billingEntryDialog = BillingEntryDialog();

    super.initState();
  }

  @override
  void dispose() {
    fromDateContrl.dispose();
    toDateContrl.dispose();
    selectDateBloc.dispose();

    _billingEntryDialog.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        padding: EdgeInsets.only(top: 1.5.h, bottom: 2.h),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _leftChild(
                      "Saga / Purchase Book",
                      // onTap: () {
                      //   Push(
                      //     context,
                      //     pushTo: TransactionTable(),
                      //   );
                      // },
                      onTap: () => onTapSagaBook(),
                    ),
                    _rightChild(
                      "Billing entry",
                      onTap: () {
                        _billingEntryDialog.selectDate(context);
                        // Push(
                        //   context,
                        //   pushTo: BillingEntry(),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _leftChild(
                      "Payment Bepari",
                      onTap: () {
                        omTapTransactionType(context, "Gawal");
                      },
                    ),
                    _rightChild(
                      "Payment Gawaal",
                      onTap: () {
                        omTapTransactionType(context, "Pedi");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _leftChild(
                      "Receipt Customer",
                      onTap: () {
                        omTapTransactionType(context, "Other Parties");
                      },
                    ),
                    _rightChild(
                      "Pedi",
                      onTap: () {
                        omTapTransactionType(context, "Gawal Account");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _leftChild(
                      "Adjustment",
                      onTap: () {
                        omTapTransactionType(context, "Dawan");
                      },
                    ),
                    _rightChild(
                      "Other Parties Entry",
                      onTap: () {
                        omTapTransactionType(context, "Pedi");
                      },
                    )
                    // _rightChild("Gawal Account"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _leftChild(
                      "Expenses",
                      onTap: () {
                        omTapTransactionType(context, "Dawan");
                      },
                    ),
                    Expanded(
                      child: Text(""),
                    ),
                    // _rightChild("Gawal Account"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  omTapTransactionType(BuildContext context, String type) {
    // Push(
    //   context,
    //   pushTo: MasterTable(
    //     type: type,
    //   ),
    // );
  }

  onTapSagaBook() {
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
              var toDate = calculateDateHash(selectDateBloc.toDateValue!);
              var fromDate = calculateDateHash(selectDateBloc.fromDateValue!);

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

  getusers() {}

  Row _toDate(BuildContext newContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("To : "),
        StreamBuilder<DateTime?>(
          stream: selectDateBloc.streamToDate,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 40.w,
              child: TextFormField(
                controller: toDateContrl,
                readOnly: true,
                onTap: () async {
                  await onTapToDate(newContext, snapshot);
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
          stream: selectDateBloc.streamFromDate,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 40.w,
              child: TextFormField(
                controller: fromDateContrl,
                readOnly: true,
                onTap: () async {
                  await onTapFromDate(newContext, snapshot);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> onTapToDate(
    BuildContext newContext,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await showDate(
      newContext,
      title: 'To',
      selectedDate: snapshot.data!,
    );
    selectDateBloc.selectToDate(date!);
    var pickedDate = formatDate(date);

    toDateContrl.text = pickedDate;
  }

  Future<void> onTapFromDate(
    BuildContext newContext,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await showDate(
      newContext,
      title: 'From',
      selectedDate: snapshot.data!,
    );
    selectDateBloc.selectFromDate(date!);
    var pickedDate = formatDate(date);

    fromDateContrl.text = pickedDate;
  }

  Future<DateTime?> showDate(
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

  Expanded _rightChild(String title, {Function? onTap}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        ),
        // height: 14.h,
        margin: EdgeInsets.only(left: 1.5.w, right: 3.w),
        child: Material(
          color: YELLOW700,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              onTap!();
            },
            child: Ink(
              child: Center(
                child: Text(
                  title,
                  textScaleFactor: 0.81.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _leftChild(String title, {Function? onTap}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        ),
        // height: 14.h,
        margin: EdgeInsets.only(left: 3.w, right: 1.5.w),
        child: Material(
          color: YELLOW700,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              onTap!();
            },
            child: Ink(
              child: Center(
                child: Text(
                  title,
                  textScaleFactor: 0.81.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        'Mandi Market',
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
