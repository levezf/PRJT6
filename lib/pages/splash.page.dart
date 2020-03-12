import 'package:flutter/material.dart';

import 'auto_login.page.dart';

class SplashPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => AutoLoginPage()
      ));
    });

    return Scaffold(
      body: Center(
        child: Hero(
            tag: "logo",
            child: Image.asset("assets/logo.png", height: 200, width: 200,)),
      ),
    );
  }
}
