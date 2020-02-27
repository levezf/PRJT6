import 'package:flutter/material.dart';
import 'package:prj/widgets/centered_message.dart';

class SemConexaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredMessage(
        icon: Icons.local_movies,
        title: "Sem conexão com a internet",
        subtitle: "Conecte-se a internet para utilizar o aplicativo",
      ),
    );
  }
}
