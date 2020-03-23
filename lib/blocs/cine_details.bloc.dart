import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/episodio.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/temporada.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class CineDetailsBloc extends BlocBase{

  final _cineController = BehaviorSubject<Cinematografia>();
  final _temporadaController = BehaviorSubject<Temporada>();
  final _episodioController = BehaviorSubject<List<Episodio>>();

  Stream get outCine =>_cineController.stream;
  Stream get outTemporada => _temporadaController.stream;
  Stream get outEpisodios => _episodioController.stream;

  final ApiRepository _apiRepository = ApiRepository();

  Future<void> search(Cinematografia cinematografia) async {
    Cinematografia cinematografiaFetched = await _apiRepository.fetchDetailsCinematografia(cinematografia);
    if(cinematografiaFetched == null){
      _cineController.addError("Dados não encontrados");
    }else {
      _cineController.add(
          cinematografiaFetched);

      if(cinematografiaFetched is Serie)
        changeTemporada(cinematografiaFetched.temporadas?.elementAt(0));
    }
  }

  @override
  void dispose() {
    _cineController.close();
    _temporadaController.close();
    _episodioController.close();
    super.dispose();
  }

  void changeTemporada(Temporada value) {
    _temporadaController.add(value);
    _episodioController.add(value.episodios);
  }
}