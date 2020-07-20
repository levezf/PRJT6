class Episodio{

  int id;
  int idTemporada;
  String nome;
  String sinopse;
  int numeroTemporada;

  Episodio({this.id, this.idTemporada, this.nome, this.sinopse, this.numeroTemporada});

  factory Episodio.fromJson(Map<String, dynamic> json) {
    return Episodio(
      id: json["id"],
      nome: json["name"],
      sinopse: json["overview"],
      numeroTemporada:  json["season_number"],
      idTemporada: json["show_id"]
    );
  }


}