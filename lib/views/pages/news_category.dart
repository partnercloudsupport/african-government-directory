import 'package:flutter/material.dart';
import 'package:government_directory/api/news_api.dart';
import 'package:government_directory/models/news_category.dart';

class news_category_page extends StatefulWidget{
  news_category category;

  news_category_page({this.category});
@override
news_category_page_state createState() => new news_category_page_state(category:category);
}

class news_category_page_state extends State<news_category_page>{
  news_category category;
  var repository = new news_api();
  
  news_category_page_state({this.category});

  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.green,
      ),
    );
  }
}