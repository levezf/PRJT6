
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prj/blocs/genero.bloc.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/models/genero.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/poster_tile.dart';

import '../colors.dart';

class GeneroPage extends StatefulWidget {

  final Genero genero;

  GeneroPage(this.genero);

  @override
  _GeneroPageState createState() => _GeneroPageState();
}

class _GeneroPageState extends State<GeneroPage> {

  GeneroBloc _generoBloc;

  @override
  void initState() {
    _generoBloc = GeneroBloc(widget.genero);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.genero.nome),
        leading: CloseButton(),
      ),

      body: StreamBuilder<List<Cinematografia>>(
          stream: _generoBloc.outCines,
          initialData: null,
          builder: (context, snapshot) {

            if(!snapshot.hasData){
              return CustomLoading();
            }

            if(snapshot.data.isEmpty){
              return CenteredMessage(
                  icon: Icons.error_outline,
                  title: "Nenhum resultado encontado",
                  subtitle: "Não foi possível encontrar nenhum resultado\npara o genero ${widget.genero.nome}"
              );
            }

            return Container(
              child: StaggeredGridView.countBuilder(
                staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Cinematografia cine = snapshot.data.elementAt(index);
                  return _buildCinematografia(context, cine);
                },
                crossAxisCount: 2,
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
}
