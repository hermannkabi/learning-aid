import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {

  final Icon icon;
  final Color color;
  final Function onPressed;
  final Color splashColor;
  final int dim;

  CircleButton({@required this.onPressed, this.splashColor, @required this.icon, @required this.color, this.dim});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
        splashColor: splashColor ?? Colors.grey,
        child: CircleAvatar(
          backgroundColor: color,
          child: icon,
        ),
    );
  }
}
