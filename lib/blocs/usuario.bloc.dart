

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/operation.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/subjects.dart';



class UsuarioBloc extends BlocBase{

  Usuario user;
  
  final _userController = BehaviorSubject<Usuario>();
  final _salvosController = BehaviorSubject<List<Playlist>>();
  final _generosController = BehaviorSubject<List<Genero>>();
  final ApiRepository _apiRepository = ApiRepository(); 
  
  Stream get outUsuario => _userController.stream;
  Stream get outSalvos => _salvosController.stream;
  Stream get outGenerosFavoritos => _generosController.stream;


  UsuarioBloc(Usuario user){
    this.user = user;
    _userController.add(user);
    _salvosController.add(user.playlistsSalvas);
    _generosController.add(user.generosFavoritos);
  }

  @override
  void dispose() {
    _userController.close();
    _salvosController.close();
    _generosController.close();
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
}