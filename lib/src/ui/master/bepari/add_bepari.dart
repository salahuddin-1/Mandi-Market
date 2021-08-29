import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/debit_credit_bloc.dart';
import 'package:mandimarket/src/database/bepari_database.dart';
import 'package:mandimarket/src/models/bepari_model.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/validation/party_validation.dart';

class AddBepari extends StatefulWidget {
  @override
  _AddBepariState createState() => _AddBepariState();
}

class _AddBepariState extends State<AddBepari> {
  String _dropDownValue = "Debit";

  String _partyName = "";
  String _address = "";
  String _phoneno = "";
  String _openingBal = "";
  String _remark = "";

  DebitCreditBloc? _debitCreditBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _debitCreditBloc = DebitCreditBloc();
    super.initState();
  }

  @override
  void dispose() {
    _debitCreditBloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  _partyNameTextField(),
                  _addressTextField(),
                  _phoneNoTextField(),
                  _openingBalTextField(),
                  _dropDown(),
                  _remarkTextField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _remarkTextField() {
    return TextFormField(
      validator: (val) => PartyValidation.remark(val!),
      onSaved: (val) => _remark = val!,
      decoration: InputDecoration(
        labelText: "Remark",
      ),
    );
  }

  TextFormField _openingBalTextField() {
    return TextFormField(
      validator: (val) => PartyValidation.openingBalance(val!),
      onSaved: (val) => _openingBal = val!,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Opening balance",
      ),
    );
  }

  TextFormField _phoneNoTextField() {
    return TextFormField(
      validator: (val) => PartyValidation.phoneNumber(val!),
      onSaved: (val) => _phoneno = val!,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Phone number",
      ),
    );
  }

  TextFormField _addressTextField() {
    return TextFormField(
      validator: (val) => PartyValidation.address(val!),
      decoration: InputDecoration(
        labelText: "Address",
      ),
      onSaved: (val) => _address = val!,
    );
  }

  TextFormField _partyNameTextField() {
    return TextFormField(
      validator: (val) => PartyValidation.name(val!),
      decoration: InputDecoration(
        labelText: "Party name",
      ),
      onSaved: (val) => _partyName = val!,
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text(
        "Add party",
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            _submit();
          },
          icon: Icon(
            Icons.check,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final bepariModel = BepariModel(
        partyName: _partyName,
        address: _address,
        phoneNumber: _phoneno,
        debitOrCredit: _dropDownValue,
        openingBalance: _openingBal,
        remark: _remark,
      );

      BepariDatabase.addBepari(bepariModel, '8898911744');
      Pop(context);
    }
  }

  StreamBuilder<String> _dropDown() {
    return StreamBuilder<String>(
      stream: _debitCreditBloc!.getValue(),
      builder: (context, snapshot) {
        return DropdownButtonFormField(
          onChanged: (String? val) {
            _debitCreditBloc!.updateValue(val!);
            _dropDownValue = val;
          },
          value: snapshot.data,
          items: <String>['Debit', 'Credit'].map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
