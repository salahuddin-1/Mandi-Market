import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';

import 'add_parameter.dart';
import 'package:sizer/sizer.dart';

import 'table_parameter.dart';

class CurrentParameters extends StatefulWidget {
  @override
  _CurrentParametersState createState() => _CurrentParametersState();
}

class _CurrentParametersState extends State<CurrentParameters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
      children: [
        Card(
          color: Colors.grey.shade100,
          child: ListTile(
            title: Text("Discount (%)"),
            subtitle: Text("2"),
          ),
        ),
        Card(
          color: Colors.grey.shade100,
          child: ListTile(
            title: Text("Commission Re. 1 / unit"),
            subtitle: Text("2"),
          ),
        ),
        Card(
          color: Colors.grey.shade100,
          child: ListTile(
            title: Text("Karkuni (Rs)"),
            subtitle: Text("2"),
          ),
        ),
        Card(
          color: Colors.grey.shade100,
          child: ListTile(
            title: Text("Commission (Rs)"),
            subtitle: Text("2"),
          ),
        ),
      ],
    );
  }

  AppBar _appbar() {
    return AppBarCustom(context).appbar(
      title: 'Current Parameters',
      actions: [],
      onPressedAdd: () {
        Push(
          context,
          pushTo: SetParameter(),
        );
      },
    );
  }
}
