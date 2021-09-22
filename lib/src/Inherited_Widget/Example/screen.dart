import 'package:flutter/material.dart';
import 'package:mandimarket/src/Inherited_Widget/Example/example.dart';

class InheritedWidgetExampleScreen extends StatelessWidget {
  const InheritedWidgetExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dInjection = ExampleInheritedWidget.of(context);
    // print(dInjection);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(HoldTheData.data),
            // Text(
            //   dInjection.numData.toString(),
            // ),
          ],
        ),
      ),
    );
  }
}

class All extends StatelessWidget {
  const All({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetExampleScreen();
  }
}
