import 'package:flutter/material.dart';
import 'package:government_directory/api/news_api.dart';
import 'package:government_directory/models/data.dart';
import 'package:government_directory/models/news.dart';
import 'package:government_directory/models/news_category.dart';
import 'package:government_directory/news_page.dart';
import 'package:government_directory/views/pages/news_category.dart';

class all_news_page extends StatefulWidget {
  @override
  all_news_page_state createState() => all_news_page_state();
}

class all_news_page_state extends State<all_news_page> {
  List _news = [];
  List<news_category> cats = [
    news_category(id: '41',name: 'Top Stories'),
    news_category(id: '18',name: 'Business'),
    news_category(id: '9',name: 'World'),
    news_category(id: '5',name: 'Technology'),
    news_category(id: '6',name: 'Sports'),
    news_category(id: '11',name: 'Entertainment'),
    news_category(id: '7',name: 'South Africa'),
    news_category(id: '22',name: 'Health')
  ];

  List<news_category> categories = [new news_category(),];

  var repository = new news_api();
  _open_news_category(news_category _news_category, context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new news_category_page(category: _news_category)));
  }
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: Container(
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        title: Text('news'),
        backgroundColor: Colors.green.withOpacity(0.8),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 100.0,
              child:  DrawerHeader(
              child: Center(
                child: Text('Categories',textAlign: TextAlign.left,style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),),
              ) ,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: NetworkImage(
                //     'http://www.southdevonandtorbayccg.nhs.uk/news/PublishingImages/header-news.png'
                //   )
                // )
              ),
            ),
            ),

            ListTile(
              title: Text(_news[0].name),
              onTap: (){
                _open_news_category(_news[0],context);
              },
            ),
                        ListTile(
              title: Text(_news[1].name),onTap: (){
                _open_news_category(_news[1],context);
              },
            ),
                        ListTile(
              title: Text(_news[2].name),onTap: (){
                _open_news_category(_news[2],context);
              },
            ),
                        ListTile(
              title: Text(_news[3].name),onTap: (){
                _open_news_category(_news[3],context);
              },
            ),
                        ListTile(
              title: Text(_news[4].name),onTap: (){
                _open_news_category(_news[4],context);
              },
            ),
                        ListTile(
              title: Text(_news[5].name),onTap: (){
                _open_news_category(_news[5],context);
              },
            ),
                        ListTile(
              title: Text(_news[6].name),onTap: (){
                _open_news_category(_news[6],context);
              },
            ),
                        ListTile(
              title: Text(_news[7].name),onTap: (){
                _open_news_category(_news[7],context);
              },
            ),
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: (){
            Scaffold.of(context).openDrawer();
          },
          backgroundColor: Colors.green,
          label: Text('Categories'),
          icon: Icon(Icons.category),
        ),
      ),
      body: _news.isEmpty ? Center(child: CircularProgressIndicator(),) : body_ui(cats: cats, news_list: _news,),
    );
  }

  Widget _category_stories_list(){
  var list = new ListView.builder(
    itemCount: 8,
    itemBuilder: (context,index){
      return _news[index];
    }
  );
  return list;
}

@override
void initState(){
  super.initState();
 //oad_news_data();
// print('entered');
 load_recents();
}

load_recents() async{
  List results = await repository.get_recent().then((res){
    print('name');
    print(res);

    setState((){
      _news = res;
    });
  });
}

load_news_data() async {
  List result = await repository.loadNews();
  setState((){
    result.forEach((item){
     // var news_item = new build_category_stories(category: 'news',);
    });
  });
}



}

class body_ui extends StatelessWidget {
  List<news_category> cats;
  List news_list = [];

