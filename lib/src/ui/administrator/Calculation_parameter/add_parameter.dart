import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Adminstrator/sql_resources_calc_para.dart';
import 'package:mandimarket/src/models/calc_para_model.dart';
import 'package:mandimarket/src/resources/Administrator/handle_calc_param.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/validation/parameter_validation.dart';
import 'package:mandimarket/src/widgets/select_date.dart';
import 'package:sizer/sizer.dart';

class AddParameter extends StatefulWidget {
  const AddParameter({Key? key}) : super(key: key);

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

  @override
  void initState() {
    _initialiseDates();

    _commisionCntrl = new TextEditingController();
    _discountCntrl = new TextEditingController();
    _remarkCntrl = new TextEditingController();
    _karkuniCntrl = new TextEditingController();
    _commisionRe1Cntrl = new TextEditingController();

    super.initState();
  }

  void _initialiseDates() {
    _selectDateBloc = new SelectDateBloc();

    _fromDateCntrl = new TextEditingController(
      text: formatDate(DateTime.now()),
    );

    _toDateCntrl = new TextEditingController(
      text: formatDate(DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: body(),
    );
  }

  ListView body() {
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
    final fDate = formatDate(date);
    _fromDateCntrl.text = fDate;
    _selectDateBloc.selectFromDate(date);
  }

  showToDate(DateTime selectedDate) async {
    final date = await showDate(
      context,
      title: 'To',
      selectedDate: selectedDate,
    );

    final fDate = formatDate(date);
    _toDateCntrl.text = fDate;
    _selectDateBloc.selectToDate(date!);
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
      validator: (val) => ParameterValidation.discount(val!),
      decoration: InputDecoration(
        labelText: "Discount  (%)",
      ),
    );
  }

  TextFormField _commissionTextField() {
    return TextFormField(
      controller: _commisionCntrl,
      validator: (val) => ParameterValidation.commission(val!),
      decoration: InputDecoration(
        labelText: "Commission  (Rs.)",
      ),
    );
  }

  TextFormField _karkurniTextField() {
    return TextFormField(
      controller: _karkuniCntrl,
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
      validator: (val) => ParameterValidation.commissionRe1(val!),
      decoration: InputDecoration(
        labelText: "Commission Re. 1 / unit",
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.brown[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        iconSize: 15.sp,
        color: Colors.white,
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text(
        "Add Parameter",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            SQLresourcesCalcPara.clearDb();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            SQLresourcesCalcPara.getEntries();
          },
          icon: Icon(
            Icons.hourglass_bottom,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: _submit,
          icon: Icon(
            Icons.check,
            color: Colors.white,
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

      HandleCalcParam(context).addParameters(calcParaModel);
    }
  }
}
