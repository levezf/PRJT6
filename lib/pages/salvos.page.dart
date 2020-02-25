import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/playlist_tile.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class SalvosPage extends StatefulWidget {
  @override
  _SalvosPageState createState() => _SalvosPageState();
}

class _SalvosPageState extends State<SalvosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: StreamBuilder<List<Playlist>>(
        stream: BlocProvider.getBloc<UsuarioBloc>().outSalvos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomLoading();
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              return PlaylistTile(snapshot.data.elementAt(index));
            },
            itemCount: snapshot.data?.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }
}
