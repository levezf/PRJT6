import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prj/blocs/cine_details.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/episodio.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/temporada.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/episodio_tile.dart';
import 'package:prj/widgets/video_widget.dart';

import 'bottomsheetsalvos.dart';

class CineDetailPage extends StatefulWidget {
  final Cinematografia _cine;
  CineDetailPage(this._cine);

  @override
  _CineDetailPageState createState() => _CineDetailPageState();
}

class _CineDetailPageState extends State<CineDetailPage> {
  CineDetailsBloc _detailsBloc;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _detailsBloc = CineDetailsBloc();
    _detailsBloc.search(widget._cine);
    super.initState();
  }

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
      body: StreamBuilder<Cinematografia>(
          stream: _detailsBloc.outCine,
          initialData: null,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomLoading();
            }

            if (snapshot.hasError) {
              return CenteredMessage(
                  icon: Icons.error_outline,
                  title: "No results found",
                  subtitle: snapshot.error);
            }

            return SingleChildScrollView(
              child: _buildHeader(context, snapshot.data),
            );
          }),
    );
  }

  Widget _buildHeader(BuildContext context, Cinematografia cinematografia) {
    var exibicao;
    if (cinematografia.urlVideo != null && cinematografia.urlVideo.isNotEmpty) {
      exibicao = VideoWidget(
        videoUrl: cinematografia.urlVideo,
        autoStart: false,
      );
    } else if (cinematografia.urlBackdrop != null &&
        cinematografia.urlBackdrop.isNotEmpty) {
      exibicao = Container(
        child: CachedNetworkImage(
          fit: BoxFit.fitWidth,
          imageUrl: cinematografia.urlBackdrop,
        ),
      );
    } else {
      exibicao = Container();
    }

    Widget cardTemporadas = Container();
    if (cinematografia is Serie) {
      if (cinematografia.temporadas != null &&
          cinematografia.temporadas.length > 0) {
        cardTemporadas = _buildCardTemporadas(context, cinematografia);
      } else {
        cardTemporadas = _buildCardTemporadasNotFound(context, cinematografia);
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
          children: <Widget>[
        Card(
          clipBehavior: Clip.hardEdge,
          child: Container(
            child: exibicao,
          ),
        ),
        Card(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text(
                    cinematografia.nome,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    cinematografia.sinopse,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      cinematografia.generos
                          .map((genero) => genero.nome)
                          .join(" | "),
                      softWrap: true,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
//                    Text('Lançamento: ${cinematografia.dataLancamento}'),
                    CustomButton(
                      text: "ADD",
                      icon: Icon(Icons.playlist_add),
                      onPressed: () async {
                        final result = await showModalBottomSheet<bool>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            context: context, builder: (bc){
                          return BottomSheetSalvos(cinematografia);
                        });
                        if(result!=null) {
                          String texto = (result is String) ? result : (
                              result
                                  ? "Added successfully!"
                                  : "Item already added"
                          );

                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(texto),
                              ));
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        cardTemporadas,
      ]),
    );
  }

  Widget _buildCardTemporadas(BuildContext context, Serie cinematografia) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                StreamBuilder<Temporada>(
                  stream: _detailsBloc.outTemporada,
                  builder: (context, snapshot) {
                    return DropdownButton<Temporada>(
                      items: cinematografia.temporadas.map((Temporada value) {
                        return new DropdownMenuItem<Temporada>(
                          value: value,
                          child: new Text(value.nome),
                        );
                      }).toList(),
                      value: snapshot.data,
                      onChanged: (value) {
                        _detailsBloc.changeTemporada(value);
                      },
                    );
                  },
                ),
              ],
            ),
            StreamBuilder<List<Episodio>>(
              stream: _detailsBloc.outEpisodios,
              builder: (context, snapshot) {

                if(!snapshot.hasData || snapshot.data.isEmpty){
                  return CenteredMessage(
                    icon: Icons.error_outline,
                    title: "Empty season",
                    subtitle: "This season has no episodes registered",
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return EpisodioTile(snapshot.data.elementAt(index));
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTemporadasNotFound(
      BuildContext context, Serie cinematografia) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: CenteredMessage(
          icon: Icons.error_outline,
            subtitle: "Release: ${cinematografia.dataLancamento}",
          title: "Seasons not found",
        )
      ),
    );
  }
}
