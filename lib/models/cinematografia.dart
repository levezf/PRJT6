import 'package:prj/models/genero.dart';
import 'package:prj/models/searchable.dart';

abstract class Cinematografia implements Searchable{
  String urlPoster;
  String urlBackdrop;
  String urlVideo;
  String sinopse;
  String nome;
  List<Genero> generos;
  String dataLancamento;

  Cinematografia(this.dataLancamento, this.generos, this.urlPoster, this.urlBackdrop, this.urlVideo, this.sinopse, this.nome);
}