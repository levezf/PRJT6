import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BlocBase {
  final _searchController = BehaviorSubject<List<Searchable>>();
  final _generosController = BehaviorSubject<List<Genero>>();
  final _stateController = BehaviorSubject<ScreenState>();

  Stream get outResults => _searchController.stream;
  Stream get outGeneros => _generosController.stream;

  final ApiRepository _apiRepository = ApiRepository();

  SearchBloc() {
    searchGeneros();
  }

  Future<void> searchGeneros() async {
    _generosController.add(await _apiRepository.fetchGeneros());
  }

  Future<void> searchResults(String query) async {
    _stateController.add(ScreenState.LOADING);
    _searchController.add(await _apiRepository.search(query));
    _stateController.add(ScreenState.IDLE);
  }

  @override
  void dispose() {
    _generosController.close();
    _searchController.close();
    _stateController.close();
    super.dispose();
  }

  void setResults(Object object) {
    _searchController.add(object);
  }
}
