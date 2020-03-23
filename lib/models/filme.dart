import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';

class Filme extends Cinematografia {
  Filme(
      {String dataLancamento,
      List<Genero> generos,
      String urlPoster,
      String urlBackdrop,
      String urlVideo,
      String sinopse,
      String nome})
      : super(dataLancamento, generos, urlPoster, urlBackdrop, urlVideo,
            sinopse, nome);
}
