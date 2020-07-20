

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/enums/operation.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/usuario_detail.page.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/follow_tile.dart';

class FollowPage extends StatelessWidget {

  final String title;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FollowPage(this.title);


  @override
  Widget build(BuildContext context) {
    UsuarioBloc usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
        leading: CloseButton(),
      ),

      body: StreamBuilder<List<Usuario>>(
        stream:
        (title == "Seguidores") ? usuarioBloc.outSeguidores :
        usuarioBloc.outSeguindo,

        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return CustomLoading();
          }
          if(snapshot.data.isEmpty){
            return CenteredMessage(
                icon: Icons.error_outline,
                title: "Que pena :(",
                subtitle: "Você não tem muitos amigos neh ?!"
            );
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              Usuario follow = snapshot.data.elementAt(index);
              bool estaSeguindo = usuarioBloc.estaSeguindo(follow);
              return FollowTile(
                  follow,
                  estaSeguindo ,
                      () async {
                    bool result;
                    if(!estaSeguindo){
                      result = await BlocProvider.getBloc<UsuarioBloc>().seguir(follow);
                    }else{
                      result = await BlocProvider.getBloc<UsuarioBloc>().pararDeSeguir(follow);
                    }
                    if(result!=null){
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(result
                                ? (estaSeguindo ? "Você parou de seguir ${follow.nome}" : "Você começou a seguir ${follow.nome}")
                                : (estaSeguindo ? "Falha ao parar de seguir ${follow.nome}" : "Falha ao seguir ${follow.nome}")),
                          ));

                    }
                    },
                      (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_)=>UsuarioDetailPage(follow)
                    ));
                  });
            },
            itemCount: snapshot.data.length, separatorBuilder: (_,index) {
            return SizedBox(
              height: 10,
            );
          },
          );
        },
      ),
    );
  }
}
