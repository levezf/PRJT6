import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/login.page.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/input_field.dart';

import 'follow.page.dart';

class PerfilPage extends StatefulWidget {

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  static const String IMAGE_DEFAULT = "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg";

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    UsuarioBloc bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.doAutoLogin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<Usuario>(
          stream: BlocProvider.getBloc<UsuarioBloc>().outUsuario,
          builder: (context, snapshot) {

            if(!snapshot.hasData){
              return CustomLoading();
            }

            return ListView(
              children: <Widget>[
                _buildCardProfile(snapshot.data),
                _buildCardDescricao(snapshot.data, context),
                _buildCardFollow(snapshot.data, context),
//              _buildCardShare(snapshot.data, context),
                _buildCardAlterarSenha(context),
                _buildCardLogout(context),
              ],
            );
          }
      ),
    );
  }

  Widget _buildCardProfile(Usuario user) {
    return Card(
      child: Container(
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: NetworkImage(user.avatar!=null && user.avatar.isNotEmpty ? user.avatar : IMAGE_DEFAULT),
                      ),
                    ),

                    Positioned(
                      right: 0,
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
                                final result = await BlocProvider.getBloc<UsuarioBloc>().saveImage(image);
                                if(result!=null){
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(result ? "Imagem alterada com sucesso!" : "Falha ao alterar a imagem!"),
                                      ));
                                }
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      final result = await showModalChangeData("Novo nome",
                          (text)async{
                            return await BlocProvider.getBloc<UsuarioBloc>().changeNome(text);
                          }
                      );
                      if(result!=null){
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(result ? "Nome atualizado com sucesso!" : "Falha ao alterar o nome!"),
                            ));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        user.nome.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardFollow(Usuario user, BuildContext context) {
    return Card(
      child: Container(
        height: 145,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _followItem("Seguidores", user.seguidores.length, context),
            Container(
              width: 1,
              height: 70,
              color: kGrayColor,
            ),
            _followItem("Seguindo", user.seguindo.length, context)
          ],
        ),
      ),
    );
  }

  Widget _buildCardShare(Usuario user, BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Compartilhe suas listas",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Use o link ou o QRCode para que seus amigos o encontre.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text("Enviar"),
                  onPressed: () {},
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text("QRCode"),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _followItem(String title, int qtd, BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FollowPage(title)));
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              qtd.toString(),
              style: TextStyle(fontSize: 38),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardDescricao(Usuario usuario, BuildContext context){
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Sobre mim",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                IconButton(icon:Icon(Icons.edit),
                onPressed:()async{
                  final result = await showModalChangeData("Nova descrição",
                          (text)async{
                        return await BlocProvider.getBloc<UsuarioBloc>().changeDescricao(text);
                      }
                  );
                  if(result!=null){
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text(result ? "Descrição atualizada com sucesso!" : "Falha ao alterar a descrição!"),
                        ));
                  }
                },)
              ],
            ),

            SizedBox(
              height: 8,
            ),
            Text(
              usuario.descricao,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLogout(BuildContext context){
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Trocar de conta",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Click no botão abaixo para realizar o Logout",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text("Logout"),
                  color: Colors.red,
                  onPressed: () {
                    BlocProvider.getBloc<UsuarioBloc>().logout();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_)=>LoginPage()
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showModalChangeData(String hint, Future<bool> Function(String) onSave, {bool obscure=false}) async {
    BlocProvider.getBloc<UsuarioBloc>().changeText(null);
    return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext bc){
          return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(bc).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InputField(
                        obscure: obscure,
                        onChanged: BlocProvider.getBloc<UsuarioBloc>().changeText,
                        multiline: false,
                        stream: BlocProvider.getBloc<UsuarioBloc>().outText,
                        hint: hint,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder<String>(
                              stream: BlocProvider.getBloc<UsuarioBloc>().outText,
                              builder: (context, snapshot) {
                                return CustomButton(
                                    icon:Icon(Icons.add),
                                    text: 'SALVAR',
                                    onPressed: snapshot.hasData && snapshot.data.length > 3  ? () async {
                                      final result = await onSave(snapshot.data);
                                      Navigator.pop(context, result);
                                    }: null);
                              }
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Widget _buildCardAlterarSenha(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Minha senha",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Click no botão abaixo para realizar a troca de senha",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text("Trocar senha"),
                  onPressed: ()async{
                    final result = await showModalChangeData("Nova senha",
                            (text)async{
                          return await BlocProvider.getBloc<UsuarioBloc>().changeSenhaUsuario(text);
                        }, obscure: true
                    );
                    if(result!=null){
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(result ? "Senha atualizada com sucesso!" : "Falha ao alterar a senha!"),
                          ));
                    }
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
