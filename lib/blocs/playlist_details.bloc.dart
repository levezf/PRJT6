

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlaylistDetailsBloc extends BlocBase{

  final _playlistController = BehaviorSubject<Playlist>();
  final _nomeController = BehaviorSubject<String>();

  Function(String) get changeNome => _nomeController.sink.add;

  Stream get outPlaylist =>_playlistController.stream;
  Stream<String> get outNome =>_nomeController.stream;

  final ApiRepository _apiRepository = ApiRepository();

  bool estaSeguindo(Playlist playlist) {
    return  BlocProvider.getBloc<UsuarioBloc>().user.playlistsSalvas!=null &&
        BlocProvider.getBloc<UsuarioBloc>().user.playlistsSalvas.contains(playlist);
  }

  Future<void> search(Playlist playlist) async {
    Playlist playlistFetched = await _apiRepository.fetchDetailsPlaylist(playlist);
    if(playlistFetched == null){
      _playlistController.addError("Playlist não encontrada");
    }else {
      _playlistController.add(playlistFetched);
    }
  }

  @override
  void dispose() {
    _playlistController.close();
    _nomeController.close();
    super.dispose();
  }

  bool isOwner(Playlist playlist) {
    return playlist.idCriador == BlocProvider.getBloc<UsuarioBloc>().user.id;
  }

  Future<void> changeVisibility (Playlist playlist) async {
    await _apiRepository.changeVisibility(playlist);
    _playlistController.add(null);
    search(playlist);
  }

  Future<bool> deletaPLaylist(Playlist playlist)async {
    return await _apiRepository.deletaPlaylist(playlist);
  }

  Future<bool> changeFollow(Playlist playlist)async {
    final result =  await _apiRepository.changeFollowPlaylist(playlist, !estaSeguindo(playlist));
    if(result){
       await search(playlist);
      return true;
    }
    return false;
  }

  Future<bool> deletaItemPlaylist(Cinematografia searchable, Playlist playlist) async{
    return await _apiRepository.deletaItemPlaylist(playlist, searchable);
  }


  Future<bool> saveNewNome(Playlist playlist)async {
    String nome = _nomeController.value;
    final result =  await _apiRepository.changeNomePlaylist(nome, playlist);
    if(result){
      await search(playlist);
      _nomeController.add(null);
      return true;
    }
    _nomeController.add(null);
    return false;
  }
}