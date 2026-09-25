import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  Widget child;
  VoidCallback onPressed;
  bool ?left; // false - turn right | true - turn left
  double cornerRound = 0;

  IconButtonWidget({
    required this.child,
    required this.onPressed,
    this.left,
    this.cornerRound = 20
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return IconButton(
      // padding: EdgeInsets.symmetric(vertical: 13),
      style: IconButton.styleFrom(
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: left == null
              ? Radius.circular(cornerRound)
              : (left == true ? Radius.zero : Radius.circular(cornerRound)),
            bottomRight: left == null
              ? Radius.circular(cornerRound)
              : (left == true ? Radius.zero : Radius.circular(cornerRound)),
            bottomLeft: left == null
              ? Radius.circular(cornerRound)
              : (left == true ? Radius.circular(cornerRound) : Radius.zero),
            topLeft: left == null
              ? Radius.circular(cornerRound)
              : (left == true ? Radius.circular(cornerRound) : Radius.zero),
          ),
        ),
      ),
      onPressed: onPressed,
      icon: child,
    );
  }
}