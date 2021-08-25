import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/images.dart';
import 'package:mandimarket/src/resources/navigation.dart';
import 'package:sizer/sizer.dart';

class WelcomeCard {
  static welcomeCard(BuildContext oldContext) {
    return showDialog(
      context: oldContext,
      builder: (context) {
        return Container(
          child: Center(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        _closeButton(context),
                        SizedBox(height: 5.h),
                        _welcomeUser(),
                        SizedBox(height: 1.h),
                        _customerId(),
                        SizedBox(height: 10.h),
                        Container(
                          decoration: _dialogBoxDecoration(),
                          height: 30.h,
                          width: 80.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _logo(),
                                  _userInformation(),
                                ],
                              ),
                              Text("Sheep & Goat Commision Agent")
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        _closeTextButton(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        );
      },
    );
  }

  static BoxDecoration _dialogBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(4, 4),
          blurRadius: 12,
          spreadRadius: -8,
        ),
      ],
    );
  }

  static Row _closeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Pop(context),
          icon: Icon(
            Icons.close,
          ),
        ),
      ],
    );
  }

  static TextButton _closeTextButton(BuildContext context) {
    return TextButton(
      onPressed: () => Pop(context),
      child: Text(
        "Close",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  static TextStyle _userInformationStyle() {
    return TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static Container _userInformation() {
    return Container(
      width: 55.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gochi private limited",
            style: _userInformationStyle(),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Plot no 1, Mandli Talav, Opp Atlake hotel, Mandli talav, Bhayander west, Thane 40101 near malisudha tower",
            style: _userInformationStyle(),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "8898911744",
            style: _userInformationStyle(),
          ),
        ],
      ),
    );
  }

  static Container _logo() {
    return Container(
      height: 15.w,
      width: 15.w,
      child: Image.asset(CustomImages.logos[9]),
    );
  }

  static FittedBox _customerId() {
    return FittedBox(
      child: Row(
        children: [
          Text(
            'Customer id :  ',
          ),
          Text(
            '8898199744',
          ),
        ],
      ),
    );
  }

  static TextStyle _welcomeUserStyle() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static FittedBox _welcomeUser() {
    return FittedBox(
      child: Row(
        children: [
          Text(
            'Welcome  ',
            style: _welcomeUserStyle(),
          ),
          Text(
            'Salahuddin Shaikh',
            style: _welcomeUserStyle(),
          ),
        ],
      ),
    );
  }
}
