import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/subjects.dart';

class InicioBloc extends BlocBase {
  final _usersSugeriosController = BehaviorSubject<List<Usuario>>();
  final _stateController = BehaviorSubject<ScreenState>();
  final _playlistsSugeridasController = BehaviorSubject<List<Playlist>>();
  final _videoDestaqueFilmeController = BehaviorSubject<String>();
  final _videoDestaqueSerieController = BehaviorSubject<String>();
  final _filmesSugeridosController = BehaviorSubject<Map<String, List<Cinematografia>>>();
  final _seriesSugeridasController = BehaviorSubject<Map<String, List<Cinematografia>>>();

  final ApiRepository _apiRepository = ApiRepository();

  Stream get outState => _stateController.stream;
  Stream get outPlaylist => _playlistsSugeridasController.stream;
  Stream get outUsuarios => _usersSugeriosController.stream;
  Stream get outDestaqueFilme => _videoDestaqueFilmeController.stream;
  Stream get outDestaqueSerie => _videoDestaqueSerieController.stream;
  Stream get outFilmes => _filmesSugeridosController.stream;
  Stream get outSeries => _seriesSugeridasController.stream;

  @override
  void dispose() {
    _usersSugeriosController.close();
    _filmesSugeridosController.close();
    _seriesSugeridasController.close();
    _playlistsSugeridasController.close();
    _stateController.close();
    _videoDestaqueFilmeController.close();
    _videoDestaqueSerieController.close();
    super.dispose();
  }

  void searchResults() async {
    _stateController.add(ScreenState.LOADING);

    _usersSugeriosController.add(
      await _apiRepository.fetchUsuariosDestaques()
    );
    _filmesSugeridosController.add(
      await _apiRepository.fetchFilmeDestaques()
    );
    _seriesSugeridasController.add(
      await _apiRepository.fetchSerieDestaques()
    );
    _playlistsSugeridasController.add(
      await _apiRepository.fetchPlaylistsDestaques()
    );
    _videoDestaqueFilmeController.add(
            await _apiRepository.fetchVideoFilmeDestaque()
    );
    _videoDestaqueSerieController.add(
            await _apiRepository.fetchVideoSerieDestaque()
    );
    _stateController.add(ScreenState.IDLE);
  }
}
