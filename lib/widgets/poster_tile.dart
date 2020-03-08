
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterTile extends StatelessWidget {

  final urlImage;
  final onTap;

  PosterTile(this.urlImage, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
        child: CachedNetworkImage(imageUrl: urlImage,),
      ),
    );
  }
}