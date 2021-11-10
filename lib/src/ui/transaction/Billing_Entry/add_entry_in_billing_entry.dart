import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/billing_entry_BLOC.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/billing_entry_table_BLOC.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_billing_entry.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_payment_bepari.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/reponse/api_response.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/validation/billing_entry_validation.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/dialogs.dart';
import 'package:mandimarket/src/widgets/table_widgets.dart';
import 'package:sizer/sizer.dart';

import 'list_of_bepari_from_PB.dart';

class AddEntryInBillingEntry extends StatefulWidget {
  final DateTime date;
  final BillingEntryTableBLOC? billingEntryTableBLOC;
  final bool isEdit;
  final int? documentId;

  AddEntryInBillingEntry({
    required this.date,
    this.billingEntryTableBLOC,
    this.isEdit = false,
    this.documentId,
  });

  @override
  _AddEntryInBillingEntryState createState() => _AddEntryInBillingEntryState();
}

class _AddEntryInBillingEntryState extends State<AddEntryInBillingEntry> {
  late final TextEditingController _dateCntrl;
  late final TextEditingController _bepariNameCntrl;
  late final TextEditingController _unitsCntrl;
  late final TextEditingController _aadmiCntrl;
  late final TextEditingController _dalaliCntrl;
  late final TextEditingController _discountCntrl;
  late final TextEditingController _karkuniCntrl;
  late final TextEditingController _feesCntrl;
  late final TextEditingController _subAmountCntrl;
  late final TextEditingController _netAmountCntrl;
  late final TextEditingController _gavalsNameCntrl;
  late final TextEditingController _gavaliCntrl;
  late final TextEditingController _motorCntrl;
  late final TextEditingController _rokCntrl;
  late final TextEditingController _bakiCntrl;
  late final TextEditingController _descCntrl;
  late final TextEditingController _misExpCntrl;

  Map<String, dynamic>? purchaseBookParams;
  Map<String, dynamic>? calcParams;

  late GetParametersForBillingEntry _getParametersForBillingEntry;
  late var _calculate;

  final _formKey = GlobalKey<FormState>();

  late final bool isEdit = widget.isEdit && widget.documentId != null;
  late BillingEntryEditBLOC _billingEntryEditBLOC;

  @override
  void initState() {
    PaymentBepariSQLResources.getBills('Beapri');

    _dateCntrl = new TextEditingController(
      text: formatDate(widget.date),
    );

    _bepariNameCntrl = new TextEditingController();
    _unitsCntrl = new TextEditingController();
    _aadmiCntrl = new TextEditingController();
    _dalaliCntrl = new TextEditingController();
    _discountCntrl = new TextEditingController();
    _karkuniCntrl = new TextEditingController();
    _feesCntrl = new TextEditingController();
    _subAmountCntrl = new TextEditingController();
    _netAmountCntrl = new TextEditingController();
    _gavalsNameCntrl = new TextEditingController();
    _gavaliCntrl = new TextEditingController();
    _motorCntrl = new TextEditingController();
    _rokCntrl = new TextEditingController();
    _bakiCntrl = new TextEditingController();
    _descCntrl = new TextEditingController();
    _misExpCntrl = new TextEditingController();

    _getParametersForBillingEntry = new GetParametersForBillingEntry(
      widget.date,
    );

    _calculate = _getParametersForBillingEntry.calculateCertainParams;

    if (isEdit)
      _billingEntryEditBLOC = BillingEntryEditBLOC(widget.documentId!);

    super.initState();
  }

