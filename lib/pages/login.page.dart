

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/cadastro.bloc.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/pages/cadastro.page.dart';
import 'package:prj/pages/home.page.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/input_field.dart';

import '../colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  UsuarioBloc _usuarioBloc;


  @override
  void initState() {
    _usuarioBloc =  BlocProvider.getBloc<UsuarioBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _themeFlatButton = Theme.of(context).textTheme.title.copyWith(
        color: kAccentColor,
        fontSize: 14
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Hero(
                    tag: "logo",
                    child: Image.asset("assets/logo.png",height: 200, width: 200,),
                  ),

                  InputField(
                    hint:"E-mail",
                    stream: _usuarioBloc.outEmail,
                    onChanged: _usuarioBloc.changeEmail,
                    multiline: false,
                    obscure: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    hint:"Senha",
                    stream: _usuarioBloc.outSenha,
                    onChanged: _usuarioBloc.changeSenha,
                    multiline: false,
                    obscure: true,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(

                        child: CustomButton(
                          padding: EdgeInsets.all(15),
                          onPressed: (){
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_)=>HomePage()
                                )
                            );
                          },
                          text: "LOGIN",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){},
                        child: Text("Esqueci minha senha",
                          style: _themeFlatButton,
                        ),
                      ),
                    ],
                  ), Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Não tem uma conta?"),
                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_)=>CadastroPage()
                          ));
                        },
                        child: Text("Cadastre-se aqui", style: _themeFlatButton,),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),);
  }
}
