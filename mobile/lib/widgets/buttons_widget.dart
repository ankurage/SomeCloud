import 'package:flutter/material.dart';

class AnimatedElevatedButton extends StatefulWidget {
  @override
  State<AnimatedElevatedButton> createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton> {
  double horizontPadding = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (a) => setState(() {
        horizontPadding = 30;
      }),
      onTapUp: (a) => setState(() {
        horizontPadding = 10;
      }),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsetsGeometry.symmetric(horizontal: horizontPadding)
        ),
        onPressed: null,
        child: Text("Button!")
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  Widget child;
  VoidCallback onPressed;
  bool left; // false - turn right | true - turn left

  IconButtonWidget({
    required this.child,
    required this.onPressed,
    this.left = false,
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
            topRight: Radius.circular(left ? 0 : 20),
            bottomRight: Radius.circular(left ? 0 : 20),
            bottomLeft: Radius.circular(left ? 20 : 0),
            topLeft: Radius.circular(left ? 20 : 0),
          ),
        ),
      ),
      onPressed: onPressed,
      icon: child,
    );
  }
}