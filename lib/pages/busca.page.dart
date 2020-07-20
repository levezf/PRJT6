import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/search.bloc.dart';
import 'package:prj/colors.dart';
import 'package:prj/delegates/custom_search.delegate.dart';
import 'package:prj/enums/screen_state.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';
import 'package:prj/models/serie.dart';
import 'package:prj/models/usuario.dart';
import 'package:prj/pages/busca_query.page.dart';
import 'package:prj/pages/lista.page.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/custom_search.dart';
import 'package:prj/widgets/poster_tile.dart';
import 'package:prj/widgets/user_tile.dart';
import 'package:prj/widgets/video_widget.dart';

import 'genero.page.dart';

class BuscaPage extends StatefulWidget {
  @override
  _BuscaPageState createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  SearchBloc _searchBloc;

  static const double HEIGHT_ITEM = 100;

  @override
  void initState() {
    _searchBloc = BlocProvider.getBloc<SearchBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<List<Genero>>(
            initialData: null,
            stream: _searchBloc.outGeneros,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                    child: CustomLoading());
              }
              
              return Column(
                children: <Widget>[

                  SizedBox(height: MediaQuery.of(context).size.height/4,),
                  Text(
                    "Buscar",
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 60,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 16,),

                  CustomSearch(
                    hint: 'Pesquise aqui...',
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BuscaQueryPage()));
                    }
                  ),
                  StaggeredGridView.countBuilder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 6.0,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Genero genero= snapshot.data.elementAt(index);
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        color: kAccentColor,
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_)=>GeneroPage(genero)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            height: 110,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  genero.nome,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    crossAxisCount: 2,
                  ),
                ],
              );
            },
          ),
        ),
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



  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

}
