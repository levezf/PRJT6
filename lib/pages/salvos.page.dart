import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:prj/blocs/usuario.bloc.dart';
import 'package:prj/enums/operation.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/widgets/centered_message.dart';
import 'package:prj/widgets/custom_button.dart';
import 'package:prj/widgets/custom_loading.dart';
import 'package:prj/widgets/input_field.dart';
import 'package:prj/widgets/playlist_tile.dart';

class SalvosPage extends StatefulWidget {
  @override
  _SalvosPageState createState() => _SalvosPageState();
}

class _SalvosPageState extends State<SalvosPage> {


  @override
  void didChangeDependencies() {
    UsuarioBloc bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.doLogin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addListBottomSheet(context);
        },
      ),
      body: StreamBuilder<List<Playlist>>(
        stream: BlocProvider.getBloc<UsuarioBloc>().outSalvos,
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomLoading();
          }

          if(snapshot.data.isEmpty){
            return CenteredMessage(
                icon: Icons.error_outline,
                title: "Que pena :(",
                subtitle: "Você não tem nenhuma lista ainda !"
            );
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

  void _addListBottomSheet(BuildContext context) {

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext bc){
          Playlist newPlaylist = Playlist();
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
                      Text(
                        'Adicionar',
                        style: Theme.of(context).textTheme.title,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Crie uma nova lista',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputField(
                        onChanged: BlocProvider.getBloc<UsuarioBloc>().changeNomeLista,
                        multiline: false,
                        stream: BlocProvider.getBloc<UsuarioBloc>().outNomeNewLista,
                        hint: "Nome da lista",
                      ),

                      StreamBuilder<bool>(
                        initialData: false,
                        stream: BlocProvider.getBloc<UsuarioBloc>().outIsListaPrivada,
                        builder: (context, snapshot) {
                          return SwitchListTile(
                            title: Text("Privada"),
                            value: snapshot.hasData && snapshot.data,
                            onChanged: BlocProvider.getBloc<UsuarioBloc>().changeIsListaPrivada,
                          );
                        },
                      ),

                     /* Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          StreamBuilder<bool>(
                            stream: BlocProvider.getBloc<UsuarioBloc>().outIsListaPrivada,
                            builder: (context, snapshot) {
                              return SwitchListTile(
                                title: Text("Privada"),
                                value: snapshot.hasData && snapshot.data,
                                onChanged: BlocProvider.getBloc<UsuarioBloc>().changeIsListaPrivada,
                              );
                            },
                          ),
                        ],
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder<String>(
                              stream: BlocProvider.getBloc<UsuarioBloc>().outNomeNewLista,
                              builder: (context, snapshot) {
                                return CustomButton(
                                    icon:Icon(Icons.add),
                                    text: 'ADICIONAR',
                                    onPressed: snapshot.hasData && snapshot.data.length > 3  ? (){
                                      _addPlaylist(newPlaylist);
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

  void _addPlaylist(Playlist newPlaylist){
    BlocProvider.getBloc<UsuarioBloc>().updateSalvos(newPlaylist, Operation.Add);
    Navigator.pop(context);
  }
}
