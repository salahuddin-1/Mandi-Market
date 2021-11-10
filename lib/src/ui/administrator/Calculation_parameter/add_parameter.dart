import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Administrator_BLOC/calc_para_get_bloc.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/Administrator/handle_calc_param.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/validation/parameter_validation.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/dialogs.dart';
import 'package:mandimarket/src/widgets/select_date.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
import 'package:sizer/sizer.dart';

class AddParameter extends StatefulWidget {
  final bool isEdit;
  final String? documentId;

  const AddParameter({
    Key? key,
    this.isEdit = false,
    this.documentId,
  }) : super(key: key);

  @override
  _AddParameterState createState() => _AddParameterState();
}

class _AddParameterState extends State<AddParameter> {
  final _formKey = GlobalKey<FormState>();

  late final SelectDateBloc _selectDateBloc;

  late final TextEditingController _fromDateCntrl;
  late final TextEditingController _toDateCntrl;
  late final TextEditingController _commisionCntrl;
  late final TextEditingController _discountCntrl;
  late final TextEditingController _remarkCntrl;
  late final TextEditingController _karkuniCntrl;
  late final TextEditingController _commisionRe1Cntrl;

  late final CalcParaGetParaByDocIdBLOC _calcParaGetParaByDocIdBLOC;
  CalcParaModel? _calcParaModel;
  late bool isEdit;

  @override
  void initState() {
    isEdit = widget.isEdit && widget.documentId != null;

    _commisionCntrl = new TextEditingController();
    _discountCntrl = new TextEditingController();
    _remarkCntrl = new TextEditingController();
    _karkuniCntrl = new TextEditingController();
    _commisionRe1Cntrl = new TextEditingController();
    _fromDateCntrl = new TextEditingController();
    _toDateCntrl = new TextEditingController();

    if (isEdit) {
      _calcParaGetParaByDocIdBLOC = CalcParaGetParaByDocIdBLOC(
        widget.documentId!,
      );
    }

    if (isEdit == false) {
      _initialiseDates();
      _selectDateBloc = new SelectDateBloc();
    }

    super.initState();
  }

  void _initialiseDates() {
    _fromDateCntrl.text = formatDate(DateTime.now());
    _toDateCntrl.text = formatDate(DateTime.now());
  }

  @override
  void dispose() {
    _commisionCntrl.dispose();
    _discountCntrl.dispose();
    _remarkCntrl.dispose();
    _karkuniCntrl.dispose();
    _commisionRe1Cntrl.dispose();
    _selectDateBloc.dispose();

    if (isEdit) {
      _calcParaGetParaByDocIdBLOC.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: body(),
    );
  }

