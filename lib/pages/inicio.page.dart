import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/inicio.bloc.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/enums/type_cinematographic.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/usuario_detail.page.dart';
import 'package:prj/widgets/category_cine_list_tile.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/list_horizontal.dart';
import 'package:prj/widgets/playlist_tile.dart';
import 'package:prj/widgets/user_tile.dart';
import 'package:prj/widgets/video_widget.dart';
class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage>
    with SingleTickerProviderStateMixin {
  InicioBloc _inicioBloc;
  TabController _tabController;

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Filmes"),
    new Tab(text: "Séries"),
  ];

  var _videoController;

  @override
  void initState() {
    _inicioBloc = BlocProvider.getBloc<InicioBloc>();
    _tabController = new TabController(vsync: this, length: tabs.length);
    super.initState();
  }

/*  @override
  void dispose() {
    _tabController?.dispose();
    _inicioBloc?.dispose();
    _videoController?.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Colors.blueAccent,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            tabs: tabs,
            controller: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return _buildPage(
              context,
              tabs.indexOf(tab) == 0
                  ? TypeCinematographic.Filme
                  : TypeCinematographic.Serie);
        }).toList(),
      ),
    );
  }

  Widget _buildPage(
      BuildContext context, TypeCinematographic typeCinematographic) {
    _inicioBloc.searchResults();

    return StreamBuilder<ScreenState>(
      stream: _inicioBloc.outState,
      initialData: ScreenState.IDLE,
      builder: (context, snapshot) {
        if (snapshot.data == ScreenState.IDLE) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _buildVideo(typeCinematographic),
                SizedBox(
                  height: 20,
                ),
                _buildListUsuarios(),
                _buildListCinematografia(typeCinematographic),
                SizedBox(
                  height: 20,
                ),
                _buildListPLaylist(),
              ],
            ),
          );
        } else {
          return _loading();
        }
      },
    );
  }

  StreamBuilder<String> _buildVideo(TypeCinematographic typeCinematographic) {
    return StreamBuilder<String>(
      stream: typeCinematographic == TypeCinematographic.Filme
          ? _inicioBloc.outDestaqueFilme
          : _inicioBloc.outDestaqueSerie,
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return CustomLoading();
        }
        return Container(
          height: 200,
          child:  VideoWidget(videoUrl: snapshot.data,
        ),
        );
      },
    );
  }

  StreamBuilder<Map<String, List<Cinematografia>>> _buildListCinematografia(
      TypeCinematographic typeCinematographic) {
    return StreamBuilder<Map<String, List<Cinematografia>>>(
      stream: typeCinematographic == TypeCinematographic.Filme
          ? _inicioBloc.outFilmes
          : _inicioBloc.outSeries,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _loading();
        }

        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              MapEntry entry = snapshot.data.entries.elementAt(index);
              return CategoryCineListTile(entry.key, entry.value);
            });
      },
    );
  }

  StreamBuilder<List<Playlist>> _buildListPLaylist() {
    return StreamBuilder<List<Playlist>>(
      stream: _inicioBloc.outPlaylist,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _loading();
        }
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return PlaylistTile(snapshot.data.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 60),
              child: Divider(),
            );
          },
        );
      },
    );
  }

  StreamBuilder<List<Usuario>> _buildListUsuarios() {
    return StreamBuilder<List<Usuario>>(
      stream: _inicioBloc.outUsuarios,
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _loading();
        }

        return ListHorizontal(
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_)=>UsuarioDetailPage(snapshot.data.elementAt(index))
                    ));
                  },
                  child: UserTile(snapshot.data.elementAt(index), size: 80));
            },
            itemCount: snapshot.data.length,
            title: "Usuários",
            size: 80);
      },
    );
  }

  Widget _loading() {
    return Container(
      padding: EdgeInsets.all(16),
      child: CustomLoading(),
    );
  }
}
