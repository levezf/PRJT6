import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/blocs/usuario_detail.bloc.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/playlist_detail.page.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/poster_tile.dart';

import '../colors.dart';

class UsuarioDetailPage extends StatefulWidget {
  final Usuario _usuario;
  UsuarioDetailPage(this._usuario);

  @override
  _UsuarioDetailPageState createState() => _UsuarioDetailPageState();
}

class _UsuarioDetailPageState extends State<UsuarioDetailPage> {
  UsuarioDetailBloc _detailsBloc;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _detailsBloc = UsuarioDetailBloc(widget._usuario);
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
      body: StreamBuilder<Usuario>(
          stream: _detailsBloc.outUsuario,
          initialData: null,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomLoading();
            }

            if (snapshot.hasError) {
              return CenteredMessage(
                  icon: Icons.error_outline,
                  title: "Nenhum resultado encontado",
                  subtitle: snapshot.error);
            }

            return SingleChildScrollView(
              child: Padding(
                child: Column(
                  children: <Widget>[
                    _buildHeader(context, snapshot.data),
                    _buildList(context, snapshot.data),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            );
          }),
    );
  }

  Widget _buildHeader(BuildContext context, Usuario usuario) {
    bool seguindo = BlocProvider.getBloc<UsuarioBloc>().estaSeguindo(usuario);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(usuario.avatar),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(usuario.nome,
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
          SizedBox(
            height: 10,
          ),
          /*Text(
            usuario.generosFavoritos.map((genero)=>genero.nome).join(" | "),
            style: TextStyle(color: kWhiteColor.withAlpha(90)),
          ),*/
          SizedBox(
            height: 10,
          ),
          Text(
            "${usuario.seguidores.length.toStringAsFixed(0)} seguidores | ${usuario.seguindo.length.toStringAsFixed(0)} seguindo",
            style: TextStyle(color: kWhiteColor.withAlpha(90), fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomButton(
                padding: EdgeInsets.all(10),
                text: (seguindo) ? 'Seguindo' : 'Seguir',
                onPressed: () async {
                  bool result;
                  if(!seguindo){
                    result = await BlocProvider.getBloc<UsuarioBloc>().seguir(usuario);
                  }else{
                    result = await BlocProvider.getBloc<UsuarioBloc>().pararDeSeguir(usuario);
                  }
                  if(result!=null){
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text(result
                              ? (seguindo ? "Você parou de seguir" : "Você começou a seguir")
                              : (seguindo ? "Falha ao parar de seguir" : "Falha ao seguir")),
                        ));
                    _detailsBloc.refresh();
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, Usuario usuario) {

    if(usuario.playlistsSalvas==null || usuario.playlistsSalvas.isEmpty){
      return Container(
        margin: EdgeInsets.only(top: 100),
        child: CenteredMessage(
          icon: Icons.error_outline,
          title: "Oops",
          subtitle: "Nenhuma playlist encontrada!",
        ),
      );
    }

    return Container(
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        staggeredTileBuilder: (_) => StaggeredTile.fit(1),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        itemCount: usuario.playlistsSalvas.length,
        itemBuilder: (context, index) {
          Playlist playlist = usuario.playlistsSalvas.elementAt(index);
          return InkWell(
            onTap: (){
              final result = Navigator.of(context).push(MaterialPageRoute(
                builder: (_)=>PlaylistDetailPage(playlist)
              ));

              if(result!=null && result is String) {
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text(result as String),
                    ));
              }

            },
            child: Stack(
              children: <Widget>[
                PosterTile(playlist.poster),
                Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Container(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          (playlist.qtdFilmes + playlist.qtdSeries)
                              .toStringAsFixed(0),
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text(
                          playlist.nome,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    color: Colors.black.withAlpha(95),
                  ),
                ),
              ],
            ),
          );
        },
        crossAxisCount: 2,
      ),
    );
  }
}
