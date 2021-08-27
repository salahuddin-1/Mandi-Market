import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/master/bepari/add_bepari.dart';
import 'package:mandimarket/src/ui/master/bepari/edit_bepari.dart';
import 'package:sizer/sizer.dart';

class BepariTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      floatingActionButton: _floatingActionButton(context),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              Container(
                decoration: _boxDecorationForTitle(),
                height: 73.h,
                width: 23.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _emptyText(),
                    _titleWithFittedBox("Party name"),
                    _divider(),
                    _title("Address"),
                    _divider(),
                    _title("Phone no"),
                    _divider(),
                    _titleWithFittedBox("Opening \n balance"),
                    _divider(),
                    _title("Remark"),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 73.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                        width: 25.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _editViewButton(context),
                            _subtitle(
                              "Salahuddin Mohammed Hussain Shaikh Rabia",
                            ),
                            _divider(),
                            _subtitle(
                              "Plot no 1, Mandli taalv, opp atlake hotel, near rachna apt, thane 401101",
                            ),
                            _divider(),
                            _subtitle("8898911744"),
                            _divider(),
                            _subtitleWithFittedBox(),
                            _divider(),
                            _subtitle("Cheque given"),
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

  Expanded _subtitleWithFittedBox() {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "100000000.00",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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

  BoxDecoration _boxDecorationForTitle() {
    return BoxDecoration(
      color: Colors.yellow[700],
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    );
  }

  Expanded _titleWithFittedBox(String text) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w800,
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
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _editViewButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Push(
          context,
          pushTo: EditBepari(),
        );
      },
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.only(left: 10),
          width: 25.w,
          // color: Colors.red,
          child: Text(
            "Edit/View",
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
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
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Push(
          context,
          pushTo: AddBepari(),
        );
      },
      child: Icon(Icons.add),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: TextField(
        onTap: () {
          print("Search");
        },
        readOnly: true,
        decoration: InputDecoration(
          hintText: "Search",
          suffixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
