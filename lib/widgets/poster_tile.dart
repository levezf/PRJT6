
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterTile extends StatelessWidget {

  final urlImage;
  final onTap;
  final Function callback;

  PosterTile(this.urlImage, {this.onTap, this.callback});

  @override
  Widget build(BuildContext context) {

    return Stack(
        children: <Widget>[
          InkWell(
            onTap: onTap,
            child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
              child: CachedNetworkImage(imageUrl: urlImage,),
            ),
          ),
          Positioned(
            right: 0,
            child: Visibility(
              visible: callback!=null,
              child: IconButton(
                onPressed: callback,
                icon: Icon(Icons.close),
              ),
            ),
          )
        ],
      );
  }
}