  //List<News> news;
  body_ui({this.cats,this.news_list});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Text(
              //         'Browse by category',
              //         style: TextStyle(
              //             fontSize: 20.0, fontWeight: FontWeight.bold),
              //       ),
              //     )
              //   ],
              // ),
              // new SizedBox(
              //   height: 10.0,
              // ),
              // Column(
              //   children: <Widget>[
              //     Row(
              //       children: <Widget>[
              //         new Expanded(
              //           child: GestureDetector(
              //               onTap: () {
              //                 // print("${categories[0].name} Taped");
              //                 //_show_companies(context, categories[0]);
              //               },
              //               child: Padding(
              //                 padding: const EdgeInsets.only(right: 5.0),
              //                 child: new Container(
              //                   height: 100.0,
              //                   decoration: new BoxDecoration(
              //                       // borderRadius: new BorderRadius.circular(5.0),
              //                       color: Color(0XFF1A2229)),
              //                   child: new Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: <Widget>[
              //                       Padding(
              //                         padding: EdgeInsets.only(
              //                             left: 9.0, right: 9.0),
              //                         child: Center(
              //                           child: new Text(cats[0].name,
              //                               style: new TextStyle(
              //                                   color: Colors.white,
              //                                   fontWeight: FontWeight.w700)),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )),
              //         ),
              //         new Expanded(
              //             child: new Container(
              //           height: 100.0,
              //           child: Column(
              //             children: <Widget>[
              //               Expanded(
              //                   child: GestureDetector(
              //                 onTap: () {
              //                   //print('${categories[13].name} Taped');
              //                   //_show_companies(context, categories[13]);
              //                 },
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(
              //                       bottom: 2.5, right: 2.5),
              //                   child: new Container(
              //                     decoration: new BoxDecoration(
              //                       color: Color(0XFF1A2229),
              //                       //borderRadius: new BorderRadius.circular(5.0)
              //                     ),
              //                     child: new Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: <Widget>[
              //                         Center(
              //                           child: Padding(
              //                             padding: EdgeInsets.only(
              //                                 left: 9.0, right: 9.0),
              //                             child: new Text(cats[1].name,
              //                                 style: new TextStyle(
              //                                     color: Colors.white,
              //                                     fontWeight: FontWeight.w700)),
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               )),
              //               Expanded(
              //                   child: GestureDetector(
              //                 onTap: () {
              //                   //print("${categories[5].name} Taped");
              //                   //_show_companies(context, categories[5]);
              //                 },
              //                 child: Padding(
              //                   padding:
              //                       const EdgeInsets.only(top: 2.5, right: 2.5),
              //                   child: new Container(
              //                       decoration: new BoxDecoration(
              //                         color: Color(0XFF1A2229),
              //                         // borderRadius: new BorderRadius.circular(5.0)
              //                       ),
              //                       child: Center(
              //                         child: Padding(
              //                           padding: EdgeInsets.only(
              //                               left: 9.0, right: 9.0),
              //                           child: new Text(cats[2].name,
              //                               style: new TextStyle(
              //                                   color: Colors.white,
              //                                   fontWeight: FontWeight.w700)),
              //                         ),
              //                       )),
              //                 ),
              //               )),
              //             ],
              //           ),
              //         )),
              //         new Expanded(
              //             child: new Container(
              //           height: 100.0,
              //           child: Column(
              //             children: <Widget>[
              //               Expanded(
              //                 child: GestureDetector(
              //                   onTap: () {
              //                     //print("${categories[6].name} Taped");
              //                     //_show_companies(context, categories[6]);
              //                   },
              //                   child: Padding(
              //                     padding: const EdgeInsets.only(
              //                         left: 2.5, bottom: 2.5),
              //                     child: new Container(
              //                       decoration: new BoxDecoration(
              //                         color: Color(0XFF1A2229),
              //                         // borderRadius: new BorderRadius.circular(5.0)
              //                       ),
              //                       child: Center(
              //                         child: Padding(
              //                           padding: EdgeInsets.only(
              //                               left: 9.0, right: 9.0),
              //                           child: new Text(cats[3].name,
              //                               style: new TextStyle(
              //                                   color: Colors.white,
              //                                   fontWeight: FontWeight.w700)),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Expanded(
              //                   child: GestureDetector(
              //                 onTap: () {
              //                   // print("${categories[12].name} Taped");
              //                   // _show_companies(context, categories[12]);
              //                 },
              //                 child: Padding(
              //                   padding:
              //                       const EdgeInsets.only(left: 2.5, top: 2.5),
              //                   child: new Container(
              //                     decoration: new BoxDecoration(
              //                       color: Color(0XFF1A2229),
              //                       //borderRadius: new BorderRadius.circular(5.0)
              //                     ),
              //                     child: Center(
              //                       child: Padding(
              //                         padding: EdgeInsets.only(
              //                             left: 9.0, right: 9.0),
              //                         child: new Text(cats[4].name,
              //                             style: new TextStyle(
              //                                 color: Colors.white,
              //                                 fontWeight: FontWeight.w700)),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               )),
              //             ],
              //           ),
              //         )),
              //       ],
              //     ),
              //     SizedBox(
              //       height: 5.0,
              //     ),
              //     Row(
              //       children: <Widget>[
              //         Expanded(
              //             child: GestureDetector(
              //           child: Padding(
              //             padding: const EdgeInsets.only(right: 5.0),
              //             child: new Container(
              //               height: 50.0,
              //               decoration: new BoxDecoration(
              //                 color: Color(0XFF1A2229),
              //                 // borderRadius: new BorderRadius.circular(5.0)
              //               ),
              //               child: Center(
              //                 child: Padding(
              //                   padding: EdgeInsets.only(left: 9.0, right: 9.0),
              //                   child: new Text(cats[5].name,
              //                       style: new TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w700)),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           onTap: () {
              //             //print("${categories[4].name} Taped");
              //             //_show_companies(context, categories[4]);
              //           },
              //         )),
              //         Expanded(
              //             child: GestureDetector(
              //           child: Padding(
              //             padding:
              //                 const EdgeInsets.only(left: 2.5, bottom: 2.5),
              //             child: new Container(
              //               height: 50.0,
              //               decoration: new BoxDecoration(
              //                 color: Color(0XFF1A2229),
              //                 //borderRadius: new BorderRadius.circular(5.0)
              //               ),
              //               child: Center(
              //                 child: Padding(
              //                   padding: EdgeInsets.only(left: 9.0, right: 9.0),
              //                   child: new Text(cats[6].name,
              //                       style: new TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w700)),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           onTap: () {
              //             // print("${categories[7].name} Taped");
              //             // _show_companies(context, categories[7]);
              //           },
              //         )),
              //         new SizedBox(
              //           width: 5.0,
              //         ),
              //         Expanded(
              //             child: GestureDetector(
              //           child: Padding(
              //             padding:
              //                 const EdgeInsets.only(left: 2.5, bottom: 2.5),
              //             child: new Container(
              //               height: 50.0,
              //               decoration: new BoxDecoration(
              //                 color: Color(0XFF1A2229),
              //                 //borderRadius: new BorderRadius.circular(5.0)
              //               ),
              //               child: Center(
              //                 child: Padding(
              //                   padding: EdgeInsets.only(left: 9.0, right: 9.0),
              //                   child: new Text(cats[7].name,
              //                       style: new TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.w700)),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           onTap: () {
              //             //print("${categories[11].name} Taped");
              //             //_show_companies(context, categories[11]);
              //           },
              //         )),
              //       ],
              //     )
              //   ],
              // ),
              build_category_stories(news: news_list[0]),
              Divider(),
              build_category_stories(news: news_list[1]),
              Divider(),
              build_category_stories(news: news_list[2]),
              Divider(),
              build_category_stories(news: news_list[3]),
              Divider(),
              build_category_stories(news: news_list[4]),
              Divider(),
              build_category_stories(news: news_list[5]),
              Divider(),
              build_category_stories(news: news_list[6]),
              Divider(),
              build_category_stories(news: news_list[7]),
              SizedBox(
                height: 70.0,
              ),
            ],
          ),
        )
      ],
    );
  }
}



