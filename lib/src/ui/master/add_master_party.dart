import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/debit_credit_bloc.dart';
import 'package:mandimarket/src/blocs/master_list_pagination.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/master_model.dart';
import 'package:mandimarket/src/resources/master_handler.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/validation/party_validation.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:sizer/sizer.dart';

class AddMaster extends StatefulWidget {
  final String type;
  final MasterPaginationBloc? masterPaginationBloc;

  const AddMaster({
    Key? key,
    required this.type,
    this.masterPaginationBloc,
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
            color: Colors.black,
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

      final masterModel = MasterModel(
        partyName: _partyName,
        address: _address,
        phoneNumber: _phoneno,
        debitOrCredit: _debitCreditBloc!.value,
        openingBalance: _openingBal,
        remark: _remark,
        comparingName: _partyName.toLowerCase().trim(),
      );
      MasterHandler().addMaster(
        masterModel,
        ownersPhoneNumber,
        context,
        _showCircularProgressBloc!,
        type: widget.type,
        masterPaginationBloc: widget.masterPaginationBloc,
      );
    }
  }
}
