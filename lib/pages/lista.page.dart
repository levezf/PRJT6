import 'package:flutter/material.dart';
import 'package:prj/colors.dart';

class ListaPage extends StatelessWidget {

  final List<Widget> children;
  final String title;

  ListaPage({@required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
        leading: CloseButton(),
      ),

    );
  }

}
