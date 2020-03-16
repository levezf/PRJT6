

import 'dart:async';

class ListaValidators{

  final validateNomeLista = StreamTransformer<String, String>.fromHandlers(
      handleData: (nomeLista, sink){
        if(nomeLista.length>=3){
          sink.add(nomeLista);
        } else {
          sink.addError("Deve ter pelo menos 3 caracteres");
        }
      }
  );

}