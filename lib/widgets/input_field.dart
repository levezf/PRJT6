

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String hint;
  final Stream<String> stream;
  final Function(String) onChanged;
  final bool obscure;
  final bool multiline;

  InputField({this.hint, this.stream, this.onChanged, this.obscure=false, this.multiline=true});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
            maxLines: (multiline) ? null : 1,
            decoration: InputDecoration(
//              hintText: hint,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
              ),
              labelText: hint,
              border: OutlineInputBorder(),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            obscureText: obscure,
          );
        }
    );
  }
}