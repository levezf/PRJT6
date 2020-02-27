import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/search.bloc.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';

class BuscaPage extends StatefulWidget {
  @override
  _BuscaPageState createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  SearchBloc _searchBloc;

  @override
  void initState() {
    _searchBloc = SearchBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Card(
            child: Container(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.search),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () async {
                        _searchBloc.setResults([]);
                      },
                      onChanged: (text) {
                        if (text.isEmpty) {
                          _searchBloc.setResults(null);
                        }
                      },
                      onSubmitted: (query) {
                        _searchBloc.searchResults(query);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Pesquise aqui'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<ScreenState>(
        initialData: ScreenState.IDLE,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == ScreenState.LOADING) {
            return CustomLoading();
          }

          return StreamBuilder<List<Searchable>>(
            initialData: null,
            stream: _searchBloc.outResults,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildGenerosList(context);
              }
              if (snapshot.data.isEmpty) {
                return _buildMessageEmpty();
              }

              return _buildResults(context, snapshot.data);
            },
          );
        },
      ),
    );
  }

  Widget _buildGenerosList(BuildContext context) {
    return StreamBuilder<List<Genero>>(
      stream: _searchBloc.outGeneros,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomLoading();
        }
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Generos",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Genero genero = snapshot.data.elementAt(index);
                  return ListTile(
                    title: Text(
                      genero.nome,
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                    onTap: () {},
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageEmpty() {
    return CenteredMessage(
        icon: Icons.error_outline,
        title: "Nenhum resultado encontado",
        subtitle:
            "Utilize o campo de busca acima para encontrar\nfilmes, séries, pessoas e playlists!");
  }

  Widget _buildResults(BuildContext context, List<Searchable> data) {
    return StaggeredGridView.countBuilder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      
        staggeredTileBuilder: (index) => StaggeredTile.extent(10,2),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 4.0,
        itemCount: data.length,
        itemBuilder: (context, index) {
          Searchable searchable = data.elementAt(index);
          if (searchable is Cinematografia) {
            return Container(
              color: Colors.yellow,
            );
          } else if (searchable is Usuario) {
            return Container(
              color: Colors.red,
            );
          } else if (searchable is Playlist) {
            return Container(
              color: Colors.blue,
            );
          }

          return Container(
            height: 40,
            color: Colors.orangeAccent,
          );
        },
        crossAxisCount: 2,);
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }
}
