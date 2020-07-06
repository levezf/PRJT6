import 'package:prj/models/genero.dart';
import 'package:prj/models/playlist.dart';
import 'package:prj/models/searchable.dart';

class Usuario implements Searchable{
  String nome;
  String email;
  String avatar;
  String descricao;
  List<Playlist> playlistsSalvas;
  List<Usuario> seguidores;
  List<Usuario> seguindo;
  int id;

  Usuario({this.descricao, this.email, this.nome, this.avatar, this.playlistsSalvas, this.id, this.seguidores, this.seguindo});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Usuario &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Usuario.fromJson(Map<String, dynamic> json) {

    String imagem = 'https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-homem-no-icone-redondo_24640-14044.jpg';
    final profile = json['profile'];

    if(profile['image']!=null && (profile['image'] as String).isNotEmpty){
      String name = profile['image'];
      imagem = 'https://cineplus.herokuapp.com/imagens/$name';
    }

    return Usuario(
      id: json['id'],
      nome: profile['fullname'],
      email: profile['email'],
      descricao: profile['description'],
      avatar: imagem,
      seguindo: /*json['following']*/[],
      seguidores: /*json['followers']*/ [],
      playlistsSalvas: /*json['playlists']*/ [],
    );
  }

}