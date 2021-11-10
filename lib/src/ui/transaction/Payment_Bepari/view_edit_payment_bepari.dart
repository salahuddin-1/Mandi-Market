import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';

import 'package:sizer/sizer.dart';

class ViewEditPaymentBepari extends StatefulWidget {
  final String bepariName;
  const ViewEditPaymentBepari({
    Key? key,
    required this.bepariName,
  }) : super(key: key);

  @override
  _ViewEditPaymentBepariState createState() => _ViewEditPaymentBepariState();
}

class _ViewEditPaymentBepariState extends State<ViewEditPaymentBepari> {
  late final TextEditingController _dateCntrl;
  late final TextEditingController _bepariNameCntrl;
  late final TextEditingController _paymentCntrl;

  @override
  void initState() {
    _dateCntrl = new TextEditingController();
    _bepariNameCntrl = new TextEditingController();
    _paymentCntrl = new TextEditingController();

    _dateCntrl.text = formatDate(
      DateTime.now(),
    );

    _bepariNameCntrl.text = widget.bepariName;

    super.initState();
  }

  @override
  void dispose() {
    _dateCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: ListView(
        padding: EdgeInsets.only(bottom: 15.h, top: 1.5.h),
        children: [
          _date(),
          _bepariNameTextField(),
          SizedBox(height: 1.5.h),
          DataTable(
            columns: [
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Opening\nBalance",
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Amount\nPending  (Rs.)",
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Amount\nPaid  (Rs.)",
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(Text("2 Oct, 2021")),
                  DataCell(Text("20000")),
                  DataCell(Text("20000")),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          DataTable(
            columns: [
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Bills",
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Amount\nPending (Rs.)",
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    "Amount\nPaid (Rs.)",
                  ),
                ),
              ),
            ],
            rows: [
              for (int i = 0; i < 4; i++)
                DataRow(
                  cells: [
                    DataCell(Text("2 Oct, 2021")),
                    DataCell(Text("20000")),
                    DataCell(Text("20000")),
                  ],
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Enter below the amount to pay (Rs.)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Divider(
            thickness: 1,
            height: 0,
          ),
          _enterPayingTextField(),
          SizedBox(height: 6.h),
        ],
      ),
      bottomSheet: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount Pending : ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    "Rs.  1000000",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Paid Amount : ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    "Rs.  1000000",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  _date() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        controller: _dateCntrl,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date",
        ),
      ),
    );
  }

  _enterPayingTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        controller: _paymentCntrl,
        decoration: InputDecoration(
          labelText: "Paying Amount",
        ),
      ),
    );
  }

  _bepariNameTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        controller: _bepariNameCntrl,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Bepari Name",
        ),
      ),
    );
  }

  _appbar() {
    return AppBarCustom(context).appbar(
      title: "View ",
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.check),
        ),
      ],
    );
  }
}
