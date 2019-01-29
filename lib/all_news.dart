import 'package:flutter/material.dart';
import 'package:government_directory/models/news.dart';
import 'package:http/http.dart' as http;
import  'dart:convert';

class all_news_page extends StatefulWidget{

@override
all_news_page_state createState() => all_news_page_state();
}

class all_news_page_state extends State<all_news_page>{
  List<News> _news = [];

  @override
  void initState() {
    super.initState();

  }

@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: Text('More news'),
      backgroundColor: Colors.green,
    ),
    body: new  NoticeList(),
  );
}

}

class body_ui extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return Material(
      borderRadius: BorderRadius.circular(6.0),
      elevation: 2.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInImage.assetNetwork(
            placeholder: '',
            image: '',
            fit: BoxFit.cover,
            width: 95.0,
            height: 95.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('title'),
              Text('date'),
              Text('description')
            ],
          )
        ],
      ),
    );
  }
}

class  Notice  extends  StatelessWidget {

  var _img;
  var _title;
  var _date;
  var _description;

  Notice ( this ._img, this ._title, this ._date, this ._description);

  BuildContext _context;

  @override
  Widget  build ( BuildContext context) {
    this ._context = context;

    // Added within Container to add margin to item
    return  new  Container (
      margin :  const  EdgeInsets . only (left :  10.0 , right :  10.0 , bottom :  10.0 , top :  0.0 ),
      child :  new  Material (
        borderRadius :  new  BorderRadius . circular ( 6.0 ),
        elevation :  2.0 ,
        child :  _getListTile (),
      ),
    );
  }

  Widget  _getListTile () {

    // Added within Container to add fixed height.
    return  new  Container (
      height :  95.0 ,
      child :  new  Row (
        crossAxisAlignment :  CrossAxisAlignment .start,
        children :  < Widget > [
          new  FadeInImage . assetNetwork (placeholder :  '' , image : _img, fit :  BoxFit .cover, width :  95.0 , height :  95.0 ),
          _getColumText (_title, _date, _description),
      ],

    ),
    );

  }

  Widget  _getColumText (tittle, date, description) {

    return  new  Expanded (
        child :  new  Container (
          margin :  new  EdgeInsets . all ( 10.0 ),
          child :  new  Column (
            crossAxisAlignment : CrossAxisAlignment .start,
            children :  < Widget > [
              _getTitleWidget (_title),
              _getDateWidget (_date),
              _getDescriptionWidget (_description)],
          ),
        )
    );
  }

  Widget  _getTitleWidget ( String curencyName) {
    return  new  Text (
      curencyName,
      maxLines :  1 ,
      style :  new  TextStyle (fontWeight :  FontWeight .bold),
    );
  }

  Widget  _getDescriptionWidget ( String description) {
    return  new  Container (
      margin :  new  EdgeInsets . only (top :  5.0 ),
      child :  new  Text (description, maxLines :  2 ,),
    );
  }

  Widget  _getDateWidget ( String date) {
    return  new  Text (date,
      style :  new  TextStyle (color :  Colors .grey, fontSize :  10.0 ),);
  }

}

class  NoticeList  extends  StatefulWidget {

  final state =  new  _NoticeListPageState ();

  @override
  _NoticeListPageState  createState () => state;

}

class  _NoticeListPageState  extends  State < NoticeList > {
  
  List _news =  new  List ();
  var repository =  new  NewsApi ();
  
  @override
  Widget  build ( BuildContext context) {

    return  new  Scaffold (
      appBar :  new  AppBar (),
      body :  new  Container (
        child :  _getListViewWidget (),
      ),
    );

  }

    @override
  void  initState() {
    loadNotices ();
  }

  loadNotices() async {
    List result =  await repository.loadNews();
    
    setState(() {
      result.forEach((item) {
        var notice =  new  Notice (
          item ['thumbnail'],
          item ['title'],
          item ['date'],
          item ['content']
        );
        _news.add(notice);

      });

    });

  }
  
  Widget  _getListViewWidget () {

    var list =  new  ListView.builder (
        itemCount : _news.length,
        padding :  new  EdgeInsets . only (top :  5.0 ),
        itemBuilder : (context, index) {
          return _news [index];
        }
    );

    return list;

  }
  
}

class NewsApi{
  Future <List> loadNews () async {
    final response = await http.get('https://government.co.za/api/news');
      return jsonDecode(response.body);
  }
}