import 'package:flutter/material.dart';


class SquareButton extends StatelessWidget {

  final int length;
  final Icon icon;
  final Color color;
  final Color splashColor;
  final Function onPressed;

  SquareButton({@required this.length, @required this.icon, @required this.color, this.splashColor, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.0),
      child: InkWell(
        onTap: onPressed,
        splashColor: splashColor ?? Colors.grey,
        child: Container(
          color: color,
          height: length.toDouble(),
          width: length.toDouble(),
          child: icon,
        ),
      ),
    );
  }
}
