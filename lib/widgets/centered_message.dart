import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;

  CenteredMessage({this.icon, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 70,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
