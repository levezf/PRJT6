import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/inicio.bloc.dart';
import 'package:prj/blocs/main.bloc.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/pages/home.page.dart';
import 'package:prj/pages/sem_conexao.page.dart';
import 'package:prj/pages/splash.page.dart';
import 'package:prj/widgets/custom_loading.dart';

import 'blocs/embreve.bloc.dart';
import 'blocs/search.bloc.dart';
import 'models/genero.dart';
import 'models/playlist.dart';
import 'models/usuario.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MainBloc _homePageBloc;

  @override
  void initState() {
    _homePageBloc = MainBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UsuarioBloc _userbloc = UsuarioBloc(null);
    InicioBloc _inicioBloc = InicioBloc();
    EmBreveBloc _embreveBloc = EmBreveBloc();
    SearchBloc _searchBloc = SearchBloc();
    return BlocProvider(
      blocs: [Bloc((i) => _userbloc),
        Bloc((i) => _inicioBloc),
        Bloc((i) => _embreveBloc),
        Bloc((i) => _searchBloc)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            accentColor: kAccentColor,
            backgroundColor: kBackgroundColor,
            buttonTheme: ButtonThemeData(
                buttonColor: kWhiteColor, textTheme: ButtonTextTheme.primary),
            scaffoldBackgroundColor: kBackgroundColor,
            textTheme: TextTheme(
              title: TextStyle(),
              subtitle: TextStyle(color: kGrayColor),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: kAccentColor, foregroundColor: kWhiteColor)),
        home: StreamBuilder<bool>(
            initialData: null,
            stream: _homePageBloc.outConexao,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                    body: CustomLoading());
              }
              if (snapshot.data) {
                if(_userbloc.isLogged()){
                  return HomePage();
                }else{
                  return SplashPage();
                }
              }
              return SemConexaoPage();
            }),
      ),
    );
  }
}
