
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/playlist_details.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/cine_detail.page.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_button.dart';
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
              child: Padding(
                child: Column(
                  children: <Widget>[
                    _buildHeader(context, snapshot.data),
                    _buildList(context, snapshot.data),
                  ],
                ), padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            );
          }
      ),

    );
  }

  Widget _buildCinematografia(BuildContext context, Cinematografia searchable) {

    Function onTap = (){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_)=>CineDetailPage(searchable)
      ));
    };

    return  PosterTile(searchable.urlPoster, onTap: onTap);
  }

  Widget _buildList(BuildContext context, Playlist playlist) {


    if(playlist.cinematografias == null || playlist.cinematografias.isEmpty){
      if(_detailsBloc.isOwner(playlist)) {
        return Container(
          margin: EdgeInsets.only(top: 100),
          child: CenteredMessage(
            title: "Hmmm que coisa",
            subtitle: "Parece que você ainda\nnão adicionou nada aqui :(",
            icon: Icons.warning,
          ),
        );
      }else{
        return Container(
          margin: EdgeInsets.only(top: 100),
          child: CenteredMessage(
            title: "Hmmm que coisa",
            subtitle: "Não há nada aqui ainda :(",
            icon: Icons.warning,
          ),
        );
      }
    }

    return Container(
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        staggeredTileBuilder: (_) => StaggeredTile.fit(1),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
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
    return Container(
      width: MediaQuery.of(context).size.width,

      child: Column(
        children: <Widget>[
          Text(playlist.nome, style: Theme.of(context).textTheme.title.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          )),
          SizedBox(height: 10,),
          ((playlist.privada)?_buildSecret():_buildSeguidores(playlist.qtdSeguidores)),
          SizedBox(height: 10,),
          (_detailsBloc.isOwner(playlist))?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomButton(
                padding: EdgeInsets.all(10),
                text: (playlist.privada) ? 'Publicar' : 'Privar',
                onPressed: (){},
              ),

              Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  CustomButton(
                      padding: EdgeInsets.all(10),
                      text: 'Excluir',
                      color: Colors.red,
                      onPressed: (){}
                  ),
                ],
              ),
            ],
          ): Container(),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _buildSeguidores(int qtdSeguidores) {
    return Text("$qtdSeguidores seguidores",  style: TextStyle(
        color: kWhiteColor.withAlpha(90)
    ),);
  }

  Widget _buildSecret() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.lock,
            size: 16,
            color: kWhiteColor.withAlpha(90)),
        SizedBox(width: 8,),
        Text("Playlist privada", style: TextStyle(
            color: kWhiteColor.withAlpha(90)
        ),)
      ],
    );
  }
}
