import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  Widget child;
  VoidCallback onPressed;
  bool? left; // false - turn rounded corners right | true - turn rounded corners left
  EdgeInsetsGeometry buttonPadding;
  double cornerRound = 0;

  IconButtonWidget({
    required this.child,
    required this.onPressed,
    this.left,
    this.buttonPadding = EdgeInsetsGeometry.zero,
    this.cornerRound = 20
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return IconButton(
      padding: buttonPadding,
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

class IconButtonBackgroundWidget extends StatelessWidget {
  Widget child;
  Widget suffixIcon;
  Widget prefixIcon;
  VoidCallback? onPressedSuffix;
  VoidCallback? onPressedPrefix;
  bool? left; // false - turn rounded corners right | true - turn rounded corners left
  EdgeInsetsGeometry buttonPadding;
  EdgeInsetsGeometry childPadding;
  double cornerRound = 0;

  IconButtonBackgroundWidget({
    required this.child,
    this.suffixIcon = const SizedBox(),
    this.prefixIcon = const SizedBox(),
    this.onPressedSuffix,
    this.onPressedPrefix,
    this.left,
    this.buttonPadding = EdgeInsetsGeometry.zero,
    this.childPadding = EdgeInsetsGeometry.zero,
    this.cornerRound = 20
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      margin: EdgeInsetsGeometry.zero,
      color: theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(cornerRound))
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          prefixIcon == SizedBox
          ? SizedBox()
          : IconButton(
            padding: buttonPadding,
            style: IconButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(cornerRound))
              )
            ),
            onPressed: onPressedPrefix,
            icon: prefixIcon,
          ),
          Padding(
            padding: childPadding,
            child: child,
          ),
          suffixIcon == SizedBox
          ? SizedBox()
          : IconButton(
            padding: buttonPadding,
            style: IconButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(cornerRound))
              )
            ),
            onPressed: onPressedSuffix,
            icon: suffixIcon,
          ),
        ],
      ),
    );
  }
}
