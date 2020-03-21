import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/searchable.dart';

class Playlist implements Searchable {
  String nome;
  double qtdSeguidores;
  bool privada;
  double qtdFilmes;
  double qtdSeries;
  String idCriador;
  String id;
  List<Cinematografia> cinematografias;

  Playlist(
      {
        this.id,
        this.nome,
      this.qtdSeguidores,
      this.privada=false,
      this.idCriador,
      this.cinematografias, this.qtdSeries, this.qtdFilmes});

  String get poster {
    return cinematografias != null
        ? cinematografias
            .firstWhere((c) => c.urlPoster != null && c.urlPoster.isNotEmpty,
                orElse: () => cinematografias.first)
            .urlPoster
        : "";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Playlist &&
              runtimeType == other.runtimeType &&
              idCriador == other.idCriador &&
              id == other.id;

  @override
  int get hashCode =>
      idCriador.hashCode ^
      id.hashCode;

}
