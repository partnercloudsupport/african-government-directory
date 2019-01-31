import 'package:flutter/material.dart';
import 'package:government_directory/api/news_api.dart';
import 'package:government_directory/models/news.dart';
import 'package:government_directory/models/news_category.dart';
import 'package:government_directory/news_page.dart';

class news_category_page extends StatefulWidget{
  news_category category;

  news_category_page({this.category});
@override
news_category_page_state createState() => new news_category_page_state(category:category);
}

class news_category_page_state extends State<news_category_page>{
  news_category category;
  var repository = new news_api();

  List news = [];
  
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
      body: news.isEmpty ? Center(child: CircularProgressIndicator(),) : news_list_tile(news: news),
    );
  }
}

class news_list_tile extends  StatelessWidget{
  List<News> news = [];

  news_list_tile({this.news});

  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, position){
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  _show_news(context,news[position]);
                },
                child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.network(_render_news_image(news[position].thumbnail), height: 60,),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [TextSpan(text: news[position].title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.black)),]
                                        ),overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Text(news[position].content,style: TextStyle(fontSize: 15.0),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  String _render_news_image(String image_url){
        bool _empty = false;

    try{
      if(image_url.isEmpty || image_url == null){
        _empty = true;
      }
    }catch(ex){
      _empty = true;
      print('displaying company image failed');
    }

    if(_empty){
      return 'https://www.labx.com/images/image-not-found.png';
    }else{
      return image_url;
    }
  }

  void _show_news(BuildContext context, News news) async{
    Map result = await Navigator.push(context, MaterialPageRoute(builder: (context) => news_page(news: news)));
  }
}