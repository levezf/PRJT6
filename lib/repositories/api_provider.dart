import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/filme.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/usuario.dart';

class ApiProvider {
  static const String BASE_URL = "";
  static const String ENDPOINT_DESTAQUES = "/destaques";
  static ApiProvider _instance;
  Dio _dio;

  factory ApiProvider() {
    _instance ??= ApiProvider._internal();
    return _instance;
  }
  ApiProvider._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    _dio = Dio(options);
    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: BASE_URL)).interceptor);
  }

  Future<dynamic> doGet(String url) async {
    var response = await Dio().get(url,
        options: buildCacheOptions(
          Duration(days: 3),
          maxStale: Duration(days: 7),
        ));
    return response.data;
  }

  Future<Map<String, List<Filme>>> fetchFilmeDestaques() async {
    return {
      "Ação": [
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg")
      ],
      "Aventura": [
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg")
      ],
      "Comédia": [
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg")
      ],
      "Drama": [
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
        Filme(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg")
      ]
    };
  }

  Future<Map<String, List<Serie>>> fetchSerieDestaques() async {
    return {
      "Ação": [
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg")
      ],
      "Aventura": [
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg")
      ],
      "Comédia": [
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg")
      ],
      "Drama": [
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
                "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg")
      ]
    };
  }

  Future<List<Playlist>> fetchPlaylistsDestaques() async {

    List<Cinematografia> c = await fetchEmBreve();

    return List<Playlist>.generate(
        10,
        (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10, privada: false,
            cinematografias: c));
  }

  Future<List<Usuario>> fetchUsuariosDestaques() async {
    return List<Usuario>.generate(
      10,
      (index) => Usuario(
          nome: "Felipe Bertelli Levez",
          avatar:
              "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg"),
    );
  }

  Future<String> fetchVideoFilmeDestaque() async {
    return "https://www.youtube.com/watch?v=zAGVQLHvwOY";
  }

  Future<String> fetchVideoSerieDestaque() async {
    return "https://www.youtube.com/watch?v=DHQzM5Ee4cw";
  }

  Future<List<Cinematografia>> fetchEmBreve() async {
    return [
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
              "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlBackdrop:
              "https://ae01.alicdn.com/kf/HTB1Mr6uajzuK1Rjy0Fpq6yEpFXao/7x5FT-4-Styles-Jumanji-Welcome-to-the-Jungle-Custom-Photo-Studio-Background-Backdrop-Vinyl-220cm-x.jpg",
          urlPoster:
              "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
              "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlVideo: "https://www.youtube.com/watch?v=fwt6h6lt1Nc",
          urlPoster:
              "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
              "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlVideo: "https://www.youtube.com/watch?v=fwt6h6lt1Nc",
          urlPoster:
              "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
              "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlPoster:
              "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
    ];
  }

  Future<Usuario> fetchDetailsUsuario(String id) async {
    return Usuario(
        id: 1,
        nome: "Felipe Bertelli Levez",
        avatar:
            "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
        playlistsSalvas: [
          Playlist(
              idCriador: 1,
              nome: "Old but gold",
              privada: true,
              qtdSeguidores: 0),
          Playlist(
              idCriador: 2,
              nome: "Carnafunk",
              privada: false,
              qtdSeguidores: 110)
        ]);
  }

  Future<List<Playlist>> updatePlaylist(Playlist playlist, double id) async {
    return List<Playlist>.generate(
        10,
        (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10, privada: false));
  }

  Future<List<Playlist>> removePlaylist(Playlist playlist, double id) async {
    return List<Playlist>.generate(
        10,
        (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10, privada: false));
  }

  Future<List<Playlist>> addPlaylist(Playlist playlist, double id) async {
    return List<Playlist>.generate(
        10,
        (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10, privada: false));
  }

  Future<List<Searchable>> search(String query, String type) async {


    if(type=='Filmes'){
      return await fetchEmBreve();
    }else if(type=='Séries'){
      return [
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
        Serie(
            urlPoster:
            "https://conteudo.imguol.com.br/c/entretenimento/cc/2019/02/28/vladimir-furdik-como-o-rei-da-noite-em-game-of-thrones-1551361100425_v2_450x600.jpg"),
      ];
    }else if(type=='Playlists'){
      return await fetchPlaylistsDestaques();
    }else if(type=='Usuários'){
      return await fetchUsuariosDestaques();
    }
  }

  Future<List<Genero>> fetchGeneros() async {
    return <Genero>[
      Genero(id: "1", nome: "Ação"),
      Genero(id: "2", nome: "Aventura"),
      Genero(id: "3", nome: "Ficção cientifica"),
      Genero(id: "4", nome: "Drama"),
      Genero(id: "5", nome: "Suspense"),
      Genero(id: "6", nome: "Documentário"),
      Genero(id: "7", nome: "Terror"),
    ];
  }

  Future<List<Cinematografia>> searchByGenero(Genero genero) async {
    return [
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
          "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlBackdrop:
          "https://ae01.alicdn.com/kf/HTB1Mr6uajzuK1Rjy0Fpq6yEpFXao/7x5FT-4-Styles-Jumanji-Welcome-to-the-Jungle-Custom-Photo-Studio-Background-Backdrop-Vinyl-220cm-x.jpg",
          urlPoster:
          "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
          "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlVideo: "https://www.youtube.com/watch?v=fwt6h6lt1Nc",
          urlPoster:
          "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
          "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlVideo: "https://www.youtube.com/watch?v=fwt6h6lt1Nc",
          urlPoster:
          "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
      Filme(
          nome: "Jumanji: Next Level",
          sinopse:
          "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlPoster:
          "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg"),
    ];
  }

  Future<List<Usuario>> updateFollows(Usuario follow, Usuario user) async {
    return List<Usuario>.generate(
        10,
            (index) => Usuario(
            nome: "Seguindo $index", avatar:
        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
            id: index.toDouble()));
  }

  Future<List<Usuario>> removeFollows(Usuario follow, Usuario user) async {
    return List<Usuario>.generate(
        10,
            (index) => Usuario(
            nome: "Seguindo $index", avatar:
        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
            id: index.toDouble()));
  }

  Future<List<Usuario>> addFollows(Usuario follow, Usuario user) async {
    return List<Usuario>.generate(
        10,
            (index) => Usuario(
            nome: "Seguindo $index", avatar:
        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
            id: index.toDouble()));
  }
}
