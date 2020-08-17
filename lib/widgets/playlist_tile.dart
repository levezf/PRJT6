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
      trailing: playlist.privada ? Icon(Icons.lock) : Text("${playlist.qtdSeguidores} followers"),
      leading: CircleAvatar(child: Text(playlist.nome.substring(0,2).toUpperCase()),),
      title: Text(playlist.nome),
      isThreeLine: true,
      subtitle: Text("${playlist.qtdFilmes.toString()} movies\n${playlist.qtdSeries.toString()} TV Series", overflow:TextOverflow.ellipsis,),
    );
  }
}