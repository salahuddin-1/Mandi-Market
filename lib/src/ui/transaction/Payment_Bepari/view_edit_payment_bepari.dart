import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/Payment_Bepari_BLOC/calculate_bills_BLOC.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/Payment_Bepari_BLOC/get_entries_payment_bepari_BLOC.dart';
import 'package:mandimarket/src/blocs/Transaction_BLOC/Payment_Bepari_BLOC/view_edit_bloc.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/models/payment_bepari_model.dart';
import 'package:mandimarket/src/resources/format_date.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';
import 'package:mandimarket/src/widgets/circular_progress.dart';
import 'package:mandimarket/src/widgets/select_date.dart';

import 'package:sizer/sizer.dart';

class ViewEditPaymentBepari extends StatefulWidget {
  final String bepariName;
  final GetEntriesPaymentBepariBLOC getEntriesPaymentBepariBLOC;

  const ViewEditPaymentBepari({
    Key? key,
    required this.getEntriesPaymentBepariBLOC,
    required this.bepariName,
  }) : super(key: key);

  @override
  _ViewEditPaymentBepariState createState() => _ViewEditPaymentBepariState();
}

class _ViewEditPaymentBepariState extends State<ViewEditPaymentBepari>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _dateCntrl;
  late final TextEditingController _bepariNameCntrl;
  late final TextEditingController _paymentCntrl;
  late final TextEditingController _receivingCntrl;

  late DateTime _selectedDate;
  late CalculateBillsBLOC _calculateBillsBLOC;
  PaymentBepariModel? paymentBepariModel;

  int _billsLength = 0;
  bool showRecevingWidgets = false;
  bool isReceiving = false;
  bool showPayingWidgets = false;

  // For Draggable sheet
  late AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  // States
  late PaymentCheckedBLOC _paymentCheckedBLOC;

  // Stack

  @override
  void initState() {
    // This BLOC is for getting bills and opening balance
    _calculateBillsBLOC = CalculateBillsBLOC(widget.bepariName);

    _dateCntrl = new TextEditingController();
    _bepariNameCntrl = new TextEditingController();
    _paymentCntrl = new TextEditingController();
    _receivingCntrl = new TextEditingController();

    _selectedDate = DateTime.now();
    _dateCntrl.text = formatDate(
      _selectedDate,
    );

    _controller = AnimationController(vsync: this, duration: _duration);
    // Initially the draggable will be slided up
    _controller.forward();

    _paymentCheckedBLOC = PaymentCheckedBLOC();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appbar(),
      body: StreamBuilder<PaymentBepariModel>(
          stream: _calculateBillsBLOC.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Assigning Data

              print('build');

              paymentBepariModel = snapshot.data!;

              _setAttributes();

              return Stack(
                fit: StackFit.expand,
                children: [
                  ListView(
                    padding: EdgeInsets.only(bottom: 28.h, top: 1.5.h),
                    children: [
                      _date(),
                      _bepariNameTextField(),
                      SizedBox(height: 5.h),
                      DataTable(
                        columns: [
                          DataColumn(
                            label: Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Opening\nBalance\nin ",
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w500,
                                        color: BLACK,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${paymentBepariModel!.masterModel!.debitOrCredit}",
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                        color: _genreColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _dataColumn("Amount (Rs.)"),
                          // this.isReceiving
                          //     ? _dataColumn("Amount\nreceived (Rs.)")
                          //     : _dataColumn("Balance\namount (Rs.)"),
                          _dataColumn("Balance\namount (Rs.)"),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              _dataCell(
                                formatDateShort(
                                  DateTime.tryParse(
                                    paymentBepariModel!.masterModel!.timestamp!,
                                  )!,
                                ),
                              ),
                              _dataCell(
                                "${paymentBepariModel!.masterModel!.openingBalance}",
                              ),
                              this.isReceiving
                                  ? _dataCell(
                                      "${_openingBalanceLeftForReceving()}",
                                    )
                                  : _dataCell(
                                      "${_openingBalanceLeft()}",
                                    ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      _billsLength != 0
                          ? DataTable(
                              columns: [
                                _dataColumn("Bills"),
                                _dataColumn("Amount\nto Pay (Rs.)"),
                                _dataColumn("Bal Amount\n(Rs.)"),
                              ],
                              rows: [
                                for (int i = 0; i < _billsLength; i++)
                                  DataRow(
                                    cells: [
                                      _dataCell(
                                        formatDateShort(
                                          DateTime.tryParse(
                                            paymentBepariModel!
                                                .billEntryModels![i]
                                                .selectedTimestamp,
                                          )!,
                                        ),
                                      ),
                                      _dataCell(
                                        paymentBepariModel!
                                            .billEntryModels![i].netAmount,
                                      ),
                                      _dataCell(
                                        "${_billAmountLeft(i)}",
                                      ),
                                    ],
                                  ),
                              ],
                            )
                          : const SizedBox.shrink(),

                      // IF BALANCE AMOUNT == 0 DO NOT SHOW TEXFIELD
                      _showAmountToPayTextfield(),

                      // SHOW AMOUNT TO RECEIVE TEXTFIELD
                      _showAmountToReceiveTextfield(),
                      SizedBox(height: 16.h),
                    ],
                  ),
                  // ---- DRAGGABLE SHEET --------
                  _DraggableScrollableSheetCustom(
                    balAmtToPay: paymentBepariModel!.balAmtToPay!,
                    balAmtToReceive: paymentBepariModel!.balAmtToReceive!,
                    paidAmount: paymentBepariModel!.paidAmount!,
                    receivedAmount: paymentBepariModel!.receivedAmount!,
                    showReceivingWidgets: showRecevingWidgets,
                    showPayingWidgets: showPayingWidgets,
                    animationController: _controller,
                    tween: _tween,
                  ),
                  // ------------------------------
                ],
              );
            }

            return circularProgress();
          }),
    );
  }

  DataCell _dataCell(String text) {
    return DataCell(
      Text(
        text,
      ),
    );
  }

  DataColumn _dataColumn(String text) {
    return DataColumn(
      label: Expanded(
        child: Text(
          text,
        ),
      ),
    );
  }

  Color _genreColor() {
    if (paymentBepariModel!.masterModel!.debitOrCredit == "Debit") {
      return Colors.red;
    }

    return Colors.green[700]!;
  }

  Widget _showAmountToPayTextfield() {
    if (showPayingWidgets) {
      return _amountToPayTextField();
    }

    return const SizedBox.shrink();
  }

  Column _amountToPayTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _billsLength != 0 ? 6.h : 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Enter below the Amount Paid (Rs.)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Divider(
          thickness: 1,
          height: 0,
        ),
        _enterPayingTextField(),
        showRecevingWidgets ? SizedBox.shrink() : SizedBox(height: 3.h),
      ],
    );
  }

  _showAmountToReceiveTextfield() {
    if (showRecevingWidgets) {
      return _amountToReceiveTextField();
    }

    return const SizedBox.shrink();
  }

  Column _amountToReceiveTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: _billsLength != 0 ? 6.h : 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Enter below the Amount Received (Rs.)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Divider(
          thickness: 1,
          height: 0,
        ),
        _enterreceivingTextField(),
      ],
    );
  }

  Padding _date() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        onTap: () async {
          final datePicked = await showDate(
            context,
            title: "Select Date",
            selectedDate: DateTime.now(),
          );

          if (datePicked != null) {
            _selectedDate = datePicked;
            _dateCntrl.text = formatDate(_selectedDate);
          }
        },
        controller: _dateCntrl,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date",
        ),
      ),
    );
  }

  StreamBuilder<bool> _enterPayingTextField() {
    return StreamBuilder<bool>(
        stream: _paymentCheckedBLOC.readOnlyTextfieldStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final readOnly = snapshot.data;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                color: readOnly! ? DISABLEDCOLOR : Colors.transparent,
                child: TextFormField(
                  readOnly: readOnly,
                  controller: _paymentCntrl,
                  decoration: InputDecoration(
                    labelText: "Amount Paid",
                  ),
                ),
              ),
            );
          }

          return SizedBox.shrink();
        });
  }

  Padding _enterreceivingTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        controller: _receivingCntrl,
        decoration: InputDecoration(
          labelText: "Amount Received",
        ),
      ),
    );
  }

  _bepariNameTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: TextFormField(
        controller: _bepariNameCntrl,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Bepari Name",
        ),
      ),
    );
  }

