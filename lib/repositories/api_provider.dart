import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/episodio.dart';
import 'package:prj/models/filme.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/temporada.dart';
import 'package:prj/models/usuario.dart';

import 'cineplus_shared_preferences.dart';

class ApiProvider {
  static const String BASE_URL = "https://cineplus.herokuapp.com";
  static const String ENDPOINT_DESTAQUES = "/destaques";
  static const String ENDPOINT_CADASTRO_USUARIO = "/register";
  static const String ENDPOINT_TOKEN = "/auth/token";
  static const String ENDPOINT_CADASTRO_PROFILE ="/registerprofile";
  static const String ENDPOINT_PROFILE ="/user";
  static const String ENDPOINT_CADASTRO_IMAGEM ="/registerprofile/image";

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

  Future<Response<dynamic>> doGet(String url, {String authorization}) async {
    Dio dio = Dio(BaseOptions(
        baseUrl: BASE_URL
    ));
    if(authorization!=null && authorization.isNotEmpty)
      dio.options.headers[HttpHeaders.authorizationHeader] = authorization;
    var response = await dio.get(url);
    return response;

  }

  Future<Response<dynamic>> doPost(String url, dynamic json, {String authorization, String contentType}) async {
    Dio dio = Dio(BaseOptions(
        baseUrl: BASE_URL
    ));
    if(authorization!=null && authorization.isNotEmpty)
      dio.options.headers[HttpHeaders.authorizationHeader] = authorization;
    if(contentType!=null && contentType.isNotEmpty){
      dio.options.contentType = contentType;
    }
    var response = await dio.post(
        url, data: json);
    return response;
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
            id: '$index',
            nome: "Playlist $index", qtdSeguidores: 10, privada: false,
            cinematografias: c, qtdSeries: 10, qtdFilmes: 10));
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
      Serie(
          nome: "Jumanji: Next Level",
          sinopse:
          "Spencer volta ao mundo fantástico de Jumanji. Os amigos Martha, Fridge e Bethany entram no jogo e tentam trazê-lo para casa. Mas eles logo descobrem mais obstáculos e perigos a serem superados.",
          urlBackdrop:
          "https://ae01.alicdn.com/kf/HTB1Mr6uajzuK1Rjy0Fpq6yEpFXao/7x5FT-4-Styles-Jumanji-Welcome-to-the-Jungle-Custom-Photo-Studio-Background-Backdrop-Vinyl-220cm-x.jpg",
          urlPoster:
          "https://conteudo.imguol.com.br/c/entretenimento/c2/2019/10/15/novo-cartaz-de-jumanji-proxima-fase-1571176154712_v2_450x600.jpg",
          dataLancamento: "2020-02-01",
          generos: (await fetchGeneros()).sublist(0, 5),
          temporadas: List.generate(10, (tempIndex){
            return Temporada(nome: "Temporada $tempIndex", id:"$tempIndex",
                episodios: List.generate(10, (epIndex){
                  return Episodio(nome: "Episodio $epIndex - Temp $tempIndex", id: "$epIndex", idTemporada: "$tempIndex",
                      sinopse: "Isso é uma sinopse para o episodio dessa série legal pra caramba. Muito top mesmo! Recomendo muito.");
                }));
          })
      ),
      Serie(
          dataLancamento: "2020-02-02",
          generos: (await fetchGeneros()).sublist(0, 5),
          temporadas: [
            Temporada(
                nome: "Temporada 1",
                episodios: []
            )
          ],
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

  Future<Usuario> fetchDetailsUsuario(int id) async {

    List<Playlist> playlists = await fetchPlaylistsDestaques();

    return Usuario(
        id: 1,
        nome: "Felipe Bertelli Levez",
        avatar:
        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
       /* generosFavoritos: [
          Genero(
              id: '1',
              nome: 'Ação'
          ),
          Genero(
              id: '2',
              nome: 'Aventura'
          ),
          Genero(
              id: '3',
              nome: 'Comédia'
          ),
          Genero(
              id: '4',
              nome: 'Drama'
          ),
          Genero(
              id: '5',
              nome: 'Suspense'
          ),
        ],*/
        seguidores: [],
        seguindo: [],
        playlistsSalvas:playlists);
  }

  Future<List<Playlist>> updatePlaylist(Playlist playlist, int id) async {
    return List<Playlist>.generate(
        10,
            (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10,           qtdFilmes: 5,
            qtdSeries: 5, privada: false));
  }

  Future<List<Playlist>> removePlaylist(Playlist playlist, int id) async {
    return List<Playlist>.generate(
        10,
            (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10,          qtdFilmes: 5,
            qtdSeries: 5, privada: false));
  }

  Future<List<Playlist>> addPlaylist(Playlist playlist, int id) async {
    return List<Playlist>.generate(
        10,
            (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10,           qtdFilmes: 5,
            qtdSeries: 5, privada: false));
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
            id: index));
  }

  Future<List<Usuario>> removeFollows(Usuario follow, Usuario user) async {
    return List<Usuario>.generate(
        10,
            (index) => Usuario(
            nome: "Seguindo $index", avatar:
        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
            id: index));
  }

  Future<List<Usuario>> addFollows(Usuario follow, Usuario user) async {
    return List<Usuario>.generate(
        10,
            (index) => Usuario(
            nome: "Seguindo $index", avatar:
        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
            id: index));
  }

  Future<Playlist> fetchDetailsPlaylist(Playlist playlist) async {
    return (await fetchPlaylistsDestaques()).elementAt(0);
  }

  Future<Cinematografia> fetchDetailsCinematografia(Cinematografia cinematografia) async {
    return (await fetchEmBreve()).elementAt(0);
  }

  Future<String> createUser(String email, String senha) async {

    Map<String, dynamic> user = {
      "username":email,
      "password":senha
    };

    Response<dynamic> resultCadastro = await doPost(ENDPOINT_CADASTRO_USUARIO, json.encode(user));

    if(resultCadastro.statusCode==200){

      CineplusSharedPreferences.instance.saveIdUser(resultCadastro.data['id']);

      user.putIfAbsent("grant_type", () => "password");

      Response<dynamic> resultToken = await doPost(ENDPOINT_TOKEN, user,
          authorization: "Basic Y29tLmNpbmVwbHVzLmRldjo=",
          contentType:Headers.formUrlEncodedContentType );

      if(resultToken.statusCode==200){

        String token = resultToken.data['access_token'];

        if(token!=null && token.isNotEmpty){
          CineplusSharedPreferences.instance.saveToken(token);
          return token;
        }
      }
    }
    return null;
  }

  Future<bool> saveProfile(String token, Usuario usuario, String image) async {

    Map<String, dynamic> user = {
      "fullname": usuario.nome,
      "email": usuario.email,
      "description": usuario.descricao,
    };
    Response<dynamic> resultProfile =
    await doPost(ENDPOINT_CADASTRO_PROFILE,
      json.encode(user),
      authorization: "Bearer $token",
    );

    if(resultProfile!=null && resultProfile.statusCode==200){

      await saveImage(token, image);

      return await getProfile(token)!=null;
    }
    return false;
  }

  Future<bool> login(String email, String senha) async{
    Map<String, dynamic> user = {
      "username":email,
      "password":senha,
      "grant_type":"password"
    };

    Response<dynamic> resultToken = await doPost(ENDPOINT_TOKEN, user,
        authorization: "Basic Y29tLmNpbmVwbHVzLmRldjo=",
        contentType:Headers.formUrlEncodedContentType );

    if(resultToken.statusCode==200){
      String token = resultToken.data['access_token'];

      if(token!=null && token.isNotEmpty){
        CineplusSharedPreferences.instance.saveToken(token);
        return await getProfile(token)!=null;
      }
    }
    return false;
  }


  Future<Usuario> getProfile(String token) async {
    final resultProfile = await doGet(ENDPOINT_PROFILE, authorization: 'Bearer $token');
    if(resultProfile!=null && resultProfile.statusCode==200){
      UsuarioBloc bloc = BlocProvider.getBloc<UsuarioBloc>();
      Usuario usuario = Usuario.fromJson(resultProfile.data[0]);
      bloc.setUser(usuario);
      return usuario;
    }
  }

  Future<bool> autoLogin() async {
    String token = await CineplusSharedPreferences.instance.getToken();
    if(token!=null && token.isNotEmpty){
      return getProfile(token)!=null;
    }
    return false;
  }

  Future<bool> saveImage(String token, String image) async {

    FormData imagem = FormData.fromMap({
      "imagem":await MultipartFile.fromFile(image)
    });

    Response<dynamic> result = await doPost(ENDPOINT_CADASTRO_IMAGEM, imagem,
        authorization: "Bearer $token");

    return result!=null && result.statusCode==200;
  }
}
