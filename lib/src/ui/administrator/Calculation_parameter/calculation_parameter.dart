import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/administrator/Calculation_parameter/table_parameter.dart';
import 'package:sizer/sizer.dart';

import 'current_parameters.dart';

class CalculationParameterScreen extends StatefulWidget {
  @override
  _CalculationParameterScreenState createState() =>
      _CalculationParameterScreenState();
}

class _CalculationParameterScreenState
    extends State<CalculationParameterScreen> {
  final _listItems = ['Bepari', 'Dalal', 'Customer', 'Dawan', 'Gaval'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  _body() {
    return Column(
      children: [
        for (int i = 0; i < 5; i++)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 7,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(2.h),
                        child: ListTile(
                          title: Text(
                            'Purchase Book',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 7,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(2.h),
                        child: ListTile(
                          title: Text(
                            'Billing Entry',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  AppBar _appbar() {
    return AppBar(
      // backgroundColor: WHITE,
      elevation: 10,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back_ios_sharp),
      //   iconSize: 15.sp,
      //   onPressed: () {
      //     Pop(context);
      //   },
      // ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(40),
      //   ),
      // ),
      title: Text(
        'Mandi market',
        style: TextStyle(color: WHITE),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () {},
      //     icon: Icon(
      //       Icons.search,
      //     ),
      //   ),
      // ],
      centerTitle: true,
    );
  }
}
