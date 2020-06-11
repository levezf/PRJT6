import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prj/blocs/cadastro.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/input_field.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Cadastro"),
          leading: CloseButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
          ),
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
                      child: StreamBuilder<File>(
                          stream: _cadastroBloc.outImage,
                          initialData: null,
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return CircleAvatar(
                                radius: 75,
                                backgroundImage: FileImage(snapshot.data),
                              );
                            }

                            return CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(IMAGE_DEFAULT),
                            );
                          }
                      ),
                    ),

                    Positioned(
                      right: 140,
                      bottom: 2,
                      width: 50,
                      child: FloatingActionButton(
                        heroTag: "addImage",
                        onPressed: ()async {

                          File image = await ImagePicker.pickImage(source: ImageSource.gallery);
                          if(image!=null){
                            String temp = (await getTemporaryDirectory()).path;
//                            temp = (await File((temp+"/movies")).create()).path;
                            image = await image.copy((temp+"/image"+image.path.substring(image.path.lastIndexOf("."))));
                            if(image!=null && await image.exists()) {
                              image = await ImageCropper.cropImage(
                                  androidUiSettings: AndroidUiSettings(
                                      toolbarTitle: 'Cortar imagem',
                                      toolbarColor: Colors.black,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio: CropAspectRatioPreset.square,
                                      lockAspectRatio: true
                                  ),
                                  compressQuality: 100,
                                  maxHeight: 200,
                                  maxWidth: 200,
                                  aspectRatio: CropAspectRatio(ratioY: 1,ratioX: 1),
                                  aspectRatioPresets: [CropAspectRatioPreset.square],
                                  sourcePath: image.path);
                              if (image != null) {
                                _cadastroBloc.changeImage(image);
                              }
                            }else{
                              //show error
                            }
                          }
                        },
                        child: Icon(Icons.add),
                        mini: true,
                      ),
                    )
                  ],
                ),

                SizedBox(height: 40,),

//              nome
                InputField(
                  hint: "Nome*",
                  multiline: false,
                  obscure: false,
                  stream: _cadastroBloc.outNome,
                  onChanged: _cadastroBloc.changeNome,
                ),

                SizedBox(height: 20,),

//              email
                InputField(
                  hint: "E-mail*",
                  multiline: false,
                  obscure: false,
                  stream: _cadastroBloc.outEmail,
                  onChanged: _cadastroBloc.changeEmail,
                ),

                SizedBox(height: 20,),
//
//              descricao
                InputField(
                  hint: "Descrição",
                  multiline: true,
                  obscure: false,
                  stream: _cadastroBloc.outDescricao,
                  onChanged: _cadastroBloc.changeDescricao,
                ),

                SizedBox(height: 20,),

//              senha
                InputField(
                  hint: "Senha*",
                  multiline: false,
                  obscure: true,
                  stream: _cadastroBloc.outSenha,
                  onChanged: _cadastroBloc.changeSenha,
                ),

                SizedBox(height: 20,),

//              confirmar senha
                InputField(
                  hint: "Confirmar senha*",
                  multiline: false,
                  obscure: true,
                  stream: _cadastroBloc.outSenhaConfirm,
                  onChanged: _cadastroBloc.changeConfirmSenha,
                ),

                SizedBox(height: 20,),

//              generos favoritos

//              save
                StreamBuilder<bool>(
                    stream: _cadastroBloc.outSubmitValid,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        child: CustomButton(
                          onPressed: (snapshot.hasData && snapshot.data)? () {
                            if(_cadastroBloc.save()){
                              Navigator.of(context).pop(true);
                            }else{
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Erro ao cadastrar o usuário"),
                              ));
                            }
                          } :null,
                          text: "SALVAR",
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      );
                    }
                )

              ],
            ),
          ),
        )
    );
  }
}
