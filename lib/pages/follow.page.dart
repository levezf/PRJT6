

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/enums/operation.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/follow_tile.dart';

class FollowPage extends StatelessWidget {

  final String title;

  FollowPage(this.title);


  @override
  Widget build(BuildContext context) {
    UsuarioBloc usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
    return Scaffold(
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
                (){
                  usuarioBloc.updateFollow(title, follow, (estaSeguindo) ?Operation.Remove : Operation.Add);
                },
                (){
                  /*abre os detalhes*/
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
