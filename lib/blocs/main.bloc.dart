import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connectivity/connectivity.dart';

class MainBloc extends BlocBase {
  final _connectionChangeController = BehaviorSubject<bool>();

  final Connectivity _connectivity = Connectivity();
  Stream get outConexao => _connectionChangeController.stream;

  MainBloc(){
    _connectivity.onConnectivityChanged.listen((_) async {
        bool hasConnection = false;
        try {
            final result = await InternetAddress.lookup('google.com.br');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                hasConnection = true;
            } else {
                hasConnection = false;
            }
        } on SocketException catch(_) {
            hasConnection = false;
        }

        if (_connectionChangeController.value != hasConnection) {
            _connectionChangeController.add(hasConnection);
        }
    });
  }


  @override
  void dispose() {
    _connectionChangeController.close();
    super.dispose();
  }
}
