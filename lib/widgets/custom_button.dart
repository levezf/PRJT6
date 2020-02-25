import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  
  final String text;
  final Icon icon;
  final Function onPressed;

  CustomButton({this.text, this.icon, this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: onPressed, icon: icon, label: Text(text),
    );
  }
}