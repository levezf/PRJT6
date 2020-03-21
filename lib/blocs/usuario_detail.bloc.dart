

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/repositories/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioDetailBloc extends BlocBase{
  
  final _usuarioController = BehaviorSubject<Usuario>();
  Stream get outUsuario => _usuarioController.stream;

  ApiProvider _apiProvider = ApiProvider();

  UsuarioDetailBloc(Usuario usuario){
    _searchDetailsUsuario(usuario);
  }

  @override
  void dispose() {
    _usuarioController.close();
    super.dispose();
  }

  Future<void> _searchDetailsUsuario(Usuario usuario) async {
    _usuarioController.add(await _apiProvider.fetchDetailsUsuario(usuario.id));
  }
  
}