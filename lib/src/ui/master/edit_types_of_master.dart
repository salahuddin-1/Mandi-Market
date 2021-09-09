import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/debit_credit_bloc.dart';
import 'package:mandimarket/src/blocs/master_list_pagination.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/database/master_database.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/master_model.dart';
import 'package:mandimarket/src/resources/errors.dart';
import 'package:mandimarket/src/resources/master_handler.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/validation/party_validation.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/ios_arrow_icon.dart';
import 'package:sizer/sizer.dart';

class EditMaster extends StatefulWidget {
  final String type;
  final String docId;
  final MasterPaginationBloc masterPaginationBloc;

  const EditMaster({
    Key? key,
    required this.type,
    required this.docId,
    required this.masterPaginationBloc,
  }) : super(key: key);
  @override
  _EditMasterState createState() => _EditMasterState();
}

class _EditMasterState extends State<EditMaster> {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;
  final _formKey = GlobalKey<FormState>();
  final _partyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phonenoController = TextEditingController();
  final _openingBalController = TextEditingController();
  final _remarkController = TextEditingController();

  final _showCircularProgressBloc = ShowCircularProgressBloc();
  DebitCreditBloc? _debitCreditBloc;

  @override
  void dispose() {
    _debitCreditBloc!.dispose();
    _showCircularProgressBloc.dispose();

    _partyNameController.dispose();
    _addressController.dispose();
    _phonenoController.dispose();
    _openingBalController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _debitCreditBloc = DebitCreditBloc(type: widget.type);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: MasterDatabase.getUser(
        ownersPhoneNumber,
        widget.docId,
        widget.type,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgressWithBackground();
        } else if (snapshot.hasError) {
          return _errorWidget(snapshot.error);
        } else if (snapshot.hasData) {
          _setParams(snapshot);
          return _editBody();
        }

        return circularProgressWithBackground();
      },
    );
  }

  circularProgressWithBackground() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: circularProgress(),
    );
  }

  Widget _editBody() {
    return Scaffold(
      appBar: _appbar(context),
      body: ListView(
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
    );
  }

  Center _errorWidget(errorCode) {
    return Center(
      child: Text(ErrorCustom.error(errorCode).toString()),
    );
  }

  void _setParams(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    final masterModel = MasterModel.fromDocument(snapshot.data!);

    _partyNameController.text = masterModel.partyName;
    _addressController.text = masterModel.address;
    _phonenoController.text = masterModel.phoneNumber;
    _openingBalController.text = masterModel.openingBalance;
    _remarkController.text = masterModel.remark;

    _debitCreditBloc!.updateValue(masterModel.debitOrCredit);
  }

  TextFormField _remarkTextField() {
    return TextFormField(
      controller: _remarkController,
      validator: (val) => PartyValidation.remark(val!),
      decoration: InputDecoration(
        labelText: "Remark",
      ),
    );
  }

  TextFormField _openingBalTextField() {
    return TextFormField(
      controller: _openingBalController,
      validator: (val) => PartyValidation.openingBalance(val!),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Opening balance",
      ),
    );
  }

  TextFormField _phoneNoTextField() {
    return TextFormField(
      controller: _phonenoController,
      validator: (val) => PartyValidation.phoneNumber(val!),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Phone number",
      ),
    );
  }

  TextFormField _addressTextField() {
    return TextFormField(
      controller: _addressController,
      validator: (val) => PartyValidation.address(val!),
      decoration: InputDecoration(
        labelText: "Address",
      ),
    );
  }

  TextFormField _partyNameTextField() {
    return TextFormField(
      controller: _partyNameController,
      validator: (val) => PartyValidation.name(val!),
      decoration: InputDecoration(
        labelText: "Party name",
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: Text("Edit"),
      leading: IosArrowIcon(
        onPressed: () {
          Pop(context);
        },
      ),
      actions: [
        _deleteButton(),
        _loadingWidget(),
      ],
    );
  }

  Widget _deleteButton() {
    return IconButton(
      onPressed: _confirmationDialog,
      icon: Icon(
        Icons.delete,
      ),
    );
  }

  Future _confirmationDialog() {
    return showDialog(
      context: context,
      builder: (newContext) {
        return AlertDialog(
          title: Text("The party will be deleted. Are you sure ?"),
          actions: [
            TextButton(
              onPressed: () => _delete(newContext),
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Pop(newContext),
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _delete(BuildContext newContext) {
    MasterHandler().delete(
      ownersPhoneNumber,
      widget.type,
      widget.docId,
      newContext,
      widget.masterPaginationBloc,
    );
    Pop(context);
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

  StreamBuilder<bool> _loadingWidget() {
    return StreamBuilder<bool>(
      stream: _showCircularProgressBloc.streamCircularProgress,
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final masterModel = MasterModel(
        partyName: _partyNameController.text.trim(),
        address: _addressController.text.trim(),
        phoneNumber: _phonenoController.text.trim(),
        debitOrCredit: _debitCreditBloc!.value,
        openingBalance: _openingBalController.text.trim(),
        remark: _remarkController.text.trim(),
        comparingName: _partyNameController.text.trim().toLowerCase(),
        documentId: widget.docId,
      );

      await MasterHandler().updateMaster(
        masterModel,
        ownersPhoneNumber,
        context,
        _showCircularProgressBloc,
        type: widget.type,
        docId: widget.docId,
        masterPaginationBloc: widget.masterPaginationBloc,
      );
    }
  }
}
