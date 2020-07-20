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

  Future<Usuario> fetchDetailsUsuario(int id) =>
      moviesApiProvider.fetchDetailsUsuario(id);

  Future<List<Playlist>> updatePlaylist(Playlist playlist, Usuario user) =>
      moviesApiProvider.updatePlaylist(playlist, user.id);

  Future<List<Playlist>> removePlaylist(Playlist playlist, Usuario user) =>
      moviesApiProvider.removePlaylist(playlist, user.id);

  Future<Playlist> addPlaylist(Playlist playlist, Usuario user) =>
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

  Future<Playlist> fetchDetailsPlaylist(Playlist playlist) =>
      moviesApiProvider.fetchDetailsPlaylist(playlist);

  Future<Cinematografia> fetchDetailsCinematografia(Cinematografia cinematografia)=>
      moviesApiProvider.fetchDetailsCinematografia(cinematografia);

  Future<String> createUser(String email, String senha) {
    return moviesApiProvider.createUser(email, senha);
  }

  Future<bool> saveProfile(String token, Usuario usuario, String imagem) {
    return moviesApiProvider.saveProfile(token, usuario, imagem);
  }

  Future<bool> login(String email, String senha){
    return moviesApiProvider.login(email, senha);
  }

  Future<bool> autoLogin() {
    return moviesApiProvider.autoLogin();
  }

  Future<bool> addCineInPlaylist(Cinematografia cinematografia, Playlist playlist) {
    return moviesApiProvider.addCineInPlaylist(cinematografia, playlist);
  }

  Future<bool> seguir(Usuario usuario) {
    return moviesApiProvider.seguir(usuario);
  }

  Future<bool> pararDeSeguir(Usuario usuario) {
    return moviesApiProvider.pararDeSeguir(usuario);
  }


}
