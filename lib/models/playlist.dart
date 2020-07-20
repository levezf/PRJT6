import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/usuario.dart';

import 'filme.dart';

class Playlist implements Searchable {
  String nome;
  int qtdSeguidores;
  bool privada;
  int qtdFilmes;
  int qtdSeries;
  int idCriador;
  int id;
  List<Cinematografia> cinematografias;
  List<Usuario> seguidores;

  Playlist(
      {
        this.seguidores,
        this.id,
        this.nome,
      this.qtdSeguidores,
      this.privada=false,
      this.idCriador,
      this.cinematografias, this.qtdSeries, this.qtdFilmes});

  String get poster {
    return cinematografias != null && cinematografias.isNotEmpty
        ? cinematografias
            .firstWhere((c) => c.urlPoster != null && c.urlPoster.isNotEmpty,
                orElse: () => cinematografias.first)
            .urlPoster
        : "https://cdn.playlists.net/images/playlists/image/medium/b6463b9f46744c007ef9fe7b070ee865.jpg";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Playlist &&
              runtimeType == other.runtimeType &&
              idCriador == other.idCriador &&
              id == other.id;

  @override
  int get hashCode =>
      idCriador.hashCode ^
      id.hashCode;

  factory Playlist.fromJson(Map<String, dynamic> json) {


    List<Usuario> seguidores = [];
    if(json["playlistfollowers"]!=null){
      List<dynamic> followers = json["playlistfollowers"];
      followers.forEach((value) {
        seguidores.add(Usuario.fromJson(value));
      });
    }


    List<Cinematografia> itens = [];
    if(json["items"]!=null){
      List<dynamic> items = json["items"];
      items.forEach((value) {
        value["id"] = value["movietvshowId"];
        if(value["itemType"] == "movie")
          itens.add(Filme.fromJson(value));
        else
          itens.add(Serie.fromJson(value));
      });
    }

    return Playlist(
      id:  json["id"],
      nome: json["name"],
      qtdSeries: json["qtdTv"],
      qtdFilmes:json["qtdMovie"],
      cinematografias: itens,
      idCriador: json["userId"],
      privada: json["private"]!=null?json["private"]:false,
      qtdSeguidores: json["qtdFollowers"],
      seguidores: seguidores,
    );
  }

}
