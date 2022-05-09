import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildappBar(BuildContext context){
  // final icon=CupertinoIcons.moon_stars;
  return AppBar(
    leading: BackButton(),
    elevation: 0,
    backgroundColor: Colors.blue,
    // actions: [
    //   IconButton(onPressed: () {}, icon: Icon(icon),)
    // ],
  );
}