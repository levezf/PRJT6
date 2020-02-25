import 'package:prj/models/searchable.dart';

abstract class Cinematografia implements Searchable{
  String urlPoster;
  String urlBackdrop;
  String urlVideo;
  String sinopse;
  String nome;

  Cinematografia({this.urlPoster, this.urlBackdrop, this.urlVideo, this.sinopse, this.nome});
}