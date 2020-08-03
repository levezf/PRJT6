

import 'dart:async';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/operation.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:prj/repositories/cineplus_shared_preferences.dart';
import 'package:prj/validators/lista_validators.dart';
import 'package:prj/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';



class UsuarioBloc extends BlocBase with LoginValidators, ListaValidators {

  Usuario user;
  
  final _userController = BehaviorSubject<Usuario>();
  final _salvosController = BehaviorSubject<List<Playlist>>();
  final _generosController = BehaviorSubject<List<Genero>>();
  final _seguidoresController = BehaviorSubject<List<Usuario>>();
  final _seguindoController = BehaviorSubject<List<Usuario>>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nomeListaController = BehaviorSubject<String>();
  final _isListaPrivada = BehaviorSubject<bool>();

  final ApiRepository _apiRepository = ApiRepository();

  bool login = false;


  Stream get outUsuario => _userController.stream;
  Stream get outSalvos => _salvosController.stream;
  Stream<List<Playlist>> get outOwnSalvos => _salvosController.stream.transform(StreamTransformer<List<Playlist>, List<Playlist>>.fromHandlers(
      handleData: (playlists, sink) {
        if(playlists==null) playlists = [];
        List<Playlist> listFiltered= playlists.where((element) => this.isOwner(element)).toList();
        if(listFiltered==null) listFiltered = [];
        sink.add(listFiltered);
      }
  ));
  Stream get outGenerosFavoritos => _generosController.stream;
  Stream get outSeguindo => _seguindoController.stream;
  Stream get outSeguidores => _seguidoresController.stream;
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outSenha=> _passwordController.stream.transform(validatePassword);
  Stream<String> get outNomeNewLista=> _nomeListaController.stream.transform(validateNomeLista);
  Stream<bool> get outIsListaPrivada=> _isListaPrivada.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeSenha => _passwordController.sink.add;
  Function(String) get changeNomeLista => _nomeListaController.sink.add;
  Function(bool) get changeIsListaPrivada => _isListaPrivada.sink.add;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(
      outEmail, outSenha, (a, b) => true
  );

  UsuarioBloc(Usuario user){
    setUser(user);
    CineplusSharedPreferences.instance.getToken().then((value) => login = (value!=null && value.isNotEmpty));
  }

  Future<bool> doLogin() async{
    try {
      String email = _emailController.value;
      String senha = _passwordController.value;
      return await _apiRepository.login(email, senha);
    }catch(e){
      print(e);
      return false;
    }
  }


  Future<void> doAutoLogin() async{
    login = await _apiRepository.autoLogin();
  }

  @override
  void dispose() {
    _userController.close();
    _salvosController.close();
    _generosController.close();
    _seguindoController.close();
    _seguidoresController.close();
    _passwordController.close();
    _emailController.close();
    _nomeListaController.close();
    _isListaPrivada.close();
    super.dispose();
  }

  Future<void> updateSalvos(Playlist playlist, Operation operation) async{

    playlist.nome = _nomeListaController.value;
    playlist.privada = _isListaPrivada.value!=null && _isListaPrivada.value;

    _nomeListaController.add(null);
    _isListaPrivada.add(null);
    _salvosController.add(null);

    if(user.playlistsSalvas==null){
      user.playlistsSalvas = [];
    }
    switch (operation) {
    
      case Operation.Update:
//        Playlist updatePlaylist = await _apiRepository.updatePlaylist(playlist, user);
//        user.playlistsSalvas.remove(updatePlaylist);
//        user.playlistsSalvas.insert(updatePlaylist);
        break;
      case Operation.Remove:
//        Playlist removePlaylist  = await _apiRepository.removePlaylist(playlist, user);
//        user.playlistsSalvas.remove(removePlaylist);
        break;
      case Operation.Add:
        Playlist newPlaylist = await _apiRepository.addPlaylist(playlist, user);
        if(newPlaylist!=null)
          user.playlistsSalvas.add(newPlaylist);
        break;
    }
    _salvosController.add(user.playlistsSalvas);

  }

   void searchUsuario(int id) async {
    user = await _apiRepository.fetchDetailsUsuario(id);
    setUser(user);
  }

  bool estaSeguindo(Usuario follow) {
    return  user.seguindo!=null && user.seguindo.contains(follow);
  }

/*  Future<void> updateFollow(String type, Usuario follow, Operation operation) async {

    if(_isTypeSeguidor(type)){
      _seguidoresController.add(null);
      user.seguidores.clear();
    }else{
      _seguindoController.add(null);
      user.seguindo.clear();
    }

    List<Usuario> newFollows= [];

    switch (operation) {

      case Operation.Update:
        newFollows = await _apiRepository.updateFollows(follow, user);
        break;
      case Operation.Remove:
        newFollows = await _apiRepository.removeFollows(follow, user);
        break;
      case Operation.Add:
        newFollows = await _apiRepository.addFollows(follow, user);
        break;
    }

    if(_isTypeSeguidor(type)){
      user.seguidores = newFollows;
      _seguidoresController.add(user.seguidores);
    }else{
      user.seguindo = newFollows;
      _seguindoController.add(user.seguindo);
    }
  }*/

  bool _isTypeSeguidor(String type){
    return type=="Seguidores";
  }

  bool isLogged() {
    return login;
  }

  Future<void> logout() async {
    CineplusSharedPreferences.instance.clearShared();
    login = false;
    user = null;
    _userController.add(null);
  }

  void setUser(Usuario user) {
    this.user = user;
    _userController.add(user);
    if(user!=null) {
      _salvosController.add(user.playlistsSalvas);
      _seguidoresController.add(user.seguidores);
      _seguindoController.add(user.seguindo);
    }else{
      _salvosController.add(null);
      _generosController.add(null);
      _seguidoresController.add(null);
      _seguindoController.add(null);

    }
    _nomeListaController.add(null);
  }

  Future<bool> addCineInPlaylist(Cinematografia cinematografia, Playlist playlist) async {
    return await _apiRepository.addCineInPlaylist(cinematografia, playlist);
  }

  Future<bool> seguir(Usuario usuario) async{
    return await _apiRepository.seguir(usuario);
  }

  Future<bool> pararDeSeguir(Usuario usuario) async{
    return await _apiRepository.pararDeSeguir(usuario);
  }

  bool isOwner(Playlist playlist) {
    return playlist.idCriador == user.id;
  }
}