import 'package:flutter/material.dart';
import 'package:mandimarket/src/blocs/saga_book_bloc.dart';
import 'package:mandimarket/src/blocs/select_date_bloc.dart';
import 'package:mandimarket/src/blocs/show_circular_progress_bloc.dart';
import 'package:mandimarket/src/dependency_injection/user_credentials.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/resources/saga_book_calculations.dart';
import 'package:mandimarket/src/ui/transaction/users_list.dart';
import 'package:mandimarket/src/validation/party_validation.dart';
import 'package:mandimarket/src/validation/transaction_validation.dart';
import 'package:mandimarket/src/widgets/select_date.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final ownersPhoneNumber = userCredentials.ownersPhoneNumber;
  late final ShowCircularProgressBloc _showCircularProgressBloc;
  late final SelectDateBloc selectDateBloc;
  final sagaBookBloc = new SagaBookBloc();

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

    _dateController = new TextEditingController(
      text: formatDate(
        DateTime.now(),
      ),
    );

    _bepariNameController = new TextEditingController();
    _customerNameController = new TextEditingController();
    _pediNameController = new TextEditingController();
    _dawanNameController = new TextEditingController();
    _unitController = new TextEditingController(text: '0');
    _rateController = new TextEditingController(text: '0');
    _kacchiRakmController = new TextEditingController(text: '0');
    _dalaliController = new TextEditingController(text: '0');
    _discountController = new TextEditingController(text: '0');
    _pakkiRakmController = new TextEditingController(text: '0');

    super.initState();
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
          _draggableScrollableSheet(),
        ],
      ),
    );
  }

  DraggableScrollableSheet _draggableScrollableSheet() {
    return DraggableScrollableSheet(
      maxChildSize: 0.3,
      // initialChildSize: 0.3,
      initialChildSize: 0.05,
      minChildSize: 0.05,
      builder: (context, cntrl) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.yellow[700],
        ),
        child: ListView(
          controller: cntrl,
          children: [
            SizedBox(height: 1.2.h),
            Center(
              child: Container(
                height: 0.8.h,
                width: 18.w,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 7.w,
                vertical: 4.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "No. of Units :  ",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<int>(
                        stream: sagaBookBloc.noOfUnits,
                        builder: (context, snapshot) {
                          return Flexible(
                            child: FittedBox(
                              child: Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5.sp),
                  Row(
                    children: [
                      Text(
                        "Gross Amount :  ",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<double>(
                        stream: sagaBookBloc.grossAmount,
                        builder: (context, snapshot) {
                          return Flexible(
                            child: FittedBox(
                              child: Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
          onPressed: () {},
          icon: Icon(
            Icons.check,
            color: Colors.transparent,
          ),
        ),
        IconButton(
          onPressed: () {
            showSheet();
          },
          icon: Icon(Icons.check),
        ),
      ],
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

  Container _bepariNameTextField() {
    return Container(
      child: TextFormField(
        controller: _bepariNameController,
        onTap: () {
          Push(
            context,
            pushTo: UsersList(
              type: 'Bepari',
            ),
          );
        },
        readOnly: true,
        validator: (val) => TransactionValidation.bepariName(val!),
        decoration: InputDecoration(
          labelText: "Bepari name",
        ),
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
            pushTo: UsersList(
              type: 'Customer',
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
        onTap: () {
          Push(
            context,
            pushTo: UsersList(
              type: 'Pedi',
            ),
          );
        },
        readOnly: true,
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
            pushTo: UsersList(
              type: 'Dawan',
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
            // style: TextStyle(fontSize: 10),
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
              if (val.isNotEmpty) {
                sagaBookBloc.updateNoOfUnits(
                  int.parse(val),
                );
              }

              setKacchiRakam();
              setDiscount();
              setPakkiRakam();
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
          child: TextFormField(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            controller: _kacchiRakmController,
            keyboardType: TextInputType.phone,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Kacchi rakam",
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Expanded(
            child: TextFormField(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          controller: _pakkiRakmController,
          keyboardType: TextInputType.phone,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Pakki rakam",
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

      sagaBookBloc.updateGrossAmount(
        double.parse(pakkiRakam),
      );
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
}
