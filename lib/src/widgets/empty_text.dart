import 'package:flutter/material.dart';

class EmptyText extends StatelessWidget {
  const EmptyText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "",
      style: TextStyle(
        fontSize: 11,
      ),
    );
  }
}
