import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/login.page.dart';
import 'package:prj/widgets/custom_loading.dart';

import 'follow.page.dart';

class PerfilPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<Usuario>(
        stream: BlocProvider.getBloc<UsuarioBloc>().outUsuario,
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return CustomLoading();
          }

          return ListView(
            children: <Widget>[
              _buildCardProfile(snapshot.data),
              _buildCardFollow(snapshot.data, context),
              _buildCardShare(snapshot.data, context),
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
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.nome.toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 1.5),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {},
              ),
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

}
