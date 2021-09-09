import 'package:flutter/material.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:mandimarket/src/ui/master/master_type_table.dart';
import 'package:sizer/sizer.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Container(
        padding: EdgeInsets.only(top: 1.5.h),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild(
                    "Bepari",
                    onTap: () {
                      onTapMasterType(context, "Bepari");
                    },
                  ),
                  _rightChild(
                    "Customer",
                    onTap: () {
                      onTapMasterType(context, "Customer");
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild(
                    "Gawal",
                    onTap: () {
                      onTapMasterType(context, "Gawal");
                    },
                  ),
                  _rightChild(
                    "Pedi",
                    onTap: () {
                      onTapMasterType(context, "Pedi");
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild(
                    "Other Parties",
                    onTap: () {
                      onTapMasterType(context, "Other Parties");
                    },
                  ),
                  _rightChild(
                    "Gawal Account",
                    onTap: () {
                      onTapMasterType(context, "Gawal Account");
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  _leftChild(
                    "Dawan",
                    onTap: () {
                      onTapMasterType(context, "Dawan");
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  // _rightChild("Gawal Account"),
                ],
              ),
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

  Expanded _rightChild(String title, {Function? onTap}) {
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
        height: 14.h,
        margin: EdgeInsets.only(left: 1.5.w, right: 3.w),
        child: Material(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              onTap!();
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

  Expanded _leftChild(String title, {Function? onTap}) {
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
        height: 14.h,
        margin: EdgeInsets.only(left: 3.w, right: 1.5.w),
        child: Material(
          color: Colors.yellow[700],
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              onTap!();
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
