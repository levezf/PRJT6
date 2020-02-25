import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';

class Usuario implements Searchable{
  String nome;
  String avatar;
  List<Playlist> playlistsSalvas;
  List<Genero> generosFavoritos;
  double id;

  Usuario({this.nome, this.avatar, this.playlistsSalvas, this.id, this.generosFavoritos});
}