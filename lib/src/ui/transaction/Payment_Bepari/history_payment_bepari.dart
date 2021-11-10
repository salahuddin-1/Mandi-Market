import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/widgets/app_bar.dart';

import 'package:sizer/sizer.dart';

class HistoryPaymentBepari extends StatefulWidget {
  const HistoryPaymentBepari({Key? key}) : super(key: key);

  @override
  _HistoryPaymentBepariState createState() => _HistoryPaymentBepariState();
}

class _HistoryPaymentBepariState extends State<HistoryPaymentBepari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                isThreeLine: true,
                leading: Text(
                  "1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // height: 2.5,
                  ),
                ),
                title: Text(
                  "2 October, 2021",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      "Name : Zoro ",
                      style: _subtitleTextStyle(),
                    ),
                    Row(
                      children: [
                        Text(
                          "Pending Amount :  ",
                          style: _subtitleTextStyle(),
                        ),
                        FittedBox(
                          child: Text(
                            "Rs. 1000000",
                            style: _subtitleTextStyle(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Paid Amount :  ",
                          style: _subtitleTextStyle(),
                        ),
                        FittedBox(
                          child: Text(
                            "Rs. 1000000",
                            style: _subtitleTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
              Divider(
                color: BLACK,
                height: 25,
              ),
            ],
          );
        },
      ),
    );
  }

  _subtitleTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: BLACK,
      letterSpacing: 0.7,
      height: 1.6,
    );
  }

  _appbar() {
    return AppBarCustom(context).appbar(
      title: 'Logs',
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}