// ---------------- EVENTS -----------------------------------------------------

  // SET ATTRIBUTES AFTER ASSIGNING
  void _setAttributes() {
    _bepariNameCntrl.text = paymentBepariModel!.bepariName!;

    // Set Bills length
    if (paymentBepariModel!.billEntryModels != null) {
      _billsLength = paymentBepariModel!.billEntryModels!.length;
    }

    // Set isReceiving to true to show receving fields
    if (double.parse(paymentBepariModel!.balAmtToReceive!).round() != 0) {
      showRecevingWidgets = true;
    } else {
      showRecevingWidgets = false;
    }

    if (paymentBepariModel!.masterModel!.debitOrCredit == "Debit") {
      isReceiving = true;
    } else {
      isReceiving = false;
    }

    if (double.parse(paymentBepariModel!.balAmtToPay!).round() != 0) {
      showPayingWidgets = true;
    }
  }

  PaymentBepariModel _getANewInstance(PaymentBepariModel paymentBepariModel) {
    PaymentBepariModel newModel = PaymentBepariModel(
      documentId: paymentBepariModel.documentId,
      timestamp: paymentBepariModel.timestamp,
      selectedTimestamp: paymentBepariModel.selectedTimestamp,
      dateHash: paymentBepariModel.dateHash,
      bepariName: paymentBepariModel.bepariName,
      paidAmount: paymentBepariModel.paidAmount,
      pendingAmount: paymentBepariModel.pendingAmount,
      receivingAmount: paymentBepariModel.receivingAmount,
      receivedAmount: paymentBepariModel.receivedAmount,
      balAmtToPay: paymentBepariModel.balAmtToPay,
      balAmtToReceive: paymentBepariModel.balAmtToReceive,
      masterModel: paymentBepariModel.masterModel,
      billEntryModels: paymentBepariModel.billEntryModels,
    );

    return newModel;
  }

  _checkReceived() async {
    if (_receivingCntrl.text.isEmpty) return;

    double receivingAmount = double.parse(
      _receivingCntrl.text.trim(),
    );

    PaymentBepariModel paymentBepariModel =
        await _calculateBillsBLOC.stream.last;

    paymentBepariModel.receivedAmount = receivingAmount.toString();

    _calculateBillsBLOC.sink(
      _getANewInstance(paymentBepariModel),
    );
  }

