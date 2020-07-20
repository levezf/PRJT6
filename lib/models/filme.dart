import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';

class Filme extends Cinematografia {
  Filme(
      {int id,
        String dataLancamento,
      List<Genero> generos,
      String urlPoster,
      String urlBackdrop,
      String urlVideo,
      String sinopse,
      String nome})
      : super(id,dataLancamento, generos, urlPoster, urlBackdrop, urlVideo,
            sinopse, nome);

  factory Filme.fromJson(Map<String, dynamic> json) {
    List<Genero> generos = [];

    if(json["genres"]!=null){
      List<dynamic> genresMap = json["genres"];
      genresMap.forEach((value) {
        generos.add(Genero.fromJson(value));
      });
    }

    return Filme(
      id: json["id"],
      urlBackdrop: json["backdrop_path"],
      urlPoster: json["poster_path"],
      urlVideo: null,
      nome: json["name"]!=null?json["name"]:json["title"],
      sinopse: json["overview"],
      generos:generos,
      dataLancamento: json["release_date"],
    );
  }
}
