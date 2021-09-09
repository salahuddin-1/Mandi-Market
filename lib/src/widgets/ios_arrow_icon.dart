import 'package:flutter/material.dart';

class IosArrowIcon extends StatelessWidget {
  final Function onPressed;
  const IosArrowIcon({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_sharp),
      onPressed: () => onPressed(),
    );
  }
}
