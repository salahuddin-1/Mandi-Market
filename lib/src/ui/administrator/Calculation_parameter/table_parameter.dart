import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/Data_Holder/Administrator/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Administrator_BLOC/calc_para_get_bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/administrator/Calculation_parameter/add_parameter.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class SetParameter extends StatefulWidget {
  @override
  _SetParameterState createState() => _SetParameterState();
}

class _SetParameterState extends State<SetParameter> {
  late final CalcParaGetBLOC _calcParaGetBLOC;

  @override
  void initState() {
    _calcParaGetBLOC = new CalcParaGetBLOC();

    CalcParamDataHolder.setValue(_calcParaGetBLOC);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: StreamBuilder<List<CalcParaModel>>(
        stream: _calcParaGetBLOC.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An Error Occured"),
            );
          } else if (snapshot.hasData) {
            var calcParaModelList = snapshot.data;

            if (calcParaModelList!.isEmpty) {
              return Center(
                child: Text("No Data"),
              );
            }
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    Container(
                      decoration: _boxDecorationForTitle(),
                      width: 23.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _emptyText(),
                          _title("Sr. no"),
                          _divider(),
                          _titleWithFittedBox("From"),
                          _divider(),
                          _title("To"),
                          _divider(),
                          _titleWithFittedBox("Discount (%)"),
                          _divider(),
                          _titleWithFittedBox("Commission"),
                          _divider(),
                          _titleWithFittedBox("Commision\nRe. 1 / unit"),
                          _divider(),
                          _titleWithFittedBox("Karkuni"),
                          _divider(),
                          _title("Remark"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: calcParaModelList.length,
                          itemBuilder: (context, index) {
                            var calcParaModel = calcParaModelList[index];

                            return Container(
                              decoration: index == 0
                                  ? BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  : null,
                              margin: EdgeInsets.only(left: 1.w),
                              width: 25.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _editViewButton(
                                    context,
                                    docId: "${calcParaModel.documentId}",
                                  ),
                                  _subtitle(
                                    '${calcParaModelList.length - index}',
                                  ),
                                  _divider(),
                                  _subtitle(
                                    formatDateShort(
                                      DateTime.tryParse(calcParaModel.fromDate),
                                    ),
                                  ),
                                  _divider(),
                                  _subtitle(
                                    formatDateShort(
                                      DateTime.tryParse(calcParaModel.toDate),
                                    ),
                                  ),
                                  _divider(),
                                  _subtitle(calcParaModel.discount),
                                  _divider(),
                                  _subtitle(calcParaModel.commission),
                                  _divider(),
                                  _subtitle(calcParaModel.commissionRe1),
                                  _divider(),
                                  _subtitle(calcParaModel.karkuni),
                                  _divider(),
                                  _subtitle(calcParaModel.remark),
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
      color: Colors.cyan[900],
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
              fontWeight: FontWeight.w500,
              color: Colors.white,
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
        // Push(
        //   context,
        //   pushTo: EditMaster(
        //     type: widget.type,
        //     docId: docId,
        //     masterPaginationBloc: masterPagination,
        //   ),
        // );
      },
      child: FittedBox(
        child: Container(
          alignment: Alignment.center,
          width: 25.w,
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
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.cyan[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        iconSize: 15.sp,
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text(
        "Parameter Data",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
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
          pushTo: AddParameter(),
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
}
