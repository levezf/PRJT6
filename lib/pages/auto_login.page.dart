

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/pages/home.page.dart';
import 'package:prj/widgets/custom_loading.dart';

import 'login.page.dart';

class AutoLoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //todo verificar se ja esta logado
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_){
          if(BlocProvider.getBloc<UsuarioBloc>().isLogged()){
            return HomePage();
          }else{
            return LoginPage();
          }
        }
      ));
    });

    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        Hero(
          tag: "logo",
          child: Image.asset("assets/logo.png",height: 200, width: 200,),
        ),

        CustomLoading(),
      ],
    ),);
  }
}
