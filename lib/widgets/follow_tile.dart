

import 'package:flutter/material.dart';
import 'package:prj/models/usuario.dart';

class FollowTile extends StatelessWidget {


  final Usuario _follow;
  final bool _estaSeguindo;
  final Function _onActionPressed;
  final Function _onDetailsPressed;
  FollowTile(this._follow, this._estaSeguindo, this._onActionPressed, this._onDetailsPressed);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onDetailsPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          children: <Widget>[
            Container(
              width: 56,
                height: 56,
                child: _buildCircle(context)),
            SizedBox(
              width: 16,
            ),
            Expanded(child: Text(_follow.nome,
            style: Theme.of(context).textTheme.title,maxLines: 2, overflow: TextOverflow.ellipsis,)),
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(
                  _estaSeguindo ? Icons.remove_circle_outline : Icons.add_circle_outline
              ),
              onPressed: _onActionPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(BuildContext context) {
    if(_follow.avatar!=null){
      return CircleAvatar(
        radius: 75,
        backgroundImage: NetworkImage(_follow.avatar),
      );
    }
    return CircleAvatar(
      radius: 75,
      child: Text(_follow.nome.substring(0,2)),
    );
  }
}
