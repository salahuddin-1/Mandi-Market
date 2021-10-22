import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/Master1/table_master.dart';
import 'package:mandimarket/src/widgets/main_widgets.dart';
import 'package:sizer/sizer.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(),
      body: Container(
        padding: EdgeInsets.only(top: 2.h, bottom: 3.h),
        child: Column(
          children: [
            MainTitleBox(
              title: "Bepari",
              onPressed: () {
                onTapMasterType(context, 'Bepari');
              },
            ),
            MainTitleBox(
              title: "Customer",
              onPressed: () {
                onTapMasterType(context, 'Customer');
              },
            ),
            MainTitleBox(
              title: "Dawan",
              onPressed: () {
                onTapMasterType(context, 'Dawan');
              },
            ),
            MainTitleBox(
              title: "Gawaal",
              onPressed: () {
                onTapMasterType(context, 'Gawaal');
              },
            ),
            MainTitleBox(
              title: "Other Parties",
              onPressed: () {
                onTapMasterType(context, 'OtherParties');
              },
            ),
          ],
        ),
      ),
    );
  }

  onTapMasterType(BuildContext context, String type) {
    Push(
      context,
      pushTo: MasterTable(
        type: type,
      ),
    );
  }
}