  @override
  void dispose() {
    _dateCntrl.dispose();
    _bepariNameCntrl.dispose();
    _unitsCntrl.dispose();
    _aadmiCntrl.dispose();
    _dalaliCntrl.dispose();
    _discountCntrl.dispose();
    _karkuniCntrl.dispose();
    _feesCntrl.dispose();
    _subAmountCntrl.dispose();
    _netAmountCntrl.dispose();
    _gavaliCntrl.dispose();
    _gavalsNameCntrl.dispose();
    _motorCntrl.dispose();
    _rokCntrl.dispose();
    _bakiCntrl.dispose();
    _descCntrl.dispose();
    _misExpCntrl.dispose();

    _getParametersForBillingEntry.dispose();

    if (isEdit) _billingEntryEditBLOC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: isEdit
          ? _editScreen()
          : RefreshIndicator(
              onRefresh: () => _onRefresh(),
              color: BLACK,
              strokeWidth: 1.5,
              child: StreamBuilder<ApiResponse<Map<String, dynamic>>>(
                stream: _getParametersForBillingEntry.streamCalPara,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return circularProgress();

                      case Status.ERROR:
                        return ErrorText();

                      case Status.COMPLETED:
                        calcParams = snapshot.data!.data;
                        print(calcParams);

                        return Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 0.5.h,
                            ),
                            child: ListView(
                              padding: EdgeInsets.only(bottom: 50),
                              children: [
                                _date(),
                                _bepariNameTextField(),
                                _unitsAndDiscount(),
                                _pakkiRakamAndKacchiRakam(),
                                _commissionAndKarkuni(),
                                _aadmiAndFees(),
                                _gavalNameTextField(),
                                _gawaliAndMotor(),
                                _rokAndBaki(),
                                _miscExpTextField(),
                                _descriptionTextField(),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        );

                      default:
                    }
                  }
                  return circularProgress();
                },
              ),
            ),
    );
  }

  String? createdTimestamp;

  Widget _editScreen() {
    return StreamBuilder<ApiResponse<BillingEntryModel>>(
      stream: _billingEntryEditBLOC.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return circularProgress();

            case Status.ERROR:
              return ErrorText();

            case Status.COMPLETED:
              final model = snapshot.data!.data;

              _setDetailsForEditing(model);

              // In this STreamBuilder we are getting paramters from Calculation Parameters
              // The only difference between edit and add is that
              // In edit we are getting all the added fields and that we streaming
              // at the top of _editScreen() widget tree
              return StreamBuilder<ApiResponse<Map<String, dynamic>>>(
                stream: _getParametersForBillingEntry.streamCalPara,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return circularProgress();

                      case Status.ERROR:
                        return ErrorText();

                      case Status.COMPLETED:
                        calcParams = snapshot.data!.data;
                        print(calcParams);

                        return Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 0.5.h,
                            ),
                            child: ListView(
                              padding: EdgeInsets.only(bottom: 50),
                              children: [
                                _date(),
                                _bepariNameTextField(),
                                _unitsAndDiscount(),
                                _pakkiRakamAndKacchiRakam(),
                                _commissionAndKarkuni(),
                                _aadmiAndFees(),
                                _gavalNameTextField(),
                                _gawaliAndMotor(),
                                _rokAndBaki(),
                                _miscExpTextField(),
                                _descriptionTextField(),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        );

                      default:
                    }
                  }
                  return circularProgress();
                },
              );

            default:
          }
        }
        return circularProgress();
      },
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBarCustom(context).appbar(
      title: isEdit ? 'Edit Entry' : 'Add Entry in Billing entry',
      actions: [
        IconButton(
          onPressed: () {
            BillingEntriesSQLResources.deleteAllBillingEntries();
          },
          icon: Icon(Icons.ac_unit),
          color: WHITE,
        ),
        isEdit
            ? IconButton(
                onPressed: _deleteParty,
                icon: Icon(Icons.delete),
                color: Colors.red,
              )
            : SizedBox.shrink(),
        IconButton(
          onPressed: showNetAmt,
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  void _deleteParty() {
    DialogsCustom.delete(
      context,
      onPressedYes: () {
        widget.billingEntryTableBLOC!.deleteEntry(
          context: context,
          documentId: widget.documentId!,
        );
      },
    );
  }

  _date() {
    return TextFormField(
      controller: _dateCntrl,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Date",
      ),
    );
  }

  _bepariNameTextField() {
    return TextFormField(
      readOnly: true,
      controller: _bepariNameCntrl,
      validator: (val) => BillingEntryValidation.bepariName(val!),
      decoration: InputDecoration(
        labelText: "Bepari name",
      ),
      onTap: _onTapBepariName,
    );
  }

  _pakkiRakamAndKacchiRakam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[100],
            child: TextFormField(
              readOnly: true,
              controller: _subAmountCntrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Sub amount",
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[100],
            child: TextFormField(
              readOnly: true,
              controller: _netAmountCntrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Net amount",
              ),
            ),
          ),
        )
      ],
    );
  }

  _unitsAndDiscount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[100],
            child: TextFormField(
              readOnly: true,
              controller: _unitsCntrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Units",
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[100],
            child: TextFormField(
              readOnly: true,
              controller: _discountCntrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Discount",
              ),
            ),
          ),
        ),
      ],
    );
  }

  _commissionAndKarkuni() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[100],
            child: TextFormField(
              readOnly: true,
              controller: _dalaliCntrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Commission",
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[100],
            child: TextFormField(
              readOnly: true,
              controller: _karkuniCntrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Karkuni",
              ),
            ),
          ),
        ),
      ],
    );
  }

  _aadmiAndFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _aadmiCntrl,
            validator: (val) => BillingEntryValidation.aadmi(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Aadmi",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _feesCntrl,
            validator: (val) => BillingEntryValidation.fees(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Fees",
            ),
          ),
        )
      ],
    );
  }

  _gavalNameTextField() {
    return TextFormField(
      controller: _gavalsNameCntrl,
      validator: (val) => BillingEntryValidation.gavalsName(val!),
      decoration: InputDecoration(
        labelText: "Gaval's name",
      ),
    );
  }

  _descriptionTextField() {
    return TextFormField(
      controller: _descCntrl,
      decoration: InputDecoration(
        labelText: "Description",
      ),
    );
  }

  _gawaliAndMotor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _gavaliCntrl,
            validator: (val) => BillingEntryValidation.gavali(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Gavali",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _motorCntrl,
            validator: (val) => BillingEntryValidation.motor(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Motor",
            ),
          ),
        )
      ],
    );
  }

  _rokAndBaki() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _rokCntrl,
            validator: (val) => BillingEntryValidation.rok(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Rok",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _bakiCntrl,
            validator: (val) => BillingEntryValidation.balance(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Balance",
            ),
          ),
        )
      ],
    );
  }

  _miscExpTextField() {
    return TextFormField(
      controller: _misExpCntrl,
      validator: (val) => BillingEntryValidation.miscExp(val!),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Miscellaneous Expenses",
      ),
    );
  }

