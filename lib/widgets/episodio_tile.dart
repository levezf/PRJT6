

import 'package:flutter/material.dart';
import 'package:prj/models/episodio.dart';

class EpisodioTile extends StatelessWidget {

  final Episodio episodio;
  EpisodioTile(this.episodio);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              episodio.nome,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: Text(
              episodio.sinopse
            ),
          )
        ],
      ),
    );
  }
}
