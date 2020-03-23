

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlaylistDetailsBloc extends BlocBase{

  final _playlistController = BehaviorSubject<Playlist>();

  Stream get outPlaylist =>_playlistController.stream;

  final ApiRepository _apiRepository = ApiRepository();

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
    super.dispose();
  }

  bool isOwner(Playlist playlist) {
    return playlist.idCriador == BlocProvider.getBloc<UsuarioBloc>().user.id;
  }
}