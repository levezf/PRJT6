import 'package:flutter/material.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/pages/playlist_detail.page.dart';

class PlaylistTile extends StatelessWidget {

  final Playlist playlist;
  PlaylistTile(this.playlist);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>  PlaylistDetailPage(playlist)
        ));
      },
      trailing: playlist.privada ? Icon(Icons.lock) : Text("${playlist.qtdSeguidores.toStringAsFixed(0)} seguidores"),
      leading: CircleAvatar(child: Text(playlist.nome.substring(0,2).toUpperCase()),),
      title: Text(playlist.nome),
      isThreeLine: true,
      subtitle: Text("${playlist.qtdFilmes.toStringAsFixed(0)} filmes\n${playlist.qtdSeries.toStringAsFixed(0)} séries", overflow:TextOverflow.ellipsis,),
    );
  }
}