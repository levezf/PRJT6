import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/embreve.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/pages/cine_detail.page.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/video_widget.dart';

class EmBrevePage extends StatefulWidget {
  @override
  _EmBrevePageState createState() => _EmBrevePageState();
}

class _EmBrevePageState extends State<EmBrevePage> {
  EmBreveBloc _emBreveBloc;

  @override
  void initState() {
    _emBreveBloc = EmBreveBloc();
    _emBreveBloc.searchResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Cinematografia>>(
      stream: _emBreveBloc.outResults,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomLoading();
        }

        return Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Cinematografia cinematografia = snapshot.data.elementAt(index);

              var exibicao;
              if (cinematografia.urlVideo != null &&
                  cinematografia.urlVideo.isNotEmpty) {
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

              return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_)=>CineDetailPage(cinematografia)
                  ));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    exibicao,
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text(cinematografia.nome, textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold),),
                          ],),
                          SizedBox(
                            height: 10,
                          ),
                          Text(cinematografia.sinopse),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CustomButton(
                                text: "ADICIONAR",
                                icon: Icon(Icons.playlist_add),
                                onPressed: () {},
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        );
      },
    );
  }
}
