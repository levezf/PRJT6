import 'package:prj/models/cinematografia.dart';

class Filme extends Cinematografia {
  Filme(
      {String urlPoster,
      String urlBackdrop,
      String urlVideo,
      String sinopse,
      String nome})
      : super(
            urlPoster: urlPoster,
            urlBackdrop: urlBackdrop,
            urlVideo: urlVideo,
            sinopse: sinopse,
            nome: nome);
}
