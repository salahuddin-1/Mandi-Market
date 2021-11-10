import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/Data_Holder/Administrator/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Administrator_BLOC/calc_para_get_bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/administrator/Calculation_parameter/add_parameter.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/empty_text.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
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
                      decoration: BoxDecorationFor.title(),
                      width: 23.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const EmptyText(),
                          const TitleTable(text: "Sr. no"),
                          const DividerForTable(),
                          const TitleWithFittedBox(text: "From"),
                          const DividerForTable(),
                          const TitleTable(text: "To"),
                          const DividerForTable(),
                          const TitleWithFittedBox(text: "Discount (%)"),
                          const DividerForTable(),
                          const TitleWithFittedBox(text: "Commission"),
                          const DividerForTable(),
                          const TitleWithFittedBox(
                            text: "Commision\nRe. 1 / unit",
                          ),
                          const DividerForTable(),
                          const TitleWithFittedBox(text: "Karkuni"),
                          const DividerForTable(),
                          const TitleTable(text: "Remark"),
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
                                  EditViewButton(
                                    onPressed: () {
                                      Push(
                                        context,
                                        pushTo: AddParameter(
                                          isEdit: true,
                                          documentId: calcParaModel.documentId!,
                                        ),
                                      );
                                    },
                                  ),
                                  SubtitleForTable(
                                    text: '${calcParaModelList.length - index}',
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: formatDateShort(
                                      DateTime.tryParse(calcParaModel.fromDate),
                                    ),
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: formatDateShort(
                                      DateTime.tryParse(calcParaModel.toDate),
                                    ),
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: calcParaModel.discount,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: calcParaModel.commission,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: calcParaModel.commissionRe1,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: calcParaModel.karkuni,
                                  ),
                                  const DividerForTable(),
                                  SubtitleForTable(
                                    text: calcParaModel.remark,
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
            );
          }
          return circularProgress();
        },
      ),
    );
  }

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: "Parameter Data",
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
