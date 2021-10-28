import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/billing_entry_table_BLOC.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/Purchase_Book/table.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/empty_text.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
import 'package:sizer/sizer.dart';

import 'add_entry_in_billing_entry.dart';

class BillingEntryTable extends StatefulWidget {
  final DateTime date;
  const BillingEntryTable({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _BillingEntryTableState createState() => _BillingEntryTableState();
}

class _BillingEntryTableState extends State<BillingEntryTable> {
  late final BillingEntryTableBLOC _billingEntryTableBLOC;
  late final IsCalcParamsNullBLOC _isCalcParamsNullBLOC;

  @override
  void initState() {
    _billingEntryTableBLOC = new BillingEntryTableBLOC(
      widget.date,
    );

    _isCalcParamsNullBLOC = IsCalcParamsNullBLOC();
    super.initState();
  }

  @override
  void dispose() {
    _billingEntryTableBLOC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<bool>>(
      stream: _isCalcParamsNullBLOC.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Container(
                color: WHITE,
                child: circularProgress(),
              );

            case Status.ERROR:
              return ErrorText();

            case Status.COMPLETED:
              bool isCalcParamsNull = snapshot.data!.data!;

              if (isCalcParamsNull) {
                return CalcParamsNotSet(
                  isCalcParamsNullBLOC: _isCalcParamsNullBLOC,
                );
              }
              return Scaffold(
                appBar: _appbar(context),
                body: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecorationFor.title(),
                          height: 73.h,
                          width: 23.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const EmptyText(),
                              const TitleWithFittedBox(text: "Sr no."),
                              const DividerForTable(),
                              const TitleTable(text: "Mandi date"),
                              const DividerForTable(),
                              const TitleTable(text: "Bepari name"),
                              const DividerForTable(),
                              const TitleWithFittedBox(text: "No. of units"),
                              const DividerForTable(),
                              const TitleWithFittedBox(text: "Sub amount"),
                              const DividerForTable(),
                              const TitleTable(text: "Net amount"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 73.h,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            child: StreamBuilder<List<BillingEntryModel>>(
                              stream: _billingEntryTableBLOC.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const ErrorText();
                                } else if (snapshot.hasData) {
                                  final list = snapshot.data;

                                  if (list!.length == 0) {
                                    return const NoData();
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      final billingEntryModel = list[index];

                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0.5.w),
                                        width: 25.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            EditViewButton(
                                              onPressed: () {
                                                Push(
                                                  context,
                                                  pushTo:
                                                      AddEntryInBillingEntry(
                                                    date: widget.date,
                                                    isEdit: true,
                                                    billingEntryTableBLOC:
                                                        _billingEntryTableBLOC,
                                                    documentId:
                                                        billingEntryModel
                                                            .documentId,
                                                  ),
                                                );
                                              },
                                            ),
                                            SubtitleForTable(
                                                text: "${index + 1}"),
                                            const DividerForTable(),
                                            SubtitleForTable(
                                              text: formatDateShort(
                                                DateTime.tryParse(
                                                  billingEntryModel
                                                      .selectedTimestamp,
                                                ),
                                              ),
                                            ),
                                            const DividerForTable(),
                                            SubtitleForTable(
                                              text:
                                                  billingEntryModel.bepariName,
                                            ),
                                            const DividerForTable(),
                                            SubtitleForTable(
                                                text: billingEntryModel.unit),
                                            const DividerForTable(),
                                            SubtitleForTable(
                                              text: billingEntryModel.subAmount,
                                            ),
                                            const DividerForTable(),
                                            SubtitleForTable(
                                              text: billingEntryModel.netAmount,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }

                                return circularProgress();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

            default:
          }
        }
        return circularProgress();
      },
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBarCustom(context).appbar(
      title: 'Billing entry',
      onPressedAdd: () {
        Push(
          context,
          pushTo: AddEntryInBillingEntry(
            date: widget.date,
            billingEntryTableBLOC: _billingEntryTableBLOC,
          ),
        );
      },
      actions: [],
    );
  }
}
