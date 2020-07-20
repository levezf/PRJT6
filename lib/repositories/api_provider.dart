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
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cineplus_shared_preferences.dart';

class ApiProvider {
  static const String BASE_URL = "https://cineplus.herokuapp.com";
  static const String ENDPOINT_DESTAQUES = "/destaques";
  static const String ENDPOINT_CADASTRO_USUARIO = "/register";
  static const String ENDPOINT_TOKEN = "/auth/token";
  static const String ENDPOINT_CADASTRO_PROFILE ="/registerprofile";
  static const String ENDPOINT_PROFILE ="/user/details";
  static const String ENDPOINT_CADASTRO_IMAGEM ="/registerprofile/image";
  static const String ENDPOINT_FILMES_DESTAQUE = "/movies/popular";
  static const String ENDPOINT_SERIES_DESTAQUE = "/tv/popular";
  static const String ENDPOINT_PLAYLISTS_DESTAQUE="/playlist/popular";
  static const String ENDPOINT_USER_DESTAQUE="/user/popular";
  static const String ENDPOINT_VIDEO_FILM_DESTQ="/movies/toptrending/video";
  static const String ENDPOINT_VIDEO_SERIE_DESTQ="/tv/toptrending/video";
  static const String ENDPOINT_USER_DETAILS="/user/detail/{id}";
  static const String ENDPOINT_EMBREVE="/upcomingmovies/1";
  static const String ENDPOINT_BUSCA="/search/{type}/{query}";
  static const String ENDPOINT_GENEROS="/genres/list";
  static const String ENDPOINT_BUSCA_GENERO_SERIE="/tv/bygenre/{page}/{id}";
  static const String ENDPOINT_BUSCA_GENERO_FILME="/movies/bygenre/{page}/{id}";
  static const String ENDPOINT_TV_DETAILS="/tv/detail/{id}";
  static const String ENDPOINT_MOVIE_DETAILS="/movies/detail/{id}";
  static const String ENDPOINT_PLAYLIST_DETAILS = "/playlist/detail/{id}";
  static const String ENDPOINT_CADASTRO_PLAYLIST="/playlist/register";
  static const String ENDPOINT_CADASTRO_ITEM_PLAYLIST="/playlistItem/register/{id}";
  static const String ENDPOINT_SEGUIR_USUARIO="/following/register/{id}";


  static ApiProvider _instance;
  Dio _dio;
  DioCacheManager _dioCacheManager;
  Options _cacheOptions;








