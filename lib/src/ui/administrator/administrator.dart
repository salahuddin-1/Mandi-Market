import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/main_widgets.dart';
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
      appBar: appbarMain(),
      body: Container(
        padding: EdgeInsets.only(top: 2.h, bottom: 15.h),
        child: Column(
          children: [
            MainTitleBox(
              title: "Calculation Parameter",
              onPressed: onTapAdministrator,
            ),
            MainTitleBox(
              title: "Opening Balance",
              onPressed: onTapOpeningBal,
            ),
            MainTitleBox(
              title: "Partnership Amount",
              onPressed: () {},
            ),
            MainTitleBox(
              title: "KYC (Customer Rating)",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

// ------------------------------ EVENTS ------------------------------------------

  void onTapAdministrator() {
    Push(
      context,
      pushTo: SetParameter(),
    );
  }

  void onTapOpeningBal() {
    _enterOpeningBalance.showdialog();
  }
}
