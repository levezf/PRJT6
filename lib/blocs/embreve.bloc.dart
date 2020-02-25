

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:rxdart/rxdart.dart';

class EmBreveBloc extends BlocBase {

  final _cinematrografiasController = BehaviorSubject<List<Cinematografia>>();
  final ApiRepository _apiRepository = ApiRepository(); 
  
  Stream get outResults => _cinematrografiasController.stream;

  @override
  void dispose() {
    _cinematrografiasController.close();
    super.dispose();
  }

   void searchResults() async {
    _cinematrografiasController.add(
      await _apiRepository.fetchEmBreve()
    );
  }
}