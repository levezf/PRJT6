
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterTile extends StatelessWidget {

  final urlImage;

  PosterTile(this.urlImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)), 
      child: CachedNetworkImage(imageUrl: urlImage,),  
    );
  }
}