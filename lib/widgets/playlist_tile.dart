import 'package:flutter/material.dart';
import 'package:prj/models/playlist.dart';

class PlaylistTile extends StatelessWidget {

  final Playlist playlist;
  PlaylistTile(this.playlist);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
      trailing: playlist.privada ? Icon(Icons.lock) : Text("${playlist.qtdSeguidores.toStringAsFixed(0)} seguidores"),
      leading: CircleAvatar(child: Text(playlist.nome.substring(0,2).toUpperCase()),),
      title: Text(playlist.nome),
      isThreeLine: true,
      subtitle: Text("${playlist.qtdFilmes} filmes\n${playlist.qtdSeries} séries", overflow:TextOverflow.ellipsis,),
    );
  }
}