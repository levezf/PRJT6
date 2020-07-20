import 'package:prj/models/searchable.dart';

class Genero implements Searchable{
  int id;
  String nome;

  Genero({this.id, this.nome});

  factory Genero.fromJson(Map<String, dynamic> json) {
    return Genero(
      id: json["id"],
      nome: json["name"]
    );
  }
}