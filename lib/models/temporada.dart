import 'episodio.dart';

class Temporada {


  int id;
  String nome;
  String descricao;
  int numero;
  List<Episodio> episodios;

  Temporada({this.numero, this.id, this.nome, this.descricao, this.episodios});

  factory Temporada.fromJson(Map<String, dynamic> json) {

    List<Episodio> episodios = [];
    if(json["episodes"]!=null){
      List<dynamic> episodiosMap = json["episodes"];
      episodiosMap.forEach((value) {
        episodios.add(Episodio.fromJson(value));
      });
    }

    return Temporada(
      id: json["id"],
      numero: json["season_number"],
      nome: json["name"],
      descricao: json["overview"],
      episodios: episodios
    );
  }

}