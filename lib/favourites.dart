import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget{
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Favourite Companies'.toUpperCase(),style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: 20.0,
                ),),
      ),
    );
  }
}