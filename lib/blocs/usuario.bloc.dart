

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/operation.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:prj/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';



class UsuarioBloc extends BlocBase with LoginValidators {

  Usuario user;
  
  final _userController = BehaviorSubject<Usuario>();
  final _salvosController = BehaviorSubject<List<Playlist>>();
  final _generosController = BehaviorSubject<List<Genero>>();
  final _seguidoresController = BehaviorSubject<List<Usuario>>();
  final _seguindoController = BehaviorSubject<List<Usuario>>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  final ApiRepository _apiRepository = ApiRepository();

  bool login = false;
  
  Stream get outUsuario => _userController.stream;
  Stream get outSalvos => _salvosController.stream;
  Stream get outGenerosFavoritos => _generosController.stream;
  Stream get outSeguindo => _seguindoController.stream;
  Stream get outSeguidores => _seguidoresController.stream;
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outSenha=> _passwordController.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeSenha => _passwordController.sink.add;

/*
  Stream<bool> get outSubmitValid => Observable.combineLatest2(
      outEmail, outSenha, (a, b) => true
  );
*/

  UsuarioBloc(Usuario user){
    this.user = user;
    _userController.add(user);
    _salvosController.add(user.playlistsSalvas);
    _generosController.add(user.generosFavoritos);
    _seguidoresController.add(user.seguidores);
    _seguindoController.add(user.seguindo);
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
    super.dispose();
  }

  Future<void> updateSalvos(Playlist playlist, Operation operation) async{
    
    _salvosController.add(null);
    user.playlistsSalvas.clear();
    List<Playlist> newPlaylists = [];

    switch (operation) {
    
      case Operation.Update:
        newPlaylists = await _apiRepository.updatePlaylist(playlist, user);
        break;
      case Operation.Remove:
        newPlaylists = await _apiRepository.removePlaylist(playlist, user);
        break;
      case Operation.Add:
        newPlaylists = await _apiRepository.addPlaylist(playlist, user);
        break;
    }
    user.playlistsSalvas = newPlaylists;
    _salvosController.add(user.playlistsSalvas);

  }

   void searchUsuario(String id) async {
    user = await _apiRepository.fetchDetailsUsuario(id);
    _userController.add(user);
    _salvosController.add(user.playlistsSalvas);
  }

  bool estaSeguindo(Usuario follow) {
    return user.seguindo.contains(follow);
  }

  Future<void> updateFollow(String type, Usuario follow, Operation operation) async {

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
  }

  bool _isTypeSeguidor(String type){
    return type=="Seguidores";
  }

  bool isLogged() {
    return login;
  }
}