import 'package:flutter/material.dart';
import 'package:prj/models/cinematografia.dart';

import 'list_horizontal.dart';
import 'poster_tile.dart';

class CategoryCineListTile extends StatelessWidget {
  final categoria;
  final List<Cinematografia> cinematografias;

  CategoryCineListTile(this.categoria, this.cinematografias);

  @override
  Widget build(BuildContext context) {
    return ListHorizontal(
      title: categoria,
      itemBuilder: (context, index) {
        return PosterTile(cinematografias.elementAt(index).urlPoster);
      },
      itemCount: cinematografias.length,
    );
  }
}
