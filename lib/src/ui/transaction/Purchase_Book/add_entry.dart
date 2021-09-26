import 'package:flutter/material.dart';
import 'package:mandimarket/src/Data_Holder/Purchase_book/inherited_widget.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_bloc.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/purchase_book_get_user_bloc.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/constants/calculate_date_hash.dart';
import 'package:mandimarket/src/database/SQFLite/Transaction/sql_resources_purchase_book.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/models/purchase_book_model.dart';
import 'package:mandimarket/src/resources/Transaction/handle_purchase_book..dart';
import 'package:mandimarket/src/resources/document_id.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/saga_book_calculations.dart';
import 'package:mandimarket/src/validation/party_validation.dart';
import 'package:mandimarket/src/validation/transaction_validation.dart';
import 'package:mandimarket/src/widgets/select_date.dart';
import 'package:mandimarket/src/widgets/toast.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'party_list_from_master_local.dart';

class AddEntryInPurchasebook extends StatefulWidget {
  final SagaBookBloc sagaBookBloc;

  AddEntryInPurchasebook({
    required this.sagaBookBloc,
  });
  @override
  _AddEntryInPurchasebookState createState() => _AddEntryInPurchasebookState();
}

class _AddEntryInPurchasebookState extends State<AddEntryInPurchasebook> {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;
  late final ShowCircularProgressBloc _showCircularProgressBloc;
  late final SelectDateBloc selectDateBloc;
  late final PurchaseBookGetUserBLOC _purchaseBookUserBLOC;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dateController;
  late final TextEditingController _bepariNameController;
  late final TextEditingController _customerNameController;
  late final TextEditingController _pediNameController;
  late final TextEditingController _dawanNameController;
  late final TextEditingController _unitController;
  late final TextEditingController _rateController;
  late final TextEditingController _kacchiRakmController;
  late final TextEditingController _dalaliController;
  late final TextEditingController _discountController;
  late final TextEditingController _pakkiRakmController;

  final _sagaBookCalculations = SagaBookCalculations();

  @override
  void initState() {
    _showCircularProgressBloc = ShowCircularProgressBloc();
    selectDateBloc = new SelectDateBloc();
    _purchaseBookUserBLOC = PurchaseBookGetUserBLOC();

    _dateController = new TextEditingController(
      text: formatDate(
        DateTime.now(),
      ),
    );

    _bepariNameController = new TextEditingController();
    _customerNameController = new TextEditingController();
    _pediNameController = new TextEditingController();
    _dawanNameController = new TextEditingController();
    _unitController = new TextEditingController();
    _rateController = new TextEditingController();
    _kacchiRakmController = new TextEditingController();
    _dalaliController = new TextEditingController(text: '0');
    _discountController = new TextEditingController();
    _pakkiRakmController = new TextEditingController();

    setTextfieldsValues();

    super.initState();
  }

  setTextfieldsValues() {
    _purchaseBookUserBLOC.bepariCntrl.listen(
      (value) {
        _bepariNameController.text = value;
      },
    );

    _purchaseBookUserBLOC.customerStreamCntrl.listen(
      (value) {
        _customerNameController.text = value;
        _pediNameController.text = value;
      },
    );

    _purchaseBookUserBLOC.dawanStreamCntrl.listen(
      (value) {
        _dawanNameController.text = value;
      },
    );
  }

