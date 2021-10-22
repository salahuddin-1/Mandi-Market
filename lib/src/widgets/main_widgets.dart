import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:sizer/sizer.dart';

class MainTitleBox extends StatelessWidget {
  final String title;
  final Function onPressed;

  const MainTitleBox({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 7,
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Center(
              child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

AppBar appbarMain() {
  return AppBar(
    centerTitle: true,
    title: Text(
      'Mandi Market',
      style: TextStyle(
        color: WHITE,
      ),
    ),
    elevation: 10,
  );
}
