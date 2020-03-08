
import 'package:prj/colors.dart';
import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {

  static const _TAG = "CustomSearchTag";

  final String hint;
  final Function onTap;
  final Function(String) onSubmit;
  final Function(String) onChanged;
  final bool popBackStack;

  CustomSearch({this.hint, this.onTap, this.onSubmit, this.onChanged,  this.popBackStack = false});

  final Widget _searchIcon = Icon(Icons.search, color: kBlackColor,);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _TAG,
      child: Card(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: onTap==null,
              onSubmitted: onSubmit,
              onChanged: onChanged,
              enabled: onTap==null,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  icon: (
                      (popBackStack) ? _buildPopBackStack(context) : _searchIcon
                  ),
                  border: InputBorder.none,
                  hintText: this.hint,
                  hintStyle: TextStyle(
                      color: Colors.black
                  )),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPopBackStack(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: kBlackColor,),
    );
  }
}