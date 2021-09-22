import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/Data_Holder/Purchase_book/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_bloc.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/stream_table.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/purchase_book/add_entry.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class PurchaseBookTable extends StatefulWidget {
  const PurchaseBookTable({Key? key}) : super(key: key);

  @override
  _PurchaseBookTableState createState() => _PurchaseBookTableState();
}

class _PurchaseBookTableState extends State<PurchaseBookTable> {
  final _sagaBookBloc = new SagaBookBloc();
  late final PurchaseBookStreamTable _purchaseBookStreamTable;

  @override
  void initState() {
    _purchaseBookStreamTable = PurchaseBookStreamTable();
    // Setting value to access this instance in the children
    PurchaseBookDataHolder.setValue(_purchaseBookStreamTable);

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
    return Scaffold(
      appBar: _appbar(),
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 2.h, bottom: 5.h),
              child: Row(
                children: [
                  Container(
                    decoration: _boxDecorationForTitle(),
                    width: 23.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _emptyText(),
                        _titleWithFittedBox("Bepari name"),
                        _divider(),
                        _title("Customer"),
                        _divider(),
                        _title("Pedi"),
                        _divider(),
                        _title("Mandi date"),
                        _divider(),
                        _title("Unit"),
                        _divider(),
                        _title("Rate"),
                        _divider(),
                        _title("Amount"),
                        _divider(),
                        _title("Discount"),
                        _divider(),
                        _title("Commission\nRe 1/Unit"),
                        _divider(),
                        _titleWithFittedBox("Net amount"),
                      ],
                    ),
                  ),
                  StreamBuilder<List<PurchaseBookModel>>(
                    stream: _purchaseBookStreamTable.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var purchaseModelList = snapshot.data;

                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 1.w),
                            child: ListView.builder(
                              // controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: purchaseModelList!.length,
                              itemBuilder: (context, index) {
                                var purchaseModel = purchaseModelList[index];

                                return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 0.5.w),
                                  width: 25.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _editViewButton(
                                        context,
                                        docId: "",
                                      ),
                                      _subtitle(purchaseModel.bepariName),
                                      _divider(),
                                      _subtitle(purchaseModel.customerName),
                                      _divider(),
                                      _subtitle(purchaseModel.pediName),
                                      _divider(),
                                      _subtitle(
                                        purchaseModel.selectedTimestamp,
                                      ),
                                      _divider(),
                                      _subtitle(purchaseModel.unit),
                                      _divider(),
                                      _subtitleWithFittedBox(
                                        purchaseModel.rate,
                                      ),
                                      _divider(),
                                      _subtitleWithFittedBox(
                                        purchaseModel.kacchiRakam,
                                      ),
                                      _divider(),
                                      _subtitleWithFittedBox(
                                        purchaseModel.discount,
                                      ),
                                      _divider(),
                                      _subtitleWithFittedBox(
                                          purchaseModel.dalali),
                                      _divider(),
                                      _subtitleWithFittedBox(
                                        purchaseModel.pakkiRakam,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }

                      return circularProgress();
                    },
                  ),
                ],
              ),
            ),
          ),
          _draggableScrollableSheet(),
        ],
      ),
    );
  }

  DraggableScrollableSheet _draggableScrollableSheet() {
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
          color: YELLOW700,
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

  Text _emptyText() {
    return Text(
      "",
      style: TextStyle(
        fontSize: 11,
      ),
    );
  }

  InkWell _editViewButton(BuildContext context, {required String docId}) {
    return InkWell(
      onTap: () {},
      child: FittedBox(
        child: Container(
          alignment: Alignment.center,
          width: 25.w,
          // color: Colors.red,
          child: Text(
            "Edit/View",
            style: TextStyle(
              fontSize: 10,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text("Purchase Book"),
      centerTitle: false,
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

  BoxDecoration _boxDecorationForTitle() {
    return BoxDecoration(
      color: YELLOW700,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }

  double _fontSize = 13;

  Expanded _titleWithFittedBox(String text) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w800,
              fontSize: _fontSize,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _subtitle(String text) {
    return Expanded(
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _subtitleWithFittedBox(String text) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
        ),
      ),
    );
  }

  Divider _divider() => Divider(thickness: 1);

  Expanded _title(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.raleway(
            fontSize: _fontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