  @override
  void dispose() {
    _showCircularProgressBloc.dispose();
    selectDateBloc.dispose();

    _dateController.dispose();
    _bepariNameController.dispose();
    _customerNameController.dispose();
    _pediNameController.dispose();
    _dawanNameController.dispose();
    _unitController.dispose();
    _rateController.dispose();
    _kacchiRakmController.dispose();
    _dalaliController.dispose();
    _discountController.dispose();
    _pakkiRakmController.dispose();

    _purchaseBookUserBLOC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0.5.h),
              child: ListView(
                padding: EdgeInsets.only(bottom: 50),
                children: [
                  _date(),
                  _bepariNameTextField(),
                  _customerNameTextField(),
                  _pediNameTextField(),
                  _dawanNameTextField(),
                  _nangAndRate(),
                  _dalaliAndDiscount(),
                  _kacchiRakamAndPakkiRakam(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          // _draggableScrollableSheet(),
        ],
      ),
    );
  }

  showSheet() => showSlidingBottomSheet(
        context,
        builder: (context) => SlidingSheetDialog(
          cornerRadius: 16,
          snapSpec: SnapSpec(
            snappings: [0.4, 0.7],
          ),
          builder: (context, state) => Container(
            color: Colors.red,
            height: 50.h,
            width: 10,
          ),
        ),
      );

  Widget _bepariNameTextField() {
    return TextFormField(
      controller: _bepariNameController,
      onTap: () {
        Push(
          context,
          pushTo: PartyListFromMasterLocal(
            type: 'Bepari',
            purchaseBookGetUserBLOC: _purchaseBookUserBLOC,
          ),
        );
      },
      readOnly: true,
      validator: (val) => TransactionValidation.bepariName(val!),
      decoration: InputDecoration(
        labelText: "Bepari name",
      ),
    );
  }

  Container _customerNameTextField() {
    return Container(
      child: TextFormField(
        controller: _customerNameController,
        onTap: () {
          Push(
            context,
            pushTo: PartyListFromMasterLocal(
              type: 'Customer',
              purchaseBookGetUserBLOC: _purchaseBookUserBLOC,
            ),
          );
        },
        readOnly: true,
        validator: (val) => TransactionValidation.customerName(val!),
        decoration: InputDecoration(
          labelText: "Customer name",
        ),
      ),
    );
  }

  Container _pediNameTextField() {
    return Container(
      child: TextFormField(
        controller: _pediNameController,
        decoration: InputDecoration(
          labelText: "Pedi name",
        ),
      ),
    );
  }

  Container _dawanNameTextField() {
    return Container(
      child: TextFormField(
        controller: _dawanNameController,
        onTap: () {
          Push(
            context,
            pushTo: PartyListFromMasterLocal(
              type: 'Dawan',
              purchaseBookGetUserBLOC: _purchaseBookUserBLOC,
            ),
          );
        },
        readOnly: true,
        validator: (val) => TransactionValidation.dawanName(val!),
        decoration: InputDecoration(
          labelText: "Dawan name",
        ),
      ),
    );
  }

  _date() {
    return StreamBuilder<DateTime?>(
      stream: selectDateBloc.streamFromDate,
      builder: (context, snapshot) {
        return Container(
          child: TextFormField(
            controller: _dateController,
            onTap: () async => await _selectDate(context, snapshot),
            readOnly: true,
            validator: (val) => PartyValidation.name(val!),
            decoration: InputDecoration(
              labelText: "Date",
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    AsyncSnapshot<DateTime?> snapshot,
  ) async {
    var date = await showDate(
      context,
      title: 'Select',
      selectedDate: snapshot.data!,
    );

    selectDateBloc.selectFromDate(date);
    _dateController.text = formatDate(date);
  }

  _nangAndRate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: _unitController,
            keyboardType: TextInputType.phone,
            validator: (val) => TransactionValidation.unit(val!),
            decoration: InputDecoration(
              labelText: "Unit",
            ),
            onChanged: (val) {
              setKacchiRakam();
              setDiscount();
              setPakkiRakam();
              setDalali();
            },
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _rateController,
            keyboardType: TextInputType.phone,
            validator: (val) => TransactionValidation.rate(val!),
            decoration: InputDecoration(
              labelText: "Rate",
            ),
            onChanged: (val) {
              setKacchiRakam();
              setDiscount();
              setPakkiRakam();
            },
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
            controller: _dalaliController,
            validator: (val) => TransactionValidation.dalali(val!),
            decoration: InputDecoration(
              labelText: "Dalali",
            ),
            onChanged: (val) {
              setPakkiRakam();
            },
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
          child: TextFormField(
            controller: _discountController,
            validator: (val) => TransactionValidation.discount(val!),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Discount",
            ),
            onChanged: (val) {
              setPakkiRakam();
            },
          ),
        )
      ],
    );
  }

  _kacchiRakamAndPakkiRakam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: TextFormField(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              controller: _kacchiRakmController,
              keyboardType: TextInputType.phone,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Sub amount",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
            child: Container(
          color: Colors.grey[100],
          child: TextFormField(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            controller: _pakkiRakmController,
            keyboardType: TextInputType.phone,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Net amount",
              labelStyle: TextStyle(
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ))
      ],
    );
  }

  void setKacchiRakam() {
    var rate = _rateController.text.trim();
    var unit = _unitController.text.trim();

    if (rate.isNotEmpty && unit.isNotEmpty) {
      var kacchiRakam = _sagaBookCalculations
          .calculateKacchiRakam(
            rate: rate,
            unit: unit,
          )
          .toString();

      _kacchiRakmController.text = kacchiRakam;
    } else {
      _kacchiRakmController.text = '0';
      _discountController.text = '0';
      _pakkiRakmController.text = '0';
    }
  }

  void setPakkiRakam() {
    var discount = _discountController.text.trim();
    var dalali = _dalaliController.text.trim();
    var kacchiRakam = _kacchiRakmController.text.trim();

    if (discount.isNotEmpty && dalali.isNotEmpty && kacchiRakam.isNotEmpty) {
      var pakkiRakam = _sagaBookCalculations
          .calculatePakkiRakam(
            discount: discount,
            dalali: dalali,
            kacchiRakam: kacchiRakam,
          )
          .toString();

      _pakkiRakmController.text = pakkiRakam;
    }
  }

  void setDiscount() {
    var kacchiRakam = _kacchiRakmController.text.trim();

    if (kacchiRakam.isNotEmpty) {
      var discount = _sagaBookCalculations
          .calculateDiscount(
            kacchiRakam: kacchiRakam,
          )
          .toString();
      _discountController.text = discount;
    }
  }

  void setDalali() {
    _dalaliController.text = _unitController.text;
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        onPressed: () {
          Pop(context);
        },
      ),
      title: Text("Add Purchase Entry"),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            PurchaseBookSQLResources().clearDb();
          },
          icon: Icon(
            Icons.deck,
          ),
        ),
        IconButton(
          onPressed: () {
            PurchaseBookSQLResources().getEntries();
          },
          icon: Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: _submit,
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  updateValues() {
    widget.sagaBookBloc.updateNoOfUnits(
      int.parse(_unitController.text.trim()),
    );

    widget.sagaBookBloc.updateGrossAmount(
      double.parse(_pakkiRakmController.text.trim()),
    );
  }

  bool get dateOutOfRange {
    final currentDatehash = calculateDateHash(selectDateBloc.fromDateValue!);

    return currentDatehash < PurchaseBookDataHolder.value.fromDateHash ||
        currentDatehash > PurchaseBookDataHolder.value.toDateHash;
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      if (dateOutOfRange) {
        ShowToast.errorToast(
          'Error : Selected Date out of Range !!!',
          context,
          5,
        );
        return;
      }

      updateValues();
      final purchaseBookModel = new PurchaseBookModel(
        bepariName: _bepariNameController.text,
        customerName: _customerNameController.text,
        pediName: _pediNameController.text.trim(),
        dawanName: _dawanNameController.text,
        unit: _unitController.text.trim(),
        rate: _rateController.text.trim(),
        dalali: _dalaliController.text.trim(),
        discount: _discountController.text.trim(),
        kacchiRakam: _kacchiRakmController.text.trim(),
        pakkiRakam: _pakkiRakmController.text.trim(),
        documentId: getDocumentId,
        selectedTimestamp: _dateController.text,
        timestamp: DateTime.now().toIso8601String(),
        dateHash: calculateDateHash(selectDateBloc.fromDateValue!),
      );

      //// Set Data
      HandlePurchaseBook(context).addEntryInPurchaseBook(
        purchaseBookModel,
      );
      // Pop(context);
    }
  }
}
