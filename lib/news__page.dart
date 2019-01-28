import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:government_directory/models/news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class news_page extends StatefulWidget{
  News news;
  news_page({this.news});
  
  @override
  news_page_state createState() => news_page_state(news: news);
}

class news_page_state extends State<news_page>{
News news;
news_page_state({this.news});
@override
void initState(){
  super.initState();
}

@override
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green,
      title: Text(news.title.toLowerCase()),
    ),
    body: new Container(
      margin: EdgeInsets.all(10.0),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(6.0),
        child: ListView(
          children: <Widget>[
            Hero(
              tag: news.title,
              child: _getImageNetwork(news.image),
            ),
            _getbody(),
            
          ],
        ),
      ),
    ),
  );
}

Widget _getImageNetwork(url){

    try{
      if(url != '') {

        return ClipRRect(
          borderRadius: new BorderRadius.only(topLeft: Radius.circular(6.0),topRight: Radius.circular(6.0)),
          child: new Container(
            height: 200.0,
            child: new FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.png',
              image: url,
              fit: BoxFit.cover,),
          ),
        );
      }else{
        return new Container(
          height: 200.0,
          child: new Image.asset('assets/placeholder.png'),
        );
      }

    }catch(e){
      return new Container(
        height: 200.0,
        child: new Image.asset('assets/placeholder.png'),
      );
    }

  }

  Widget _getbody(){
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTittle(),
          _getDate(),
          _getDescription(),
          _getAntLink(),
          _getLink(context)
        ],
      ),
    );
  }

  _getTittle(){
    return Text(
      news.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
    );
  }
   _getDate() {
    return new Container(
      margin: new EdgeInsets.only(top: 4.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(news.date,
            style: new TextStyle(
                fontSize: 10.0,
                color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }

   _getDescription() {
    return new Container(
      margin: new  EdgeInsets.only(top: 20.0),
      child: new Text(news.content),
    );
  }

    Widget _getAntLink() {
    return new Container(
      margin: new EdgeInsets.only(top: 30.0),
      child: new Text("More Details:",
        style: new TextStyle(fontWeight: FontWeight.bold,
            color: Colors.grey[600]
        ),
      ),
    );
  }
  Widget _getLink(context){

    return new GestureDetector(
      child: new Text(
        news.link,
        style: new TextStyle(color: Colors.blue),
      ),
      onTap: (){
        _launchURL(news.link,context);
      },
    );

  }

  _launchURL(url,context) async {
    //if(Platform.isAndroid) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
    //}else{
      //Clipboard.setData(new ClipboardData(text: url));
      //_showDialog(context);
    //}
  }

   Future shareNotice() async {
    await Share.share(""+news.title + ":\n"+news.link);
  }

    void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("${news.link}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("copy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



class Functions{

  static String getImgResizeUrl(String url,height,width){
    return 'http://104.131.18.84/notice/tim.php?src=$url&h=$height&w=$width';
  }

}