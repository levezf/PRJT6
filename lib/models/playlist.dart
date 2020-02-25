import 'package:prj/models/searchable.dart';

class Playlist implements Searchable{

  String nome;
  double qtdSeguidores;
  bool privada;
  double qtdFilmes;
  double qtdSeries;
  double idCriador;

  Playlist({this.nome, this.qtdSeguidores, this.privada, this.idCriador});

}