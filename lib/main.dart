import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/pages/home.page.dart';

import 'models/genero.dart';
import 'models/playlist.dart';
import 'models/usuario.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

   Usuario user = Usuario(
      nome: "Felipe Bertelli Levez",
      avatar:
          "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg",
          playlistsSalvas: List<Playlist>.generate(
        10,
        (index) => Playlist(
            nome: "Playlist $index", qtdSeguidores: 10, privada: false)),
            generosFavoritos: List<Genero>.generate(
        10,
        (index) => Genero(
            nome: "Playlist $index", id: "$index")));

  @override
  Widget build(BuildContext context) {
    UsuarioBloc _userbloc = UsuarioBloc(user);
    return BlocProvider(
      blocs: [
        Bloc((i)=> _userbloc)
      ],
          child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          accentColor: kAccentColor,
          backgroundColor: kBackgroundColor,
          buttonTheme: ButtonThemeData(
              buttonColor: kWhiteColor, textTheme: ButtonTextTheme.primary),
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            title: TextStyle(),
            subtitle: TextStyle(color: kGrayColor),),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: kAccentColor,
              foregroundColor: kWhiteColor
            )
        ),
        home: HomePage(),
      ),
    );
  }
}
