import 'package:flutter/material.dart';
import 'package:prj/blocs/cadastro.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/widgets/input_field.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  CadastroBloc _cadastroBloc;

  static const String IMAGE_DEFAULT = "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg";

  @override
  void initState() {
    _cadastroBloc = CadastroBloc();
    super.initState();
  }

  @override
  void dispose() {
    _cadastroBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Cadastro"),
          leading: CloseButton(),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

//              foto
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: NetworkImage(IMAGE_DEFAULT),
                      ),
                    ),

                    Positioned(
                      right: 140,
                      bottom: 2,
                      width: 50,
                      child: FloatingActionButton(
                        heroTag: "addImage",
                        onPressed: (){},
                        child: Icon(Icons.add),
                        mini: true,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 40,),

//              nome
                InputField(
                  hint: "Nome",
                  multiline: false,
                  obscure: false,
                ),

                SizedBox(height: 20,),

//              email
                InputField(
                  hint: "E-mail",
                  multiline: false,
                  obscure: false,
                ),

                SizedBox(height: 20,),
//
//              descricao
                InputField(
                  hint: "Descrição",
                  multiline: true,
                  obscure: false,
                ),

                SizedBox(height: 20,),

//              senha
                InputField(
                  hint: "Senha",
                  multiline: false,
                  obscure: true,
                ),

                SizedBox(height: 20,),

//              confirmar senha
                InputField(
                  hint: "Confirmar senha",
                  multiline: false,
                  obscure: true,
                ),

                SizedBox(height: 20,),

//              generos favoritos


              ],
            ),
          ),
        )
    );
  }
}