//  ------------------------ EVENTS -------------------------------------------

  void _onTapBepariName() async {
    purchaseBookParams = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListOfBepariFromPB(
          date: widget.date,
          isEdit: isEdit,
        ),
      ),
    );

    if (purchaseBookParams != null) {
      final String unit = purchaseBookParams!['unit'].toString();

      _unitsCntrl.text = unit;
      _bepariNameCntrl.text = purchaseBookParams!['bepariName'];
      _subAmountCntrl.text = purchaseBookParams!['kacchiRakam'].toString();
      _discountCntrl.text = purchaseBookParams!['discount'].toString();

      _calculateKarkuni(unit);
      _calulateCommission(unit);
    }
  }

  void _calulateCommission(String unit) {
    final double commission = _calculate.commission(
      unit: unit,
      commission: calcParams!['commission'],
    );

    _dalaliCntrl.text = commission.toString();
  }

  void _calculateKarkuni(String unit) {
    final double karkuni = _calculate.karkuni(
      unit: unit,
      karkuni: calcParams!['karkuni'],
    );

    _karkuniCntrl.text = karkuni.toString();
  }

  _calculateNetAmount() {
    double subAmount = double.tryParse(_subAmountCntrl.text)!;
    double discount = double.tryParse(_discountCntrl.text)!;
    double commission = double.tryParse(_dalaliCntrl.text)!;
    double karkuni = double.tryParse(_karkuniCntrl.text)!;
    double fees = double.tryParse(_feesCntrl.text.trim())!;
    double aadmi = double.tryParse(_aadmiCntrl.text.trim())!;
    double miscExpens = double.tryParse(_misExpCntrl.text.trim())!;
    double gavali = double.tryParse(_gavaliCntrl.text.trim())!;
    double motor = double.tryParse(_motorCntrl.text.trim())!;
    double rok = double.tryParse(_rokCntrl.text.trim())!;
    double balAmount = double.tryParse(_bakiCntrl.text.trim())!;

    final double netAmount = _calculate.netAmount(
      subAmount: subAmount,
      discount: discount,
      commission: commission,
      karkuni: karkuni,
      fees: fees,
      aadmi: aadmi,
      miscExpens: miscExpens,
      gavali: gavali,
      motor: motor,
      rok: rok,
      balAmount: balAmount,
    );

    _netAmountCntrl.text = netAmount.toString().trim();
  }

  Future<void> _onRefresh() {
    if (purchaseBookParams != null) {
      final String unit = purchaseBookParams!['unit'].toString();

      _calculateKarkuni(unit);
      _calulateCommission(unit);
    }
    return _getParametersForBillingEntry.getCalPara();
  }

  void showNetAmt() {
    if (_formKey.currentState!.validate()) {
      _calculateNetAmount();
    } else
      return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text('Net Amount : '),
        content: Text(
          "Rs.  " + _netAmountCntrl.text.trim(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            letterSpacing: 1,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Pop(context);
              _submit();
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  // (EDITING) - SET DETAILS
  void _setDetailsForEditing(BillingEntryModel? model) {
    if (model != null) {
      _bepariNameCntrl.text = model.bepariName;
      _unitsCntrl.text = model.unit;
      _discountCntrl.text = model.discount;
      _subAmountCntrl.text = model.subAmount;
      _netAmountCntrl.text = model.netAmount;
      _dalaliCntrl.text = model.dalali;
      _karkuniCntrl.text = model.karkuni;
      _aadmiCntrl.text = model.aadmi;
      _feesCntrl.text = model.fees;
      _gavaliCntrl.text = model.gavali;
      _gavalsNameCntrl.text = model.gavalsName;
      _motorCntrl.text = model.motor;
      _rokCntrl.text = model.rok;
      _bakiCntrl.text = model.baki;
      _misExpCntrl.text = model.miscExpenses;
      _descCntrl.text = model.description;

      createdTimestamp = model.timestamp;
    }
  }

  // SUBMIT
  _submit() {
    final model = new BillingEntryModel(
      selectedTimestamp: widget.date.toIso8601String(),
      timestamp: DateTime.now().toIso8601String(),
      dateHash: calculateDateHash(widget.date),
      bepariName: _bepariNameCntrl.text.trim(),
      unit: _unitsCntrl.text.trim(),
      aadmi: _aadmiCntrl.text.trim(),
      dalali: _dalaliCntrl.text.trim(),
      discount: _discountCntrl.text.trim(),
      karkuni: _karkuniCntrl.text.trim(),
      fees: _feesCntrl.text.trim(),
      subAmount: _subAmountCntrl.text.trim(),
      netAmount: _netAmountCntrl.text.trim(),
      gavalsName: _gavalsNameCntrl.text.trim(),
      gavali: _gavaliCntrl.text.trim(),
      motor: _motorCntrl.text.trim(),
      rok: _rokCntrl.text.trim(),
      baki: _bakiCntrl.text.trim(),
      description: _descCntrl.text.trim(),
      miscExpenses: _misExpCntrl.text.trim(),
      documentId: getDocumentId,
    );

    if (isEdit) {
      model.documentId = widget.documentId!;
      model.timestamp = createdTimestamp!;

      widget.billingEntryTableBLOC!.updateEntry(
        map: model.toMap(),
        documentId: widget.documentId!,
        context: context,
      );
      return;
    }

    widget.billingEntryTableBLOC!.addEntry(
      model,
      context: context,
    );
  }
}
