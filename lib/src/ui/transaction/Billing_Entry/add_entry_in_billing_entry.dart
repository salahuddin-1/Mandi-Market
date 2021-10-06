import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/billing_entry_add_entry_BLOC.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/models/billing_entry_model.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

class AddEntryInBillingEntry extends StatefulWidget {
  const AddEntryInBillingEntry({Key? key}) : super(key: key);

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

  @override
  void initState() {
    _dateCntrl = new TextEditingController();
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0.5.h),
        child: ListView(
          padding: EdgeInsets.only(bottom: 50),
          children: [
            _date(),
            _bepariNameTextField(),
            _unitsAndAadmi(),
            _dalaliAndDiscount(),
            _karkuniAndFees(),
            _pakkiRakamAndKacchiRakam(),
            _gavalNameTextField(),
            _gawaliAndMotor(),
            _rokAndBaki(),
            _descriptionTextField(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBarCustom(context).appbar(
      title: 'Add Entry in Billing entry',
      actions: [
        IconButton(
          onPressed: _submit,
          icon: Icon(Icons.check),
          color: WHITE,
        ),
      ],
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
      controller: _bepariNameCntrl,
      decoration: InputDecoration(
        labelText: "Bepari name",
      ),
    );
  }

  _pakkiRakamAndKacchiRakam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _subAmountCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Sub amount",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _netAmountCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Net amount",
            ),
          ),
        )
      ],
    );
  }

  _unitsAndAadmi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _unitsCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Units",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _aadmiCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Aadmi",
            ),
          ),
        )
      ],
    );
  }

  _dalaliAndDiscount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _dalaliCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Dalali",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _discountCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Discount",
            ),
          ),
        )
      ],
    );
  }

  _karkuniAndFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _karkuniCntrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Karkuni",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _feesCntrl,
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
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Baki",
            ),
          ),
        )
      ],
    );
  }

  _submit() {
    final model = new BillingEntryModel(
      selectedTimestamp: "6 October, 2021",
      timestamp: DateTime.now().toIso8601String(),
      dateHash: calculateDateHash(DateTime.now()),
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
      miscExpenses: "",
      documentId: getDocumentId.toString(),
    );

    BillingEntryAddEntryBLOC().addEntry(model);
  }
}
