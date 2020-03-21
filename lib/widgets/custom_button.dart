import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  
  final String text;
  final Icon icon;
  final Function onPressed;
  final EdgeInsets padding;
  final MaterialColor color;

  CustomButton({this.text, this.icon, this.onPressed, this.padding, this.color});
  
  @override
  Widget build(BuildContext context) {

    if(icon==null){
      return RaisedButton(
        color: color!=null?color:null,
        padding: padding,
        onPressed: onPressed,
        child: Text(text),
      );
    }
    return RaisedButton.icon(
      onPressed: onPressed, icon: icon, label: Text(text),
    );
  }
}