//this component builds a stories based on category
class build_category_stories extends StatelessWidget {
  //String category;
  //News news;

  news_category news;

  build_category_stories({this.news});

  _open_news_(News _news, context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => new news_page(news: _news)));
  }


  @override
  Widget build(BuildContext context) {
    return Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          news.name,
                          style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          _open_news_(news.news[0],context);
                        },
                        child: Column(
                        children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 200.0,
                              decoration: BoxDecoration(color: Colors.green,
                              image: DecorationImage(
                                image: NetworkImage(
                                  news.news[0].thumbnail
                                ),
                                fit: BoxFit.fill,
                                
                              )
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              news.news[0].title,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25.0),
                            ),
                          )
                        ],
                      ),
                        ],
                      ),
                      ),
                      

                      SizedBox(
                        height: 15.0,
                      ),
                      
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                _open_news_(news.news[1],context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      decoration:
                                          BoxDecoration(color: Colors.green,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              news.news[1].thumbnail
                                            )
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                          news.news[1].title,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 20.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            ) ,
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                _open_news_(news.news[2],context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      decoration:
                                          BoxDecoration(color: Colors.green,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              news.news[2].thumbnail
                                            )
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            news.news[2].title,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 20.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            ) ,
                          )
                        ],
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          _open_news_(news.news[3],context);
                        },
                        child: Container(
                        //margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                        child: Material(
                          child: Container(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    //edit lah
                                    //margin: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          news.news[3].title,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,fontSize: 20.0),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            news.news[3].content,
                                            maxLines: 3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                // new FadeInImage.assetNetwork(
                                //     placeholder: '',
                                //     image:
                                //         news.news[3].thumbnail,
                                //     fit: BoxFit.cover,
                                //     width: 100.0,
                                //     height: 100.0),
                                                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        news.news[3].thumbnail
                                      ),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      )
                      ,
                        SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              );
  }
}
