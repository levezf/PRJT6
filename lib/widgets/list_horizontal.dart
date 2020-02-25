import 'package:flutter/material.dart';

class ListHorizontal extends StatelessWidget {
  final title;
  final Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final double size;

  ListHorizontal({
    @required this.title, 
    @required this.itemBuilder, 
    @required this.itemCount,
    this.size=-1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: size>0 ? size : 150,
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            // itemBuilder: (context, index) {
            //   return PosterTile(cinematografias.elementAt(index).urlImage);
            // },
            separatorBuilder: (context, index) {
              return SizedBox(width: 5,);
            },
          ),
        ),
      ],
    );
  }
}
