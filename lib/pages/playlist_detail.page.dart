
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
import 'package:prj/widgets/input_field.dart';
import 'package:prj/widgets/poster_tile.dart';

class PlaylistDetailPage extends StatefulWidget {

  Playlist _playlist;

  PlaylistDetailPage(this._playlist);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {

  PlaylistDetailsBloc _detailsBloc;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
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
                  title: "No results found",
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

    Function callback = ()async{
      await _detailsBloc.deletaItemPlaylist(searchable, widget._playlist);
      _detailsBloc.search(widget._playlist);
    };
    return  PosterTile(searchable.urlPoster, onTap: onTap, callback: (_detailsBloc.isOwner(widget._playlist) ? callback : null));
  }

  Widget _buildList(BuildContext context, Playlist playlist) {


    if(playlist.cinematografias == null || playlist.cinematografias.isEmpty){
      if(_detailsBloc.isOwner(playlist)) {
        return Container(
          margin: EdgeInsets.only(top: 100),
          child: CenteredMessage(
            title: "Hmmm",
            subtitle: "It looks like you haven't added anything here yet :(",
            icon: Icons.warning,
          ),
        );
      }else{
        return Container(
          margin: EdgeInsets.only(top: 100),
          child: CenteredMessage(
            title: "Hmmm",
            subtitle: "There is nothing here yet :(",
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

    Widget nomeWidget = Text(playlist.nome, style: Theme.of(context).textTheme.title.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ), textAlign: TextAlign.center,);

    if(_detailsBloc.isOwner(playlist)){
      nomeWidget =  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: ()async{
                final result = await showModalChangeData("New name",
                        (text)async{
                      return await _detailsBloc.saveNewNome( widget._playlist);
                    }
                );
                if(result!=null){
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(result ? "Name updated successfully!" : "Failed to change the name!"),
                      ));
                }
              },
              child: nomeWidget
            ),
          ),
        ],
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,

      child: Column(
        children: <Widget>[
          nomeWidget,
          SizedBox(height: 10,),
          ((playlist.privada)?_buildSecret():_buildSeguidores(playlist.qtdSeguidores)),
          SizedBox(height: 10,),
          _buildQtd(),
          SizedBox(height: 10,),
          (_detailsBloc.isOwner(playlist))?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomButton(
                padding: EdgeInsets.all(10),
                text: (playlist.privada) ? 'Publish' : 'Private',
                onPressed: ()async{
                 await  _detailsBloc.changeVisibility(playlist);
                },
              ),

              Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  CustomButton(
                      padding: EdgeInsets.all(10),
                      text: 'Delete',
                      color: Colors.red,
                      onPressed: ()async{
                        final result = await _detailsBloc.deletaPLaylist(playlist);
                        if(result){
                          Navigator.pop(context, "Successfully removed!");
                        }
                      }
                  ),
                ],
              ),
            ],
          ): Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CustomButton(
                    padding: EdgeInsets.all(10),
                    text: (_detailsBloc.estaSeguindo(playlist)) ? 'Following' : 'Follow',
                    onPressed: () async {
                      await _detailsBloc.changeFollow(playlist);
                    }
                ),
              ]),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget _buildSeguidores(int qtdSeguidores) {
    return Text("$qtdSeguidores Followers",  style: TextStyle(
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
        Text("Private", style: TextStyle(
            color: kWhiteColor.withAlpha(90)
        ),)
      ],
    );
  }
  Widget _buildQtd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("${widget._playlist.qtdFilmes.toString()} Movies | ${widget._playlist.qtdSeries.toString()} TV Series", style: TextStyle(
            color: kWhiteColor.withAlpha(90)
        ),)
      ],
    );
  }


  Future<bool> showModalChangeData(String hint, Future<bool> Function(String) onSave, {bool obscure=false}) async {
    _detailsBloc.changeNome(null);
    return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext bc){
          return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(bc).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InputField(
                        obscure: obscure,
                        onChanged:_detailsBloc.changeNome,
                        multiline: false,
                        stream: _detailsBloc.outNome,
                        hint: hint,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder<String>(
                              stream: _detailsBloc.outNome,
                              builder: (context, snapshot) {
                                return CustomButton(
                                    icon:Icon(Icons.add),
                                    text: 'SAVE',
                                    onPressed: snapshot.hasData && snapshot.data.length >= 3  ? () async {
                                      final result = await onSave(snapshot.data);
                                      Navigator.pop(context, result);
                                    }: null);
                              }
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
          );
        }
    );
  }
}
