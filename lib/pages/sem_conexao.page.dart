import 'package:flutter/material.dart';
import 'package:prj/widgets/centered_message.dart';

class SemConexaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredMessage(
        icon: Icons.local_movies,
        title: "No internet connection",
        subtitle: "Connect to the internet to use the app",
      ),
    );
  }
}
