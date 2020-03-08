import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate{

@override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return  Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    return  Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}