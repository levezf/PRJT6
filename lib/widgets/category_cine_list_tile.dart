import 'package:flutter/material.dart';
import 'package:prj/models/cinematografia.dart';
import 'package:prj/pages/cine_detail.page.dart';

import 'list_horizontal.dart';
import 'poster_tile.dart';

class CategoryCineListTile extends StatelessWidget {
  final categoria;
  final List<Cinematografia> cinematografias;
  final Function onTapCine;

  CategoryCineListTile(this.categoria, this.cinematografias, {this.onTapCine});

  @override
  Widget build(BuildContext context) {
    return ListHorizontal(
      title: categoria,
      itemBuilder: (context, index) {
        return PosterTile(cinematografias.elementAt(index).urlPoster, onTap: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_)=>CineDetailPage(cinematografias.elementAt(index))
              )
          );
        });
      },
      itemCount: cinematografias.length,
    );
  }
}
