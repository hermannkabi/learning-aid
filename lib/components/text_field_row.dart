import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldRow extends StatelessWidget {

  final String label;
  final TextEditingController controller;//Value goes here
  final double horizontalPadding;
  final TextInputType keyboardType;
  final int lines;
  final int minLines;
  final bool shouldNotExpand;
  final int maxLength;

  TextFieldRow({
    @required this.controller,
    @required this.label,
    this.horizontalPadding,
    this.keyboardType,
    this.lines,
    this.minLines,
    this.shouldNotExpand,
    this.maxLength,
  });



  @override
  Widget build(BuildContext context) {
    if(shouldNotExpand??false ==false){
      if (label.length>=20 || lines!=null) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding??25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label+": ", style: GoogleFonts.montserrat(fontSize: 18),),
                SizedBox(height: 5,),
                Expanded(
                  child: TextField(
                    maxLength: maxLength,
                    maxLengthEnforced: true,
                    style: Theme.of(context).textTheme.headline1,
                    controller: controller,
                    keyboardType: keyboardType??TextInputType.text,
                    maxLines: lines,
                    minLines: minLines,
                  ),
                ),
              ],
            ),),);
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding??25),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label+": ", style: GoogleFonts.montserrat(fontSize: 18),),
              SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  maxLength: maxLength,
                  maxLengthEnforced: true,
                  style: Theme.of(context).textTheme.headline1,
                  controller: controller,
                  keyboardType: keyboardType ?? TextInputType.text,
                ),
              )
            ],
          ),
        );
      }
    }else{
      if (label.length>=20 || lines!=null) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding??25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label+": ", style: GoogleFonts.montserrat(fontSize: 18),),
              SizedBox(height: 5,),
              TextField(
                maxLength: maxLength,
                maxLengthEnforced: true,
                style: Theme.of(context).textTheme.headline1,
                controller: controller,
                keyboardType: keyboardType??TextInputType.text,
                maxLines: lines,
                minLines: minLines,
              ),
            ],
          ),);
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding??25),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label+": ", style: GoogleFonts.montserrat(fontSize: 18),),
              SizedBox(width: 10,),
              TextField(
                maxLength: maxLength,
                maxLengthEnforced: true,
                style: Theme.of(context).textTheme.headline1,
                controller: controller,
                keyboardType: keyboardType ?? TextInputType.text,
              )
            ],
          ),
        );
      }
    }
  }


}
