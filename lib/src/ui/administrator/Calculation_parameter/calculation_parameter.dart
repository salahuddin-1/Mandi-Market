import 'package:flutter/material.dart';
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
  final _listItems = [
    'Discount',
    'Commission',
    'Karkuni',
    'Re. 1 / Commission'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  _body() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
        horizontal: 3.w,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          elevation: 7,
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: ListTile(
              title: Text(
                'Set ${_listItems[index]} value',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                // Push(
                //   context,
                //   pushTo: SetParameter(
                //     title: _listItems[index],
                //   ),
                // );

                Push(context, pushTo: CurrentParameters());
              },
            ),
          ),
        );
      },
    );
  }

  AppBar _appbar() {
    return AppBar(
      elevation: 10,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp),
        iconSize: 15.sp,
        onPressed: () {
          Pop(context);
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      title: Text(
        'Calculation Parameter',
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
          ),
        ),
      ],
      centerTitle: true,
    );
  }
}