  Widget body() {
    return StreamBuilder<ApiResponse<CalcParaModel>>(
      stream: isEdit ? _calcParaGetParaByDocIdBLOC.stream : null,
      builder: (context, snapshot) {
        if (isEdit) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return circularProgress();

              case Status.ERROR:
                return const ErrorText();

              case Status.COMPLETED:
                if (_calcParaModel == null) {
                  _calcParaModel = snapshot.data!.data;
                  _setFieldsForEditing(_calcParaModel!);
                }
                break;

              default:
            }
          } else {
            return circularProgress();
          }
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  _fromDateTextField(),
                  _toDateTextField(),
                  _discountTextField(),
                  _commissionRe1TextField(),
                  _karkurniTextField(),
                  _commissionTextField(),
                  _remarkTextField(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _fromDateTextField() {
    return StreamBuilder<DateTime?>(
      stream: _selectDateBloc.streamFromDate,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return TextFormField(
            controller: _fromDateCntrl,
            onTap: () {
              showFromDate(snapshot.data!);
            },
            readOnly: true,
            decoration: InputDecoration(
              labelText: "From Date",
              focusColor: Colors.black,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          );

        return SizedBox();
      },
    );
  }

  showFromDate(DateTime selectedDate) async {
    final date = await showDate(
      context,
      title: 'From',
      selectedDate: selectedDate,
    );

    if (date != null) {
      final fDate = formatDate(date);
      _fromDateCntrl.text = fDate;
      _selectDateBloc.selectFromDate(date);
    }
  }

  showToDate(DateTime selectedDate) async {
    final date = await showDate(
      context,
      title: 'To',
      selectedDate: selectedDate,
    );

    if (date != null) {
      final fDate = formatDate(date);
      _toDateCntrl.text = fDate;
      _selectDateBloc.selectToDate(date);
    }
  }

  _toDateTextField() {
    return StreamBuilder<DateTime?>(
      stream: _selectDateBloc.streamToDate,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return TextFormField(
            controller: _toDateCntrl,
            onTap: () {
              showToDate(snapshot.data!);
            },
            readOnly: true,
            decoration: InputDecoration(
              labelText: "To Date",
            ),
          );

        return SizedBox();
      },
    );
  }

  TextFormField _discountTextField() {
    return TextFormField(
      controller: _discountCntrl,
      keyboardType: TextInputType.phone,
      validator: (val) => ParameterValidation.discount(val!),
      decoration: InputDecoration(
        labelText: "Discount  (%)",
      ),
    );
  }

  TextFormField _commissionTextField() {
    return TextFormField(
      controller: _commisionCntrl,
      keyboardType: TextInputType.phone,
      validator: (val) => ParameterValidation.commission(val!),
      decoration: InputDecoration(
        labelText: "Commission  (Rs.)",
      ),
    );
  }

  TextFormField _karkurniTextField() {
    return TextFormField(
      controller: _karkuniCntrl,
      keyboardType: TextInputType.phone,
      validator: (val) => ParameterValidation.karkuni(val!),
      decoration: InputDecoration(
        labelText: "Karkuni  (Rs.)",
      ),
    );
  }

  TextFormField _remarkTextField() {
    return TextFormField(
      controller: _remarkCntrl,
      decoration: InputDecoration(
        labelText: "Remark",
      ),
    );
  }

  TextFormField _commissionRe1TextField() {
    return TextFormField(
      controller: _commisionRe1Cntrl,
      keyboardType: TextInputType.phone,
      validator: (val) => ParameterValidation.commissionRe1(val!),
      decoration: InputDecoration(
        labelText: "Commission Re. 1 / unit",
      ),
    );
  }

  void _setFieldsForEditing(CalcParaModel calcParaModel) {
    _selectDateBloc = new SelectDateBloc(
      fromDate: DateTime.tryParse(calcParaModel.fromDate),
      toDate: DateTime.tryParse(calcParaModel.toDate),
    );

    _fromDateCntrl.text = formatDate(
      DateTime.tryParse(calcParaModel.fromDate),
    );

    _toDateCntrl.text = formatDate(
      DateTime.tryParse(calcParaModel.toDate),
    );

    _discountCntrl.text = calcParaModel.discount;
    _commisionRe1Cntrl.text = calcParaModel.commissionRe1;
    _karkuniCntrl.text = calcParaModel.karkuni;
    _commisionCntrl.text = calcParaModel.commission;
    _remarkCntrl.text = calcParaModel.remark;
  }

  _delete() {
    DialogsCustom.delete(
      context,
      onPressedYes: () {
        HandleCalcParam(context).deleteParameter(
          widget.documentId!,
        );
      },
    );
  }

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: isEdit ? "Edit Parameter" : "Add Parameter",
      actions: [
        widget.isEdit
            ? IconButton(
                onPressed: _delete,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: "Delete",
              )
            : SizedBox.shrink(),
        IconButton(
          onPressed: () {
            SQLresourcesCalcPara.clearDb();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        IconButton(
          onPressed: _submit,
          icon: Icon(
            Icons.check,
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final calcParaModel = CalcParaModel(
        fromDateHash: calculateDateHash(_selectDateBloc.fromDateValue!),
        toDateHash: calculateDateHash(_selectDateBloc.toDateValue!),
        discount: _discountCntrl.text.trim(),
        commissionRe1: _commisionRe1Cntrl.text.trim(),
        karkuni: _karkuniCntrl.text.trim(),
        commission: _commisionCntrl.text.trim(),
        remark: _remarkCntrl.text.trim(),
        documentId: '$getDocumentId',
        fromDate: _selectDateBloc.fromDateValue!.toIso8601String(),
        toDate: _selectDateBloc.toDateValue!.toIso8601String(),
        timestamp: DateTime.now().toIso8601String(),
      );

      if (isEdit) {
        calcParaModel.documentId = widget.documentId;

        HandleCalcParam(context).editParameter(calcParaModel);

        return;
      }

      HandleCalcParam(context).addParameters(calcParaModel);
    }
  }
}
