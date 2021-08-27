import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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

class PushAndRemoveUntilWithoutNavBar {
  static Future<T?> push<T>(
    BuildContext context, {
    required Widget screen,
    bool? withNavBar,
    PageTransitionAnimation pageTransitionAnimation =
        PageTransitionAnimation.cupertino,
    PageRoute? customPageRoute,
  }) {
    if (withNavBar == null) {
      withNavBar = true;
    }

    return Navigator.of(context, rootNavigator: !withNavBar).pushAndRemoveUntil(
      customPageRoute as Route<T>? ??
          getPageRoute(
            pageTransitionAnimation,
            enterPage: screen,
          ),
      (route) => false,
    );
  }
}
