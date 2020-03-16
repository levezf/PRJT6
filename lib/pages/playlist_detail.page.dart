
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/playlist_details.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/poster_tile.dart';

class PlaylistDetailPage extends StatefulWidget {

  Playlist _playlist;

  PlaylistDetailPage(this._playlist);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {

  PlaylistDetailsBloc _detailsBloc;

  @override
  void initState() {
    _detailsBloc = PlaylistDetailsBloc();
    _detailsBloc.search(widget._playlist);
    super.initState();
  }

  @override
  void dispose() {
    _detailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CloseButton(),
      ),

      body: StreamBuilder<Playlist>(
          stream: _detailsBloc.outPlaylist,
          initialData: null,
          builder: (context, snapshot) {

            if(!snapshot.hasData){
              return CustomLoading();
            }

            if(snapshot.hasError){
              return CenteredMessage(
                  icon: Icons.error_outline,
                  title: "Nenhum resultado encontado",
                  subtitle: snapshot.error
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildHeader(context, snapshot.data),
                  _buildList(context, snapshot.data),
                ],
              ),
            );
          }
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

  Widget _buildList(BuildContext context, Playlist playlist) {
    return Container(
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        staggeredTileBuilder: (_) => StaggeredTile.fit(1),
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        itemCount: playlist.cinematografias.length,
        itemBuilder: (context, index) {
          Cinematografia cine = playlist.cinematografias.elementAt(index);
          return _buildCinematografia(context, cine);
        },
        crossAxisCount: 2,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Playlist playlist) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(playlist.nome),
            Text('${playlist.qtdSeguidores}'),
            Text(playlist.nome),

          ],
        ),
      ),
    );
  }
}
