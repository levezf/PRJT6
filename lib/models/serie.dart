import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/filme.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/temporada.dart';

class Serie extends Cinematografia {

  List<Temporada> temporadas;
  int qtdTemporadas;

  Serie(
      {
        int id,
        String dataLancamento,
      List<Genero> generos,
      String urlPoster,
      String urlBackdrop,
      String urlVideo,
      String sinopse,
      String nome, this.temporadas,int idExterno})
      : super(id, dataLancamento, generos, urlPoster, urlBackdrop, urlVideo,
            sinopse, nome, idExterno);

  factory Serie.fromJson(Map<String, dynamic> json) {
    List<Genero> generos = [];
    if(json["genres"]!=null){
      List<dynamic> genresMap = json["genres"];
      genresMap.forEach((value) {
        generos.add(Genero.fromJson(value));
      });
    }

    List<Temporada> temporadas = [];
    if(json["seasons"]!=null){
      List<dynamic> temporadasMap = json["seasons"];
      temporadasMap.forEach((value) {
        temporadas.add(Temporada.fromJson(value));
      });
    }


    return Serie(
      idExterno:  json["idExterno"],
      id: json["id"],
      urlBackdrop: json["backdrop_path"],
      urlPoster: json["poster_path"],
      urlVideo: null,
      nome: json["name"],
      sinopse: json["overview"],
      generos:generos,
      dataLancamento: json["release_date"],
      temporadas: temporadas,
    );
  }
}
