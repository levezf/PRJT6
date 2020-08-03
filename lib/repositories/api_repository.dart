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
  
  Future<Playlist> addPlaylist(Playlist playlist, Usuario user) =>
      moviesApiProvider.addPlaylist(playlist, user.id);

  Future<List<Searchable>> search(String query, String type) =>
      moviesApiProvider.search(query, type);

  Future<List<Genero>> fetchGeneros() => moviesApiProvider.fetchGeneros();

  Future<List<Cinematografia>> searchByGenero(Genero genero) =>
      moviesApiProvider.searchByGenero(genero);

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

  Future<bool> changeVisibility(Playlist playlist) {
    return moviesApiProvider.changeVisibility(playlist);
  }

  Future<bool> deletaPlaylist(Playlist playlist) {
    return moviesApiProvider.deletaPlaylist(playlist);
  }

  Future<bool> deletaItemPlaylist(Playlist playlist, Cinematografia cinematografia) {
    return moviesApiProvider.deletaItemPlaylist(playlist, cinematografia);
  }

  Future<bool> changeFollowPlaylist(Playlist playlist, bool seguir) {
    return moviesApiProvider.changeFollowPlaylist(playlist, seguir);
  }


}
