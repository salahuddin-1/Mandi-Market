import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/debit_credit_bloc.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/database/SQFLite/Master/sql_resources_master.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/Master1/master_model.dart';
import 'package:mandimarket/src/validation/party_validation.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

import 'handle_master.dart';

class AddMaster extends StatefulWidget {
  final String type;

  const AddMaster({
    Key? key,
    required this.type,
  }) : super(key: key);
  @override
  _AddMasterState createState() => _AddMasterState();
}

class _AddMasterState extends State<AddMaster> {
  ShowCircularProgressBloc? _showCircularProgressBloc;
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;

  String _partyName = "";
  String _address = "-";
  String _phoneno = "";
  String _openingBal = "";
  String _remark = "-";

  DebitCreditBloc? _debitCreditBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _debitCreditBloc = DebitCreditBloc(
      type: widget.type,
    );
    _showCircularProgressBloc = ShowCircularProgressBloc();
    super.initState();
  }

  @override
  void dispose() {
    _debitCreditBloc!.dispose();
    _showCircularProgressBloc!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
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
        ],
      ),
    );
  }

  TextFormField _remarkTextField() {
    return TextFormField(
      validator: (val) => PartyValidation.remark(val!),
      onSaved: (val) {
        if (val!.isEmpty) {
          _remark = '-';
        }
        _remark = val;
      },
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
      onSaved: (val) {
        if (val!.isEmpty) {
          _address = '-';
        }
        _address = val;
      },
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
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            MasterSqlResources().clearDb(widget.type);
          },
          icon: Icon(Icons.delete),
        ),
        IconButton(
          onPressed: () {
            MasterSqlResources().getEntries(widget.type);
          },
          icon: Icon(Icons.ac_unit),
        ),
        _loadingWidget(),
      ],
    );
  }

  StreamBuilder<bool> _loadingWidget() {
    return StreamBuilder<bool>(
      stream: _showCircularProgressBloc!.streamCircularProgress,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              child: circularProgressForButton(),
            ),
          );
        }
        return IconButton(
          onPressed: () => _submit(),
          icon: Icon(
            Icons.check,
            color: BLACK,
          ),
        );
      },
    );
  }

  StreamBuilder<String> _dropDown() {
    return StreamBuilder<String>(
      stream: _debitCreditBloc!.getValue(),
      builder: (context, snapshot) {
        return DropdownButtonFormField(
          onChanged: (String? val) {
            _debitCreditBloc!.updateValue(val!);
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final masterModel = new MasterModel(
        partyName: _partyName,
        address: _address,
        phoneNumber: _phoneno,
        openingBalance: int.tryParse(_openingBal)!,
        remark: _remark,
        debitOrCredit: _debitCreditBloc!.value,
        timestamp: DateTime.now().toIso8601String(),
        documentId: getDocumentId,
      );

      HandleMaster(context).addParty(
        masterModel,
        type: widget.type,
      );
    }
  }
}
