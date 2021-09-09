import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/master_list_pagination.dart';
import 'package:mandimarket/src/database/database_constants.dart';
import 'package:mandimarket/src/database/master_database.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/master_model.dart';
import 'package:mandimarket/src/resources/master_handler.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/master/add_master_party.dart';
import 'package:mandimarket/src/ui/master/edit_types_of_master.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class MasterTable extends StatefulWidget {
  final String type;

  MasterTable({Key? key, required this.type}) : super(key: key);

  @override
  _MasterTableState createState() => _MasterTableState();
}

class _MasterTableState extends State<MasterTable> {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;
  late final masterHandler = MasterHandler();
  late MasterPaginationBloc masterPagination;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    masterPagination = MasterPaginationBloc(type: widget.type);

    masterPagination.getUsers();

    addScrollListener();

    super.initState();
  }

  void addScrollListener() {
    scrollController.addListener(
      () {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;

        if (currentScroll + 1 > maxScroll) {
          masterPagination.getUsers();
        }
      },
    );
  }

  @override
  void dispose() {
    masterPagination.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      floatingActionButton: _floatingActionButton(context),
      body: StreamBuilder<List<MasterModel>>(
        stream: masterPagination.streamMasterModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else if (snapshot.data!.isEmpty || snapshot.data == null) {
            return _noData();
          } else if (snapshot.hasError) {
            return _errorWidget();
          } else if (snapshot.hasData) {
            //

            final masterList = snapshot.data;

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
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: masterList!.length,
                          itemBuilder: (context, index) {
                            final masterModel = masterList[index];

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                              width: 25.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _editViewButton(
                                    context,
                                    docId: masterModel.documentId ?? "",
                                  ),
                                  _subtitle(
                                    masterModel.partyName,
                                  ),
                                  _divider(),
                                  _subtitle(
                                    masterModel.address,
                                  ),
                                  _divider(),
                                  _subtitle(masterModel.phoneNumber),
                                  _divider(),
                                  _openingBalWithFittedBox(
                                    masterModel.openingBalance,
                                    masterModel.debitOrCredit,
                                  ),
                                  _divider(),
                                  _subtitle(masterModel.remark),
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

          return circularProgress();
        },
      ),
    );
  }

  Center _errorWidget() {
    return Center(
      child: Text("Something went wrong"),
    );
  }

  Widget _noData() {
    return Center(
      child: Text("No Data"),
    );
  }

  Expanded _openingBalWithFittedBox(String openBal, String debitOrCredit) {
    debitOrCredit = debitOrCredit.substring(0, 1);

    return Expanded(
      child: Center(
        child: FittedBox(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: openBal,
                  style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                TextSpan(text: " "),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0.0, -7.0),
                    child: Text(
                      debitOrCredit,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 8.sp,
                        color: debitOrCredit == 'C'
                            ? Colors.green[700]
                            : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
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

  InkWell _editViewButton(BuildContext context, {required String docId}) {
    return InkWell(
      onTap: () {
        Push(
          context,
          pushTo: EditMaster(
            type: widget.type,
            docId: docId,
            masterPaginationBloc: masterPagination,
          ),
        );
      },
      child: FittedBox(
        child: Container(
          alignment: Alignment.center,
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
          pushTo: AddMaster(
            type: widget.type,
            masterPaginationBloc: masterPagination,
          ),
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
      title: Text(
        '${widget.type} table',
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
          ),
        ),
      ],
      centerTitle: true,
    );
  }
}
