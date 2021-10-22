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
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/empty_text.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
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
            return const ErrorText();
          } else if (snapshot.hasData) {
            var masterModelList = snapshot.data;

            if (masterModelList!.length == 0) {
              return const NoData();
            }
            return Center(
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
                          const TitleWithFittedBox(text: "Party name"),
                          const DividerForTable(),
                          const TitleTable(text: "Address"),
                          const DividerForTable(),
                          const TitleTable(text: "Phone no"),
                          const DividerForTable(),
                          const TitleWithFittedBox(text: "Opening \n balance"),
                          const DividerForTable(),
                          const TitleTable(text: "Remark"),
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
                                  EditViewButton(
                                    onPressed: () {
                                      _edit(
                                        docId:
                                            masterModel.documentId.toString(),
                                      );
                                    },
                                  ),
                                  SubtitleForTable(
                                    text: masterModel.partyName,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: masterModel.address,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                      text: masterModel.phoneNumber),
                                  const DividerForTable(),
                                  _openingBalWithFittedBox(
                                    masterModel.openingBalance.toString(),
                                    masterModel.debitOrCredit,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(text: masterModel.remark),
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

  void _edit({required String docId}) {
    Push(
      context,
      pushTo: EditPartiesInMaster(
        docId: docId,
        type: this.type,
      ),
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
    return AppBarCustom(context).appbar(
      title: '${widget.type} table',
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }
}
