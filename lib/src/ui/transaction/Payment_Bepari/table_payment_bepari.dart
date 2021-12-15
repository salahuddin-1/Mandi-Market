import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/Payment_Bepari_BLOC/get_entries_payment_bepari_BLOC.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/Payment_Bepari/view_edit_payment_bepari.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
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
  late final GetEntriesPaymentBepariBLOC _getEntriesPaymentBepariBLOC;

  late double _fontSize;

  @override
  void initState() {
    _fontSize = 9.sp;
    _getEntriesPaymentBepariBLOC = GetEntriesPaymentBepariBLOC();

    getAllBillsPrint();

    super.initState();
  }

  getAllBillsPrint() async {
    final listMap = await PaymentBepariSQLResources.getAllBills();
    print(listMap);
  }

  @override
  void dispose() {
    _getEntriesPaymentBepariBLOC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return await _getEntriesPaymentBepariBLOC.getEntries();
      },
      color: BLACK,
      child: Scaffold(
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
                      TitleWithFittedBox(
                        text: "Sr. no",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      TitleWithFittedBox(
                        text: "Bepari name",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      TitleTable(
                        text: "Date",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      TitleWithFittedBox(
                        text: "Amount\nto Pay",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      TitleWithFittedBox(
                        text: "Amount\nPaid",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      _BalanceAmount(text: "Balance\nAmount\nto Pay"),
                      const DividerForTable(),
                      TitleWithFittedBox(
                        text: "Amount\nto Receive",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      TitleWithFittedBox(
                        text: "Amount\nReceived",
                        fontSize: _fontSize,
                      ),
                      const DividerForTable(),
                      _BalanceAmount(text: "Balance\nAmount\nto Receive"),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<ApiResponse<List<PaymentBepariModel>>>(
                    stream: _getEntriesPaymentBepariBLOC.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return circularProgress();

                          case Status.ERROR:
                            return RetryCustom(
                              onPressed:
                                  _getEntriesPaymentBepariBLOC.getEntries(),
                            );

                          case Status.COMPLETED:
                            int length = snapshot.data!.data!.length;

                            if (length == 0) {
                              return const NoData();
                            }

                            return Container(
                              // height: 65.h,
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: length,
                                itemBuilder: (context, index) {
                                  PaymentBepariModel _paymentBepariModel =
                                      snapshot.data!.data![index];

                                  String serialNo = "${index + 1}";

                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 0.5.w,
                                    ),
                                    width: 25.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        EditViewButton(
                                          text: 'View',
                                          onPressed: () {
                                            Push(
                                              context,
                                              pushTo: ViewEditPaymentBepari(
                                                bepariName: _paymentBepariModel
                                                    .bepariName!,
                                                getEntriesPaymentBepariBLOC:
                                                    _getEntriesPaymentBepariBLOC,
                                              ),
                                            );
                                          },
                                        ),
                                        SubtitleForTable(
                                          text: serialNo,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleForTable(
                                          text: _paymentBepariModel.bepariName!,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleForTable(
                                          text: formatDateShort(
                                            DateTime.tryParse(
                                              _paymentBepariModel
                                                  .selectedTimestamp!,
                                            ),
                                          ),
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleWithFittedBox(
                                          text: _paymentBepariModel
                                              .pendingAmount!,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleWithFittedBox(
                                          text: _paymentBepariModel.paidAmount!,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleWithFittedBox(
                                          text:
                                              _paymentBepariModel.balAmtToPay!,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleWithFittedBox(
                                          text: _paymentBepariModel
                                              .receivingAmount!,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleWithFittedBox(
                                          text: _paymentBepariModel
                                              .receivedAmount!,
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        SubtitleWithFittedBox(
                                          text: _paymentBepariModel
                                              .balAmtToReceive!,
                                          fontSize: _fontSize,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          default:
                        }
                      }
                      return circularProgress();
                    },
                  ),
                ),
              ],
            ),
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

class _BalanceAmount extends StatelessWidget {
  final String text;

  const _BalanceAmount({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w600,
              color: BLACK,
              fontSize: 8.sp,
            ),
          ),
        ),
      ),
    );
  }
}
