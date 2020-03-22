

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/search_query.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/usuario_detail.page.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/custom_search.dart';
import 'package:prj/widgets/poster_tile.dart';
import 'package:prj/widgets/user_tile.dart';

import 'playlist_detail.page.dart';

class BuscaQueryPage extends StatefulWidget {


  @override
  _BuscaQueryPageState createState() => _BuscaQueryPageState();
}

class _BuscaQueryPageState extends State<BuscaQueryPage> {

  SearchQueryBloc _searchQueryBloc;
  String _query = '';

  static const _types = <String>['Filmes', 'Séries', 'Playlists', 'Usuários'];

  @override
  void initState() {
    _searchQueryBloc = SearchQueryBloc();
    super.initState();
  }

  @override
  void dispose() {
    _searchQueryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomSearch(
                popBackStack:true,
                hint: 'Pesquise aqui...',
                onSubmit:(text){
                  _searchQueryBloc.searchResults(text);
                },
                onChanged:(text){
                  _query = text;
                  if(text.isEmpty){
                    _searchQueryBloc.setResults(null);
                  }else{
                    _searchQueryBloc.searchResults(text);
                  }
                }
            ),

            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Text(
                    "Buscar por",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  StreamBuilder<String>(
                   stream: _searchQueryBloc.outTypeSearch,
                    initialData: _types.elementAt(0),
                    builder: (context, snapshot) {
                      return DropdownButton<String>(
                        items: _types.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        value: snapshot.data,
                        onChanged: (value) {
                          _searchQueryBloc.setTypeSearch(value);
                        },
                      );
                    },

                  ),

                ],
              ),
            ),

            SizedBox(height: 10,),

            Expanded(
              child: StreamBuilder<List<Searchable>>(
                initialData: null,
                stream: _searchQueryBloc.outResults,
                builder: (context, snapshot) {

                  if(!snapshot.hasData){
                    if(_query.isEmpty) {
                      return _buildMessageHelp();
                    }else{
                      return CustomLoading();
                    }
                  }

                  if(snapshot.data.isEmpty){
                    return _buildMessageEmpty();
                  }

                  return _buildResults(context, snapshot.data);

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCinematografia(BuildContext context, Cinematografia searchable) {

    Function onTap = (){
//      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>DetailsCinePage()));
        print('tapped');
    };

    return  PosterTile(searchable.urlPoster, onTap: onTap);
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
      staggeredTileBuilder: (_) => StaggeredTile.fit(1),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      itemCount: data.length,
      itemBuilder: (context, index) {
        Searchable searchable = data.elementAt(index);
        if (searchable is Cinematografia) {
          return _buildCinematografia(context, searchable);
        } else if (searchable is Usuario) {
          return _buildUsuario(context, searchable);
        } else {
          return _buildPlaylist(context, searchable as Playlist);
        }
      },
      crossAxisCount: 2,
    );
  }

  Widget _buildUsuario(BuildContext context, Usuario searchable) {
    return InkWell(

      onTap:(){
        Navigator.of(context).push(MaterialPageRoute(
            builder:(_)=>UsuarioDetailPage(searchable)
        ));
      },
      child: Card(
          child: Container(
              padding: EdgeInsets.all(25), child: Column(
                children: <Widget>[
                  UserTile(searchable, size: 100,),
                  SizedBox(height: 10,),
                  Text(searchable.nome,style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 16
                  )),
                ],
              ))),
    );
  }

  Widget _buildPlaylist(BuildContext context, Playlist searchable) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>  PlaylistDetailPage(searchable)
        ));
      },
      child: Stack(children: <Widget>[
        PosterTile(searchable.poster),
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,
          child: Container(
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text((searchable.qtdFilmes+searchable.qtdSeries).toStringAsFixed(0), style: Theme.of(context).textTheme.title,),
                Text(searchable.nome, style: Theme.of(context).textTheme.subhead,),
              ],
            ),
            alignment: Alignment.center,
            color: Colors.black.withAlpha(95),
          ),
        ),
      ],),
    );
  }

  Widget _buildMessageHelp() {
    return CenteredMessage(
        icon: Icons.search,
        title: "Já sabe o que deseja?",
        subtitle:
        "Digite no campo de busca acima e\ndesfrute dos resultados");
  }
}
