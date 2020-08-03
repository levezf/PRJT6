


import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';

class BottomSheetSalvos extends StatefulWidget {

  Cinematografia cinematografia;
  BottomSheetSalvos(this.cinematografia);

  @override
  _BottomSheetSalvosState createState() => _BottomSheetSalvosState();
}

class _BottomSheetSalvosState extends State<BottomSheetSalvos> {

  @override
  void didChangeDependencies() {
    UsuarioBloc bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.doLogin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: StreamBuilder<List<Playlist>>(
        stream: BlocProvider.getBloc<UsuarioBloc>().outOwnSalvos,
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomLoading();
          }

          if(snapshot.data.isEmpty){
            return CenteredMessage(
                icon: Icons.error_outline,
                title: "Que pena :(",
                subtitle: "Você não tem nenhuma lista ainda !\nAcesse a aba salvos e crie uma!"
            );
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              Playlist playlist = snapshot.data.elementAt(index);
              return ListTile(
                onTap: () async {
                  if(playlist.cinematografias!=null && playlist.cinematografias.contains(widget.cinematografia)){
                    Navigator.pop(context,"Item já existente nessa playlist");
                    return;
                  }
                  final result = await BlocProvider.getBloc<UsuarioBloc>().addCineInPlaylist(widget.cinematografia, playlist);
                  Navigator.pop(context,result);
                },
                trailing: playlist.privada ? Icon(Icons.lock) : Text("${playlist.qtdSeguidores} seguidores"),
                leading: CircleAvatar(child: Text(playlist.nome.substring(0,2).toUpperCase()),),
                title: Text(playlist.nome),
              );
            },
            itemCount: snapshot.data?.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }
}


/*StreamBuilder<List<Playlist>>(
        stream: BlocProvider.getBloc<UsuarioBloc>().outSalvos,
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomLoading();
          }

          if(snapshot.data.isEmpty){
            return CenteredMessage(
                icon: Icons.error_outline,
                title: "Que pena :(",
                subtitle: "Você não tem nenhuma lista ainda !"
            );
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              return PlaylistTile(snapshot.data.elementAt(index));
            },
            itemCount: snapshot.data?.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),*/