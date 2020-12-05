import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color color;
  final String label;
  final void Function() onPressed;
  final Icon icon;
  final Color splashColor;

  Button({this.color, this.label, this.onPressed, this.icon, this.splashColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Ink(
        color: color,
        child: InkWell(
          onTap: onPressed,
          splashColor: splashColor ?? Colors.grey[800],
          child: Container(
                height: 60,
                child: icon == null ?Center(child: Text(label, style: Theme.of(context).textTheme.button,),) :
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    icon,
                    Text(label, style: Theme.of(context).textTheme.button,),
                    Text(""),
                  ],),
                ),
          ),
        ),
      ),
    );
  }
}
