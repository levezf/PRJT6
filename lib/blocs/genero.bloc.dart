

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class GeneroBloc extends BlocBase{

  final _cinesControtroller = BehaviorSubject<List<Cinematografia>>();
  final ApiRepository _apiRepository = ApiRepository();
  final Genero _genero;

  Stream get outCines => _cinesControtroller.stream;

  GeneroBloc(this._genero){
    _search();
  }

  Future<void> _search() async {
    _cinesControtroller.add(
      await _apiRepository.searchByGenero(_genero)
    );
  }

  @override
  void dispose() {
    _cinesControtroller.close();
    super.dispose();
  }


}