// CLICK ON CHECK
  _check() {
    // -------- Freeze textfield
    _disableCheckButton();
    _setUndoParameters();

    late PaymentBepariModel model;

    if (_paymentCntrl.text.isEmpty) return;

    model = PaymentBepariModel(
      documentId: paymentBepariModel!.documentId,
      timestamp: paymentBepariModel!.timestamp,
      selectedTimestamp: paymentBepariModel!.selectedTimestamp,
      dateHash: paymentBepariModel!.dateHash,
      bepariName: paymentBepariModel!.bepariName,
      paidAmount: paymentBepariModel!.paidAmount,
      pendingAmount: paymentBepariModel!.pendingAmount,
      receivingAmount: paymentBepariModel!.receivingAmount,
      receivedAmount: paymentBepariModel!.receivedAmount,
      balAmtToPay: paymentBepariModel!.balAmtToPay,
      balAmtToReceive: paymentBepariModel!.balAmtToReceive,
      masterModel: paymentBepariModel!.masterModel,
      billEntryModels: paymentBepariModel!.billEntryModels,
    );

    Map<String, String> dataMap = {};

    dataMap['openingBalance'] = model.masterModel!.openingBalance.toString();
    int billNo = 1;

    model.billEntryModels!.forEach(
      (bill) {
        dataMap[billNo.toString()] = bill.netAmount;
        billNo++;
      },
    );

    double payingAmount = double.parse(_paymentCntrl.text.trim());
    double amountToPay = double.parse(model.balAmtToPay!);
    double balAmountToPay = 0;

    if (payingAmount == amountToPay) {
      balAmountToPay = payingAmount - amountToPay;

      dataMap.forEach(
        (key, value) {
          dataMap[key] = '0';
        },
      );
    } else if (payingAmount < amountToPay) {
      balAmountToPay = amountToPay - payingAmount;

      for (var key in dataMap.keys) {
        String value = dataMap[key]!;

        double eachBill = double.parse(value);

        if (payingAmount > eachBill) {
          payingAmount = payingAmount - eachBill;
          dataMap[key] = '0';
        } else if (payingAmount <= eachBill) {
          double eachBillAmountLeft = eachBill - payingAmount;
          dataMap[key] = eachBillAmountLeft.toString();
          break;
        }
      }
    } else if (payingAmount > amountToPay) {
      dataMap.forEach(
        (key, value) {
          dataMap[key] = '0';
        },
      );

      double amountLeft = payingAmount - amountToPay;
      model.balAmtToReceive = amountLeft.toString();
    }

    model.balAmtToPay = balAmountToPay.toString();

    // ------ Show Opening Balance ----

    if (isReceiving) {
    } else {
      double amountLeft = double.parse(
            model.masterModel!.openingBalance.toString(),
          ) -
          double.parse(
            dataMap['openingBalance']!,
          );

      model.masterModel!.openingBalancePaid = amountLeft.toString();
    }

    int i = 0;
    for (var key in dataMap.keys) {
      if (key == 'openingBalance') continue;

      double amountLeft = double.parse(
            model.billEntryModels![i].netAmount,
          ) -
          double.parse(
            dataMap[key]!,
          );

      model.billEntryModels![i].billPaid = amountLeft.toString();
      i++;
    }

    // SINK
    _calculateBillsBLOC.sink(model);

    // print(dataMap);

    widget.getEntriesPaymentBepariBLOC.getEntries();
  }

  double getValueUpto2Precisions(double value) {
    return double.parse(value.toStringAsFixed(3));
  }

  // CALCULATE OPENING BALANCE
  double _openingBalanceLeft() {
    double openingBalLeft = 0;

    if (paymentBepariModel != null) {
      openingBalLeft = paymentBepariModel!.masterModel!.openingBalance -
          double.parse(
            paymentBepariModel!.masterModel!.openingBalancePaid,
          );
    }

    return getValueUpto2Precisions(openingBalLeft);
  }

  // CALCULATE OPENING BAL FOR RECEVING
  double? _openingBalanceLeftForReceving() {
    double openingBalLeft = 0;

    if (paymentBepariModel != null) {
      openingBalLeft = paymentBepariModel!.masterModel!.openingBalance -
          double.parse(
            paymentBepariModel!.masterModel!.openingBalanceReceived,
          );
    }

    return getValueUpto2Precisions(openingBalLeft);
  }

  // CALCULATE BILL AMOUNT
  double _billAmountLeft(int index) {
    if (paymentBepariModel != null) {
      return double.parse(
            paymentBepariModel!.billEntryModels![index].netAmount,
          ) -
          double.parse(
            paymentBepariModel!.billEntryModels![index].billPaid,
          );
    }

    return 0;
  }

  // Freeze the textfield and disable check button
  void _disableCheckButton() {
    _paymentCheckedBLOC.sink(true);
  }

  void _setUndoParameters() async {
    paymentBepariModel!.billEntryModels!.forEach(
      (billModel) {
        print("From stack before pushing" + billModel.billPaid);
      },
    );
  }

  void _undo() async {
    _setAttributes();
    _paymentCheckedBLOC.sink(false);
    await _calculateBillsBLOC.init();
  }

