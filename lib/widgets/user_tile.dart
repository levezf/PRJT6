import 'package:flutter/material.dart';
import 'package:prj/models/usuario.dart';

class UserTile extends StatelessWidget {
  
  final Usuario user;

  final double size;

  UserTile(this.user,{this.size=50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(  shape: BoxShape.circle,
        border: Border.all(color:Colors.yellowAccent)
      ),
      
      child: CircleAvatar(
        backgroundImage: NetworkImage(user.avatar),
      ),
    );
  }
}