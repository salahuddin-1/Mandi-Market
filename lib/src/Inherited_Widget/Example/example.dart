import 'package:flutter/material.dart';

class ExampleInheritedWidget extends InheritedWidget {
  final Widget child;
  final String data;
  final int numData;

  ExampleInheritedWidget({
    Key? key,
    required this.child,
    required this.data,
    required this.numData,
  }) : super(
          child: child,
          key: key,
        );

  static ExampleInheritedWidget of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ExampleInheritedWidget>()
        as ExampleInheritedWidget);
  }

  @override
  bool updateShouldNotify(_) {
    return true;
  }
}

class HoldTheData {
  static String? _data;

  static String get data => _data!;

  setData(String data) {
    _data = data;
  }
}
