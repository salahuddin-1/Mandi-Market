import 'package:flutter/material.dart';
import 'package:mandimarket/src/constants/colors.dart';
import 'package:mandimarket/src/resources/navigation.dart';

class DialogsCustom {
  static Future delete(
    BuildContext context, {
    Function? onPressedYes,
  }) {
    return showDialog(
      context: context,
      builder: (newContext) {
        return AlertDialog(
          title: Text("The party will be deleted. Are you sure ?"),
          actions: [
            TextButton(
              onPressed: () async {
                await onPressedYes!();
                Pop(newContext);
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Pop(newContext),
              child: Text(
                "No",
                style: TextStyle(
                  color: BLACK,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
