import 'dart:async';

import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/filme.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/usuario.dart';

import 'api_provider.dart';

class ApiRepository {
  static ApiRepository _instance;

  factory ApiRepository() {
    _instance ??= ApiRepository._internal();
    return _instance;
  }
  ApiRepository._internal();

  final moviesApiProvider = ApiProvider();

  Future<Map<String, List<Filme>>> fetchFilmeDestaques() =>
      moviesApiProvider.fetchFilmeDestaques();
  
  Future<Map<String, List<Serie>>> fetchSerieDestaques() =>
      moviesApiProvider.fetchSerieDestaques();
  
  Future<List<Playlist>> fetchPlaylistsDestaques() =>
      moviesApiProvider.fetchPlaylistsDestaques();
  
  Future<List<Usuario>> fetchUsuariosDestaques() =>
      moviesApiProvider.fetchUsuariosDestaques();
  
  Future<String> fetchVideoFilmeDestaque() =>
      moviesApiProvider.fetchVideoFilmeDestaque();
  
  Future<String> fetchVideoSerieDestaque() =>
      moviesApiProvider.fetchVideoSerieDestaque();
  
  Future<List<Cinematografia>> fetchEmBreve() =>
      moviesApiProvider.fetchEmBreve();
  
  Future<Usuario> fetchDetailsUsuario(String id) =>
      moviesApiProvider.fetchDetailsUsuario(id);
  
  Future<List<Playlist>> updatePlaylist(Playlist playlist, Usuario user) =>
      moviesApiProvider.updatePlaylist(playlist, user.id);
  
  Future<List<Playlist>> removePlaylist(Playlist playlist, Usuario user) =>
      moviesApiProvider.removePlaylist(playlist, user.id);
  
  Future<List<Playlist>> addPlaylist(Playlist playlist, Usuario user) =>
      moviesApiProvider.addPlaylist(playlist, user.id);
  
  Future<List<Searchable>> search(String query, String type) =>
      moviesApiProvider.search(query, type);
  
  Future<List<Genero>> fetchGeneros() => moviesApiProvider.fetchGeneros();

  Future<List<Cinematografia>> searchByGenero(Genero genero) =>
      moviesApiProvider.searchByGenero(genero);

  Future<List<Usuario>> updateFollows(Usuario follow, Usuario user) =>
      moviesApiProvider.updateFollows(follow, user);

  Future<List<Usuario>> removeFollows(Usuario follow, Usuario user) =>
      moviesApiProvider.removeFollows(follow, user);

  Future<List<Usuario>> addFollows(Usuario follow, Usuario user)  =>
      moviesApiProvider.addFollows(follow, user);
}
