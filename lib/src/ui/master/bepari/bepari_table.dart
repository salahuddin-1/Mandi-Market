import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/database/bepari_database.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/bepari_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/master/bepari/add_bepari.dart';
import 'package:mandimarket/src/ui/master/bepari/edit_bepari.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class BepariTable extends StatelessWidget {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      floatingActionButton: _floatingActionButton(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: BepariDatabase.getAllBepari(ownersPhoneNumber),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: circularProgressForButton());
          }

          if (snapshot.data!.docs.isEmpty) {
            return _noData();
          }
          if (snapshot.hasData) {
            List<BepariModel> bepariList = _getBepariModelList(snapshot.data!);

            return Center(
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
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final bepariModel = bepariList[index];

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                              width: 25.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _editViewButton(context),
                                  _subtitle(
                                    bepariModel.partyName,
                                  ),
                                  _divider(),
                                  _subtitle(
                                    bepariModel.address,
                                  ),
                                  _divider(),
                                  _subtitle(bepariModel.phoneNumber),
                                  _divider(),
                                  _openingBalWithFittedBox(
                                    bepariModel.openingBalance,
                                  ),
                                  _divider(),
                                  _subtitle(bepariModel.remark),
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
            );
          }

          return circularProgressForButton();
        },
      ),
    );
  }

  List<BepariModel> _getBepariModelList(QuerySnapshot snapshot) {
    final bepariList = snapshot.docs.map(
      (doc) {
        BepariModel bepariModel = BepariModel.fromDocument(doc);
        return bepariModel;
      },
    ).toList();
    return bepariList;
  }

  Widget _noData() {
    return Center(
      child: Text("No Data"),
    );
  }

  Expanded _openingBalWithFittedBox(String openBal) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              openBal,
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
          alignment: Alignment.center,
          // padding: EdgeInsets.only(left: 10),
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

  AppBar _appbar(context) {
    return AppBar(
      elevation: 10,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () {
          Pop(context);
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
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
      centerTitle: true,
    );
  }
}