  factory ApiProvider() {
    _instance ??= ApiProvider._internal();
    return _instance;
  }
  ApiProvider._internal() {
    _dioCacheManager = DioCacheManager(CacheConfig(baseUrl: BASE_URL));
    _cacheOptions = buildCacheOptions(Duration(days: 7));

    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 15000,
      receiveTimeout: 9000,
    );
    _dio = Dio(options);
    _dio.interceptors
        .add(_dioCacheManager.interceptor);
  }

  Future<Response<dynamic>> doGet(String url, {String authorization, bool usaCache=true}) async {
    Dio dio = _dio;
    if(authorization!=null && authorization.isNotEmpty)
      dio.options.headers[HttpHeaders.authorizationHeader] = authorization;
    var response = await dio.get(url, options: usaCache ? _cacheOptions : null);
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
    final result = await doGet(ENDPOINT_FILMES_DESTAQUE);
    Map<String, List<Filme>> filmes = {};
    if(result!=null && result.statusCode==200){

      Map<String, dynamic> resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        resultJson.forEach((key, value) {
          filmes.putIfAbsent(key, () {
            List<Filme> filmess=[];
            for (var filme in (value as List)) {
              filmess.add(Filme.fromJson(filme));
            }
            return filmess;
          });
        });
      }
    }
    return filmes;
  }

  Future<Map<String, List<Serie>>> fetchSerieDestaques() async {
    final result = await doGet(ENDPOINT_SERIES_DESTAQUE);
    Map<String, List<Serie>> series = {};
    if(result!=null && result.statusCode==200){

      Map<String, dynamic> resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        resultJson.forEach((key, value) {
          series.putIfAbsent(key, () {
            List<Serie> seriesaux=[];
            for (var serie in (value as List)) {
              seriesaux.add(Serie.fromJson(serie));
            }
            return seriesaux;
          });
        });
      }
    }
    return series;
  }

  Future<List<Playlist>> fetchPlaylistsDestaques() async {

    final result = await doGet(ENDPOINT_PLAYLISTS_DESTAQUE, usaCache: false);
    List<Playlist> playlists =[];
    if(result!=null && result.statusCode==200){
      List<dynamic> resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        resultJson.forEach((element) {
          playlists.add(Playlist.fromJson(element));
        });
      }
    }
    return playlists;
  }

  Future<List<Usuario>> fetchUsuariosDestaques() async {
    final result = await doGet(ENDPOINT_USER_DESTAQUE);
    List<Usuario> usuarios=[];
    if(result!=null && result.statusCode==200){
      List<dynamic> resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        resultJson.forEach((element) {
          usuarios.add(Usuario.fromJson(element));
        });
      }
    }
    return usuarios;
  }

  Future<String> fetchVideoFilmeDestaque() async {
    String url ="https://www.youtube.com/watch?v=zAGVQLHvwOY";
    final result = await doGet(ENDPOINT_VIDEO_FILM_DESTQ);
    if(result!=null && result.statusCode==200){
      if(result.data["url"]!=null){
        url = result.data["url"];
      }
    }
    return url;
  }

  Future<String> fetchVideoSerieDestaque() async {
    String url ="https://www.youtube.com/watch?v=DHQzM5Ee4cw";
    final result = await doGet(ENDPOINT_VIDEO_SERIE_DESTQ);
    if(result!=null && result.statusCode==200){
      if(result.data["url"]!=null){
        url = result.data["url"];
      }
    }
    return url;
  }

  Future<List<Cinematografia>> fetchEmBreve() async {
    final result = await doGet(ENDPOINT_EMBREVE);
    List<Cinematografia> embreve=[];
    if(result!=null && result.statusCode==200){
      List<dynamic> resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        resultJson.forEach((element) {
          embreve.add(Filme.fromJson(element));
        });
      }
    }
    return embreve;
  }

  Future<Usuario> fetchDetailsUsuario(int id) async {

    final result = await doGet(ENDPOINT_USER_DETAILS.replaceAll("{id}", id.toString()), usaCache: false);
    Usuario usuario;
    if(result!=null && result.statusCode==200){
      dynamic resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        usuario = Usuario.fromJson(resultJson);
      }
    }
    return usuario;
  }

  Future<List<Searchable>> search(String query, String type) async {

    String formatado = query.replaceAll(" ", "%");

    String endpoint = ENDPOINT_BUSCA.replaceAll("{query}", formatado);
    switch(type){
      case "Filmes":
        endpoint = endpoint.replaceAll("{type}", "movie");
        break;
      case "Séries":
        endpoint = endpoint.replaceAll("{type}", "tv");
        break;
      case "Playlists":
        endpoint = endpoint.replaceAll("{type}", "playlist");
        break;
      case"Usuários":
        endpoint = endpoint.replaceAll("{type}", "user");
        break;
    }

    final result = await doGet(endpoint);

    switch(type){
      case "Filmes":
        List<Filme> filmes=[];
        if(result!=null && result.statusCode==200){
          List<dynamic> resultJson = result.data;
          if(resultJson!=null && resultJson.length>0){
            resultJson.forEach((element) {
              filmes.add(Filme.fromJson(element));
            });
          }
        }
        return filmes;
        break;
      case "Séries":
        List<Serie> series=[];
        if(result!=null && result.statusCode==200){
          List<dynamic> resultJson = result.data;
          if(resultJson!=null && resultJson.length>0){
            resultJson.forEach((element) {
              series.add(Serie.fromJson(element));
            });
          }
        }
        return series;
        break;
      case "Playlists":
        List<Playlist> playlists=[];
        if(result!=null && result.statusCode==200){
          List<dynamic> resultJson = result.data;
          if(resultJson!=null && resultJson.length>0){
            resultJson.forEach((element) {
              playlists.add(Playlist.fromJson(element));
            });
          }
        }
        return playlists;
        break;
      case"Usuários":
        List<Usuario> usuarios=[];
        if(result!=null && result.statusCode==200){
          List<dynamic> resultJson = result.data;
          if(resultJson!=null && resultJson.length>0){
            resultJson.forEach((element) {
              usuarios.add(Usuario.fromJson(element));
            });
          }
        }
        return usuarios;
        break;
    }
  }

  Future<List<Genero>> fetchGeneros() async {
    final result = await doGet(ENDPOINT_GENEROS);
    List<Genero> generos=[];
    if(result!=null && result.statusCode==200){
      List<dynamic> resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        resultJson.forEach((element) {
          generos.add(Genero.fromJson(element));
        });
      }
    }
    return generos;
  }

  Future<List<Cinematografia>> searchByGenero(Genero genero) async {

    List<String> endpoints = [ENDPOINT_BUSCA_GENERO_FILME, ENDPOINT_BUSCA_GENERO_SERIE];
    List<Cinematografia> cines=[];

    for (var endpoint in endpoints) {

      endpoint = endpoint.replaceAll("{id}", genero.id.toString()).replaceAll("{page}", 1.toString());

      final result = await doGet(endpoint);
      if(result!=null && result.statusCode==200){
        List<dynamic> resultJson = result.data;
        if(resultJson!=null && resultJson.length>0){
          resultJson.forEach((element) {
            if(endpoint.contains("movie") || endpoint.contains("Movie")){
              cines.add(Filme.fromJson(element));
            }else{
              cines.add(Serie.fromJson(element));
            }
          });
        }
      }
    }
    cines.removeWhere((element) => element.urlPoster==null||element.urlPoster.isEmpty);
    cines.shuffle();

    return cines;
  }


  Future<Playlist> fetchDetailsPlaylist(Playlist playlist) async {

    final result = await doGet(ENDPOINT_PLAYLIST_DETAILS.replaceAll("{id}", playlist.id.toString()), usaCache: false);
    Playlist playlistDetails;
    if(result!=null && result.statusCode==200){
      dynamic resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        playlistDetails = Playlist.fromJson(resultJson);
      }
    }
    return playlistDetails;

  }

  Future<Cinematografia> fetchDetailsCinematografia(Cinematografia cinematografia) async {

    String endpoint = cinematografia is Filme ? ENDPOINT_MOVIE_DETAILS : ENDPOINT_TV_DETAILS;
    endpoint = endpoint.replaceAll("{id}", cinematografia.id.toString());

    final result = await doGet(endpoint);
    Cinematografia cinematografiaDetail;
    if(result!=null && result.statusCode==200){
      dynamic resultJson = result.data;
      if(resultJson!=null && resultJson.length>0){
        cinematografiaDetail = cinematografia is Filme ? Filme.fromJson(resultJson) : Serie.fromJson(resultJson);
      }
    }
    return cinematografiaDetail;
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

  Future<Playlist> addPlaylist(Playlist playlist, int id) async {

    String token = await CineplusSharedPreferences.instance.getToken();

    Map<String, dynamic> playlistMap = {
      "name": playlist.nome,
      "private": playlist.privada
    };

    Response<dynamic> result =
    await doPost(ENDPOINT_CADASTRO_PLAYLIST,
      json.encode(playlistMap),
      authorization: "Bearer $token",
    );

    if(result!=null && result.statusCode==200){
      return Playlist.fromJson(result.data);
    }
    return null;

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
      try {
        await saveImage(token, image);
      }catch (ignored){}

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
    final resultProfile = await doGet(ENDPOINT_PROFILE, authorization: 'Bearer $token', usaCache: false);
    if(resultProfile!=null && resultProfile.statusCode==200){
      UsuarioBloc bloc = BlocProvider.getBloc<UsuarioBloc>();
      Usuario usuario = Usuario.fromJson(resultProfile.data);
      bloc.setUser(usuario);
      return usuario;
    }
  }

  Future<bool> autoLogin() async {
    String token = await CineplusSharedPreferences.instance.getToken();
    if(token!=null && token.isNotEmpty){
      return await getProfile(token)!=null;
    }
    return false;
  }

  Future<bool> saveImage(String token, String image) async {

    if(image==null || image.isEmpty) return true;

    FormData imagem = FormData.fromMap({
      "imagem":await MultipartFile.fromFile(image)
    });

    Response<dynamic> result = await doPost(ENDPOINT_CADASTRO_IMAGEM, imagem,
        authorization: "Bearer $token");

    return result!=null && result.statusCode==200;
  }

  Future<bool> addCineInPlaylist(Cinematografia cinematografia, Playlist playlist) async {
    String token = await CineplusSharedPreferences.instance.getToken();

    Map<String, dynamic> item = {
      "movietvshowId": cinematografia.id,
      "itemType": cinematografia is Filme ? "movie" : "tv",
    };
    Response<dynamic> result =
        await doPost(ENDPOINT_CADASTRO_ITEM_PLAYLIST.replaceAll("{id}", playlist.id.toString()),
      json.encode(item),
      authorization: "Bearer $token",
    );
    if(result!=null && result.statusCode==200){
      return await getProfile(token)!=null;
    }
  }

  Future<bool> seguir(Usuario usuario) async {
    String token = await CineplusSharedPreferences.instance.getToken();
    Response<dynamic> result =
        await doPost(ENDPOINT_SEGUIR_USUARIO.replaceAll("{id}", usuario.id.toString()),
      null, authorization: "Bearer $token",
    );
    if(result!=null && result.statusCode==200){
      return await getProfile(token)!=null;
    }
  }

  Future<bool> pararDeSeguir(Usuario usuario)async {
    return false;
  }
}
