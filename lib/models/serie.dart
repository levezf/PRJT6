import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/temporada.dart';

class Serie extends Cinematografia {

  List<Temporada> temporadas;

  Serie(
      {String dataLancamento,
      List<Genero> generos,
      String urlPoster,
      String urlBackdrop,
      String urlVideo,
      String sinopse,
      String nome, this.temporadas,})
      : super(dataLancamento, generos, urlPoster, urlBackdrop, urlVideo,
            sinopse, nome);
}
