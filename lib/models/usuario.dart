import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';

class Usuario implements Searchable{
  String nome;
  String avatar;
  List<Playlist> playlistsSalvas;
  List<Usuario> seguidores;
  List<Usuario> seguindo;
  List<Genero> generosFavoritos;
  double id;

  Usuario({this.nome, this.avatar, this.playlistsSalvas, this.id, this.generosFavoritos, this.seguidores, this.seguindo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Usuario &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

}