// -----------------------------------------------------------------------------

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: "View ",
      actions: [
        // UNDO Button
        _UndoButton(
          paymentCheckedBLOC: _paymentCheckedBLOC,
          onPressed: _undo,
        ),

        // CHECK Button
        _CheckButton(
          paymentCheckedBLOC: _paymentCheckedBLOC,
          onPressed: () {
            _check();
          },
        ),

        // ICON BUTTON TICK
        IconButton(
          onPressed: () {
            _checkReceived();

            // _seeTheStack();
            // if (_controller.isDismissed) {
            //   _controller.forward();
            // } else if (_controller.isCompleted) _controller.reverse();
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateCntrl.dispose();
    _calculateBillsBLOC.dispose();
    _bepariNameCntrl.dispose();
    _paymentCntrl.dispose();
    _paymentCheckedBLOC.dispose();

    super.dispose();
  }
}

// --------------------- UNDO Button -------------------------------------------

class _UndoButton extends StatelessWidget {
  const _UndoButton({
    required this.paymentCheckedBLOC,
    required this.onPressed,
  });

  final PaymentCheckedBLOC paymentCheckedBLOC;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: paymentCheckedBLOC.undoButtonStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final isEnabled = snapshot.data;

            return TextButton(
              onPressed: isEnabled! ? () => onPressed() : null,
              child: Text(
                "Undo",
                style: TextStyle(
                  color: isEnabled ? BLACK : Colors.black45,
                  fontWeight: FontWeight.w300,
                  fontSize: 10.sp,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        });
  }
}

// ------------------------ CHECK Button ---------------------------------------

class _CheckButton extends StatelessWidget {
  final PaymentCheckedBLOC paymentCheckedBLOC;
  final Function onPressed;

  const _CheckButton({
    Key? key,
    required this.paymentCheckedBLOC,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: this.paymentCheckedBLOC.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final checked = snapshot.data;

            return TextButton(
              onPressed: checked! ? null : () => this.onPressed(),
              child: Text(
                "Check",
                style: TextStyle(
                  color: checked ? Colors.black45 : BLACK,
                  fontWeight: FontWeight.w300,
                  fontSize: 10.sp,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        });
  }
}

// ------------------ DRAGGABLE SHEET CUSTOM -----------------------------------

class _DraggableScrollableSheetCustom extends StatelessWidget {
  final String balAmtToPay;
  final String paidAmount;
  final String balAmtToReceive;
  final String receivedAmount;
  final bool showReceivingWidgets;
  final bool showPayingWidgets;
  final AnimationController animationController;
  final Tween<Offset> tween;

  const _DraggableScrollableSheetCustom({
    Key? key,
    required this.balAmtToPay,
    required this.paidAmount,
    required this.balAmtToReceive,
    required this.receivedAmount,
    required this.showReceivingWidgets,
    required this.showPayingWidgets,
    required this.animationController,
    required this.tween,
  }) : super(key: key);

  double _maxDraggableSize() {
    return 0.47;
  }

  double _initialChildSize() {
    if (showReceivingWidgets && showPayingWidgets) {
      return 0.47;
    } else if (!showReceivingWidgets && !showPayingWidgets) {
      return 0.05;
    }

    return 0.65 / 2;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SlideTransition(
        position: tween.animate(animationController),
        child: DraggableScrollableSheet(
          expand: false,
          maxChildSize: _maxDraggableSize(),
          initialChildSize: _initialChildSize(),
          minChildSize: 0.05,
          builder: (context, controller) {
            return Container(
              color: CYAN900,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                controller: controller,
                children: [
                  _DraggableContainer(),
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Text(
                      'Total ',
                      style: TextStyle(
                        color: WHITE,
                        // fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),

                  // SHOW AMOUNT TO PAY LIST-TILE
                  _showPayingWidgets(),

                  // SHOW AMOUNT TO RECEIVE LIST-TILE
                  _showReceivingWidgets(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _showPayingWidgets() {
    if (showPayingWidgets) {
      return _payingWidgets();
    }

    return const SizedBox.shrink();
  }

  Column _payingWidgets() {
    return Column(
      children: [
        _listTile(
          leading: "Amount to Pay",
          trailing: balAmtToPay,
        ),
        _listTile(
          leading: "Amount Paid",
          trailing: paidAmount,
        ),
      ],
    );
  }

  Widget _showReceivingWidgets() {
    if (showReceivingWidgets) {
      return _receivingWidgets();
    }

    return const SizedBox.shrink();
  }

  Column _receivingWidgets() {
    return Column(
      children: [
        if (showReceivingWidgets && showPayingWidgets)
          Divider(
            color: BLACK,
            thickness: 0.6,
          ),
        _listTile(
          leading: "Amount to Receive",
          trailing: balAmtToReceive,
        ),
        _listTile(
          leading: "Amount Received",
          trailing: receivedAmount,
        ),
      ],
    );
  }

  Padding _listTile({
    required String leading,
    required String trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _text(leading),
          _text("Rs. " + trailing),
        ],
      ),
    );
  }

  _text(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

// THE VERTICAL BLACK CONTAINER USED FOR DRAGGING THE DRGGABLE SCROLLABLE WIDGET
class _DraggableContainer extends StatelessWidget {
  const _DraggableContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 0.8.h,
        width: 18.w,
        decoration: BoxDecoration(
          color: BLACK,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
