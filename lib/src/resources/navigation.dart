import 'package:flutter/material.dart';

class Push {
  Push(
    BuildContext context, {
    required Widget pushTo,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pushTo),
    );
  }
}

class Pop {
  Pop(BuildContext context) {
    Navigator.pop(context);
  }
}

class PushAndRemoveUntil {
  PushAndRemoveUntil(
    BuildContext context, {
    required Widget pushAndRemoveTo,
  }) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => pushAndRemoveTo),
      (route) => false,
    );
  }
}
