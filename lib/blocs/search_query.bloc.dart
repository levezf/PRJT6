import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchQueryBloc extends BlocBase {

  String _lastQuery;

  final _searchController = BehaviorSubject<List<Searchable>>();
  final _typeSearchController = BehaviorSubject<String>();

  Stream get outResults => _searchController.stream;
  Stream get outTypeSearch => _typeSearchController.stream;

  final ApiRepository _apiRepository = ApiRepository();


  SearchQueryBloc(){
    _typeSearchController.add("Filmes");
  }

  Future<void> searchResults(String query, {String type}) async {
    _lastQuery = query;
    _searchController.add(await _apiRepository.search(query, type!=null? type : _typeSearchController.value));
  }

  @override
  void dispose() {
    _searchController.close();
    _typeSearchController.close();
    super.dispose();
  }

  void setResults(List<Searchable> list) {
    _searchController.add(list);
  }

  void setTypeSearch(String newType){
    _typeSearchController.add(newType);
    _searchController.add([]);
    if(_lastQuery!=null && _lastQuery.isNotEmpty)
      searchResults(_lastQuery, type: newType);
  }
}
