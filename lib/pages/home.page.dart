import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/colors.dart';

import 'busca.page.dart';
import 'embreve.page.dart';
import 'inicio.page.dart';
import 'perfil.page.dart';
import 'salvos.page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  

  static final _widgetsBar = <Widget>[
    InicioPage(),
    BuscaPage(),
    EmBrevePage(),
    SalvosPage(),
    PerfilPage()
  ];

  @override
  void initState() {
    BlocProvider.getBloc<UsuarioBloc>().login = true;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _widgetsBar.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Search")),
          BottomNavigationBarItem(
              icon: Icon(Icons.queue_play_next), title: Text("News")),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), title: Text("Playlists")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Me")),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: kAccentColor,
        unselectedItemColor: kGrayColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
