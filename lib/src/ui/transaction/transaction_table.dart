import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/transaction/add_a_transaction.dart';
import 'package:sizer/sizer.dart';

class TransactionTable extends StatefulWidget {
  const TransactionTable({Key? key}) : super(key: key);

  @override
  _TransactionTableState createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      // floatingActionButton: _floatingActionButton(),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              Container(
                decoration: _boxDecorationForTitle(),
                // height: 81.h,
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
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 1.w),
                  // height: 81.h,
                  child: ListView.builder(
                    // controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                        width: 25.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _editViewButton(
                              context,
                              docId: "",
                            ),
                            _subtitle('Rehan Asfaq Siddiqui Zahir Chunawala'),
                            _divider(),
                            _subtitle('Faizal'),
                            _divider(),
                            _subtitle('Faizal'),
                            _divider(),
                            _subtitle('2 Sept, 2021'),
                            _divider(),
                            _subtitle('20'),
                            _divider(),
                            _subtitleWithFittedBox('10000000000'),
                            _divider(),
                            _subtitleWithFittedBox('5000000'),
                            _divider(),
                            _subtitleWithFittedBox('500'),
                            _divider(),
                            _subtitleWithFittedBox('20000'),
                            _divider(),
                            _subtitleWithFittedBox('1000000'),
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
          onPressed: () {},
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
          pushTo: AddTransaction(),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Add",
              style: GoogleFonts.raleway(
                color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Push(
          context,
          pushTo: AddTransaction(),
        );
      },
      child: Icon(Icons.add),
    );
  }

  BoxDecoration _boxDecorationForTitle() {
    return BoxDecoration(
      color: Colors.yellow[700],
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
