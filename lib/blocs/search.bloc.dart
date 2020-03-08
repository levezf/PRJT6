import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BlocBase {
  final _generosController = BehaviorSubject<List<Genero>>();

  Stream get outGeneros => _generosController.stream;

  final ApiRepository _apiRepository = ApiRepository();

  SearchBloc() {
    searchGeneros();
  }

  Future<void> searchGeneros() async {
    _generosController.add(await _apiRepository.fetchGeneros());
  }

  @override
  void dispose() {
    _generosController.close();
    super.dispose();
  }
}
