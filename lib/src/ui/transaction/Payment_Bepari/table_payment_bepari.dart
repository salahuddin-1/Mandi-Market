import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/Payment_Bepari_BLOC/get_entries_payment_bepari_BLOC.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/Payment_Bepari/view_edit_payment_bepari.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/empty_text.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
import 'package:sizer/sizer.dart';

import 'history_payment_bepari.dart';

class PaymentBepari extends StatefulWidget {
  final String title;
  PaymentBepari({Key? key, required this.title}) : super(key: key);

  @override
  _PaymentBepariState createState() => _PaymentBepariState();
}

class _PaymentBepariState extends State<PaymentBepari> {
  @override
  void initState() {
    // TODO: implement initState

    GetEntriesPaymentBepariBLOC();
    getBills();

    super.initState();
  }

  getBills() async {
    // print(await PaymentBepariSQLResources.getAllBills());

    final billMap =
        await PaymentBepariSQLResources.getBillByBepariName('Bepari New 01');

    if (billMap != null) {
      final billModel = PaymentBepariModel.fromJson(billMap);

      print(billMap);
    } else {
      print('null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              Container(
                decoration: BoxDecorationFor.title(),
                // height: 65.h,
                width: 23.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const EmptyText(),
                    const TitleWithFittedBox(text: "Sr. no"),
                    const DividerForTable(),
                    const TitleWithFittedBox(text: "Bepari name"),
                    const DividerForTable(),
                    const TitleTable(text: "Date"),
                    const DividerForTable(),
                    const TitleWithFittedBox(text: "Amount\nPending\n(Dena)"),
                    const DividerForTable(),
                    const TitleTable(text: "Paid\nAmount"),
                    const DividerForTable(),
                    const TitleTable(text: "Amount\nto Receive\n(Lena)"),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  // height: 65.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                        width: 25.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            EditViewButton(
                              text: 'View',
                              onPressed: () {
                                Push(
                                  context,
                                  pushTo: ViewEditPaymentBepari(
                                    bepariName: 'Zoro',
                                  ),
                                );
                              },
                            ),
                            SubtitleForTable(text: '1'),
                            const DividerForTable(),
                            SubtitleForTable(text: 'Zoro'),
                            const DividerForTable(),
                            SubtitleForTable(text: '2 Oct, 2021'),
                            const DividerForTable(),
                            SubtitleWithFittedBox(text: '100000000'),
                            const DividerForTable(),
                            SubtitleWithFittedBox(text: '100000000'),
                            const DividerForTable(),
                            SubtitleWithFittedBox(text: '0'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appbar() {
    return AppBarCustom(context).appbar(
      title: this.widget.title,
      actions: [
        TextButton(
          onPressed: () async {
            final rows = await PaymentBepariSQLResources.deleteAll();

            print(rows);
          },
          child: Text(
            "Delete All",
            style: TextStyle(
              color: BLACK,
              fontSize: 11.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Push(
              context,
              pushTo: HistoryPaymentBepari(),
            );
          },
          child: Text(
            "Logs",
            style: TextStyle(
              color: BLACK,
              fontSize: 11.sp,
            ),
          ),
        ),
      ],
    );
  }
}
