import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:sizer/sizer.dart';
import 'Calculation_parameter/table_parameter.dart';
import 'Opening_balance/enter_opening_balance.dart';

class AdministratorScreen extends StatefulWidget {
  @override
  _AdministratorScreenState createState() => _AdministratorScreenState();
}

class _AdministratorScreenState extends State<AdministratorScreen> {
  late final EnterOpeningBalance _enterOpeningBalance;

  @override
  void initState() {
    _enterOpeningBalance = EnterOpeningBalance(context);
    super.initState();
  }

  @override
  void dispose() {
    _enterOpeningBalance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        padding: EdgeInsets.only(top: 3.h, bottom: 15.h),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _LeftChild(
                      title: "Calculation Parameter",
                      onTap: () {
                        onTapAdministrator(context);
                      },
                    ),
                    _RightChild(
                      title: "Opening Balance",
                      onTap: () {
                        onTapOpeningBal();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    _LeftChild(
                      title: "Partnership Amount",
                      onTap: () {
                        // onTapAdministrator(context);
                      },
                    ),
                    _RightChild(
                      title: "KYC (Customer Rating)",
                      onTap: () {
                        // onTapAdministrator(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTapAdministrator(BuildContext context) {
    Push(
      context,
      pushTo: SetParameter(),
    );
  }

  onTapOpeningBal() {
    _enterOpeningBalance.showdialog();
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        'Mandi Market',
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}

class _LeftChild extends StatelessWidget {
  final String title;
  final Function onTap;

  const _LeftChild({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        ),
        // height: 14.h,
        margin: EdgeInsets.only(left: 3.w, right: 1.5.w),
        child: Material(
          color: YELLOW700,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Ink(
              child: Center(
                child: Text(
                  title,
                  textScaleFactor: 0.81.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RightChild extends StatelessWidget {
  final String title;
  final Function onTap;

  const _RightChild({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        ),
        // height: 14.h,
        margin: EdgeInsets.only(left: 1.5.w, right: 3.w),
        child: Material(
          color: YELLOW700,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Ink(
              child: Center(
                child: Text(
                  this.title,
                  textScaleFactor: 0.81.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
