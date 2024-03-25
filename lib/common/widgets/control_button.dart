import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  const ControlButton(
      {Key? key,
      required this.child,
      required this.backgroundColor,
      required this.borderColor,
      required this.onPressed})
      : super(key: key);

  final Widget child;
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        height: 50,
        minWidth: 230,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor, width: 3),
            borderRadius: BorderRadius.circular(25.0)),
        color: backgroundColor,
        child: child,
      ),
    );
  }
}
