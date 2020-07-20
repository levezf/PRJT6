

import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/repositories/api_repository.dart';
import 'package:prj/repositories/cineplus_shared_preferences.dart';
import 'package:prj/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroBloc extends BlocBase with LoginValidators{

  final _nomeController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _senhaConfirmController = BehaviorSubject<String>();
  final _descricaoController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject<File>();

  final ApiRepository _apiRepository = ApiRepository();


  Stream<File> get outImage => _imageController.stream;
  Stream<String> get outDescricao => _descricaoController.stream;
  Stream<String> get outNome => _nomeController.stream.transform(validateNome);
  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outSenha => _passwordController.stream.transform(validatePassword);
  Stream<String> get outSenhaConfirm => _senhaConfirmController.stream.transform(StreamTransformer<String, String>.fromHandlers(
    handleData: (String confirm, sink){
      if(confirm?.trim()!=_passwordController.value?.trim()){
        sink.addError("As senhas não correspondem");
      }else{
        sink.add(confirm);
      }
    }
  ));

  Stream<bool> get outSubmitValid => Observable.combineLatest4(
      outEmail, outSenha, outNome, outSenhaConfirm, (a, b, c, d) => true
  );

  Function(String) get changeConfirmSenha => _senhaConfirmController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeSenha => _passwordController.sink.add;
  Function(String) get changeNome => _nomeController.sink.add;
  Function(String) get changeDescricao => _descricaoController.sink.add;

  Future<bool> save()async{
    final String senha = _passwordController.value;
    final String email = _emailController.value;
    final String nome = _nomeController.value;
    final String descricao = _descricaoController.value;
    final File image = _imageController.value;

    Usuario usuario = Usuario();
    usuario.nome = nome;
    usuario.descricao = descricao;
    usuario.email = email;

    String token = await _apiRepository.createUser(email, senha);
    if(token!=null && token.isNotEmpty){
      usuario.id = await CineplusSharedPreferences.instance.getIdUser();
      String path = image?.path;
      return await _apiRepository.saveProfile(token, usuario, path);
    }

    return false;
  }

  @override
  void dispose() {
    _senhaConfirmController.close();
    _descricaoController.close();
    _emailController.close();
    _passwordController.close();
    _nomeController.close();
    _imageController.close();
    super.dispose();
  }

  void changeImage(File image) {
    _imageController.add(image);
  }

}