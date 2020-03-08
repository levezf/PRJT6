import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/searchable.dart';

class Playlist implements Searchable {
  String nome;
  double qtdSeguidores;
  bool privada;
  double qtdFilmes;
  double qtdSeries;
  double idCriador;
  List<Cinematografia> cinematografias;

  Playlist(
      {this.nome,
      this.qtdSeguidores,
      this.privada,
      this.idCriador,
      this.cinematografias});

  String get poster {
    return cinematografias != null
        ? cinematografias
            .firstWhere((c) => c.urlPoster != null && c.urlPoster.isNotEmpty,
                orElse: () => cinematografias.first)
            .urlPoster
        : "";
  }
}
