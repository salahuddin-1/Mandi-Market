import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/Data_Holder/Purchase_book/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_bloc.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/stream_table.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/purchase_book/add_entry.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/empty_text.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
import 'package:sizer/sizer.dart';

class PurchaseBookTable extends StatefulWidget {
  final int fromDateHash;
  final int toDateHash;

  PurchaseBookTable({
    Key? key,
    required this.fromDateHash,
    required this.toDateHash,
  }) : super(key: key);

  @override
  _PurchaseBookTableState createState() => _PurchaseBookTableState();
}

class _PurchaseBookTableState extends State<PurchaseBookTable> {
  final _sagaBookBloc = new SagaBookBloc();
  late final PurchaseBookStreamTable _purchaseBookStreamTable;
  late final IsCalcParamsNullBLOC _isCalcParamsNullBLOC;

  @override
  void initState() {
    _purchaseBookStreamTable = PurchaseBookStreamTable(
      fromDateHash: widget.fromDateHash,
      toDateHash: widget.toDateHash,
    );
    // Setting value to access this instance in the children
    PurchaseBookDataHolder.setValue(_purchaseBookStreamTable);

    _isCalcParamsNullBLOC = IsCalcParamsNullBLOC();

    super.initState();
  }

  @override
  void dispose() {
    _sagaBookBloc.dispose();
    _purchaseBookStreamTable.dispose();
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
                appBar: _appbar(),
                body: StreamBuilder<List<PurchaseBookModel>>(
                  stream: _purchaseBookStreamTable.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const ErrorText();
                    } else if (snapshot.hasData) {
                      var purchaseModelList = snapshot.data;

                      if (purchaseModelList!.isEmpty) {
                        return const NoData();
                      }

                      return Stack(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 2.h, bottom: 5.h),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecorationFor.title(),
                                    width: 23.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const EmptyText(),
                                        TitleWithFittedBox(
                                          text: "Bepari",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Customer",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Pedi",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Mandi date",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Unit",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Rate",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Sub amount",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Discount",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleTable(
                                          text: "Commission\nRe 1/Unit",
                                          fontSize: _fontSize,
                                        ),
                                        const DividerForTable(),
                                        TitleWithFittedBox(
                                          text: "Net amount",
                                          fontSize: _fontSize,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 1.w),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: purchaseModelList.length,
                                        itemBuilder: (context, index) {
                                          var purchaseModel =
                                              purchaseModelList[index];

                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0.5.w),
                                            width: 25.w,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                EditViewButton(
                                                  onPressed: () {},
                                                ),
                                                SubtitleForTable(
                                                  text:
                                                      purchaseModel.bepariName,
                                                  fontSize: _fontSize,
                                                ),
                                                const DividerForTable(),
                                                SubtitleForTable(
                                                  text: purchaseModel
                                                      .customerName,
                                                  fontSize: _fontSize,
                                                ),
                                                const DividerForTable(),
                                                SubtitleForTable(
                                                  text: purchaseModel.pediName,
                                                  fontSize: _fontSize,
                                                ),
                                                const DividerForTable(),
                                                SubtitleForTable(
                                                  fontSize: _fontSize,
                                                  text: formatDateShort(
                                                    DateTime.tryParse(
                                                      purchaseModel
                                                          .selectedTimestamp,
                                                    ),
                                                  ),
                                                ),
                                                const DividerForTable(),
                                                SubtitleForTable(
                                                  text: purchaseModel.unit,
                                                  fontSize: _fontSize,
                                                ),
                                                const DividerForTable(),
                                                SubtitleWithFittedBox(
                                                  fontSize: _fontSize,
                                                  text: purchaseModel.rate,
                                                ),
                                                const DividerForTable(),
                                                SubtitleWithFittedBox(
                                                  fontSize: _fontSize,
                                                  text:
                                                      purchaseModel.kacchiRakam,
                                                ),
                                                const DividerForTable(),
                                                SubtitleWithFittedBox(
                                                  fontSize: _fontSize,
                                                  text: purchaseModel.discount,
                                                ),
                                                const DividerForTable(),
                                                SubtitleWithFittedBox(
                                                  fontSize: _fontSize,
                                                  text: purchaseModel.dalali,
                                                ),
                                                const DividerForTable(),
                                                SubtitleWithFittedBox(
                                                  fontSize: _fontSize,
                                                  text:
                                                      purchaseModel.pakkiRakam,
                                                ),
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
                          _DraggableScrollableSheet(
                              sagaBookBloc: _sagaBookBloc),
                        ],
                      );
                    }
                    return circularProgress();
                  },
                ),
              );
            default:
          }

          return SizedBox.shrink();
        }

        return circularProgress();
      },
    );
  }

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: "Purchase Book",
      actions: [
        IconButton(
          onPressed: () {
            PurchaseBookSQLResources().getEntries();
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        _addTransactionButton(),
      ],
    );
  }

  TextButton _addTransactionButton() {
    return TextButton(
      onPressed: () {
        Push(
          context,
          pushTo: AddEntryInPurchasebook(
            sagaBookBloc: _sagaBookBloc,
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Add",
              style: GoogleFonts.raleway(
                color: BLACK,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            TextSpan(text: " "),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(-2.0, -5.0),
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: BLACK,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _fontSize = 13;
}

// ---------------- Dragable Scrollable Sheet ---------------------

class _DraggableScrollableSheet extends StatelessWidget {
  const _DraggableScrollableSheet({
    Key? key,
    required SagaBookBloc sagaBookBloc,
  })  : _sagaBookBloc = sagaBookBloc,
        super(key: key);

  final SagaBookBloc _sagaBookBloc;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.3,
      // initialChildSize: 0.2,
      initialChildSize: 0.05,
      minChildSize: 0.05,
      builder: (context, cntrl) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CYAN900,
        ),
        child: ListView(
          controller: cntrl,
          children: [
            SizedBox(height: 1.2.h),
            Center(
              child: Container(
                height: 0.8.h,
                width: 18.w,
                decoration: BoxDecoration(
                  color: BLACK,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 7.w,
                vertical: 4.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "No. of Units :  ",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<int>(
                        stream: _sagaBookBloc.noOfUnits,
                        builder: (context, snapshot) {
                          return Flexible(
                            child: FittedBox(
                              child: Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5.sp),
                  Row(
                    children: [
                      Text(
                        "Gross Amount :  ",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<double>(
                        stream: _sagaBookBloc.grossAmount,
                        builder: (context, snapshot) {
                          return Flexible(
                            child: FittedBox(
                              child: Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CalcParamsNotSet extends StatelessWidget {
  final IsCalcParamsNullBLOC isCalcParamsNullBLOC;
  const CalcParamsNotSet({
    Key? key,
    required this.isCalcParamsNullBLOC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Calculation Parameters have not been set yet ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\nGo to Administrator -> Calculation Parameters and set the parameters\n",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  isCalcParamsNullBLOC.isCalcParamsNull();
                },
                child: Text(
                  "RETRY",
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar(context) {
    return AppBarCustom(context).appbar(
      title: "Important Message",
      actions: [
        SizedBox.shrink(),
      ],
    );
  }
}
