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

    String nome;
    String email;
    String descricao;

    if(profile!=null){
      nome = profile['fullname'];
      email = profile['email'];
      descricao =  profile['description'];
      if(profile['image']!=null && (profile['image'] as String).isNotEmpty){
        String name = profile['image'];
        imagem = 'https://cineplus.herokuapp.com/imagens/$name';
      }
    }else{
      if(json["name"]!=null) {
        nome = json["name"];
      }else{
        nome = json["fullname"];
      }
      if(json["image"] !=null && (json["image"]as String).isNotEmpty){
        String name = json['image'];
        imagem = 'https://cineplus.herokuapp.com/imagens/$name';
      }
    }

    List<Playlist> playlists = [];
    if(json["playlists"]!=null){
      List<dynamic> playlistsSalvas = json["playlists"];
      playlistsSalvas.forEach((value) {
        playlists.add(Playlist.fromJson(value));
      });
    }

    List<Usuario> seguidores = [];
    if(json["followers"]!=null){
      List<dynamic> followers = json["followers"];
      followers.forEach((value) {
        if(value["userdId"]!=null){
          value["id"] = value["userId"];
        }
        if(value["fullname"]!=null){
          value["name"] = value["fullname"];
        }
        seguidores.add(Usuario.fromJson(value));
      });
    }

    List<Usuario> seguindo = [];
    if(json["following"]!=null){
      List<dynamic> following = json["following"];
      following.forEach((value) {
        if(value["userdId"]!=null){
          value["id"] = value["userId"];
        }
        if(value["fullname"]!=null){
          value["name"] = value["fullname"];
        }

        seguindo.add(Usuario.fromJson(value));
      });
    }

    return Usuario(
      id: json["user"]!=null ? json["user"]["id"] : json['id'],
      nome: nome,
      email:email,
      descricao:descricao,
      avatar: imagem,
      seguindo: seguindo,
      seguidores: seguidores,
      playlistsSalvas: playlists,
    );
  }

}