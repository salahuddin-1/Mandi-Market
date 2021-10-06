import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/billing_entry_table_BLOC.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
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

  @override
  void initState() {
    _billingEntryTableBLOC = new BillingEntryTableBLOC(widget.date);
    super.initState();
  }

  @override
  void dispose() {
    _billingEntryTableBLOC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: StreamBuilder<List<PurchaseBookModel>>(
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
                            final purchaseModel = list[index];
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                              width: 25.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  EditViewButton(
                                    onPressed: () {},
                                  ),
                                  SubtitleForTable(text: "${index + 1}"),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: purchaseModel.selectedTimestamp,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: purchaseModel.bepariName,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(text: purchaseModel.unit),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: purchaseModel.kacchiRakam,
                                  ),
                                  const DividerForTable(),
                                  const SubtitleForTable(text: '100000000'),
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
  }

  AppBar _appbar(BuildContext context) {
    return AppBarCustom(context).appbar(
      title: 'Billing entry',
      onPressedAdd: () {
        Push(
          context,
          pushTo: AddEntryInBillingEntry(),
        );
      },
      actions: [],
    );
  }
}
