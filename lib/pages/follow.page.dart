

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
        (title == "Followers") ? usuarioBloc.outSeguidores :
        usuarioBloc.outSeguindo,

        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return CustomLoading();
          }
          if(snapshot.data.isEmpty){
            return CenteredMessage(
                icon: Icons.error_outline,
                title: "Too bad :(",
                subtitle: "You don't have many friends right ?!"
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
                                ? (estaSeguindo ? "You stopped following ${follow.nome}" : "You started to follow ${follow.nome}")
                                : (estaSeguindo ? "Failed to stop following ${follow.nome}" : "Failed to follow ${follow.nome}")),
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
