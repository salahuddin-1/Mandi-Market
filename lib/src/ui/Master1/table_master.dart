import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/Data_Holder/Master/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Master_BLOC/feed_entries_to_master.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/Master1/add_party.dart';
import 'package:mandimarket/src/ui/Master1/edit_party.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/empty_text.dart';
import 'package:sizer/sizer.dart';

class MasterTable extends StatefulWidget {
  final String type;

  MasterTable({Key? key, required this.type}) : super(key: key);

  @override
  _MasterTableState createState() => _MasterTableState();
}

class _MasterTableState extends State<MasterTable> {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;
  late final FeedEntriesToMasterBLOC _feedEntriesToMasterBLOC;
  late String type = widget.type.toLowerCase();

  @override
  void initState() {
    _feedEntriesToMasterBLOC = FeedEntriesToMasterBLOC(widget.type);

    // Injecting to allow access to all children
    MasterDataHolder.setValue(_feedEntriesToMasterBLOC);
    super.initState();
  }

  @override
  void dispose() {
    _feedEntriesToMasterBLOC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      floatingActionButton: _floatingActionButton(context),
      body: StreamBuilder<List<MasterModel>>(
        stream: _feedEntriesToMasterBLOC.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorWidget();
          } else if (snapshot.hasData) {
            var masterModelList = snapshot.data;

            if (masterModelList!.length == 0) {
              return _noData();
            }
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
                          const EmptyText(),
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
                          itemCount: masterModelList.length,
                          itemBuilder: (context, index) {
                            var masterModel = masterModelList[index];

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                              width: 25.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _editViewButton(
                                    context,
                                    docId: masterModel.documentId.toString(),
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
                                    masterModel.openingBalance.toString(),
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
                    color: BLACK,
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

  BoxDecoration _boxDecorationForTitle() {
    return BoxDecoration(
      color: YELLOW700,
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
          pushTo: EditPartiesInMaster(
            docId: docId,
            type: this.type,
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
            type: this.type,
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
