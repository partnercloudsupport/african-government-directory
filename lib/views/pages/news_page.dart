import 'package:flutter/material.dart';
import 'package:government_directory/api/news_api.dart';
import 'package:government_directory/models/news.dart';

class all_news_page extends StatefulWidget {
  @override
  all_news_page_state createState() => all_news_page_state();
}

class all_news_page_state extends State<all_news_page> {
  List _news = new List();
  var repository = new news_api();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('news'),
        backgroundColor: Colors.green.withOpacity(0.8),
      ),
      body: body_ui(),
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
 // load_news();
}

load_news() async {
  List result = await repository.loadNews();

  setState((){
    result.forEach((item){
     // var news_item = new build_category_stories(category: 'news',);
    });
  });
}



}

class body_ui extends StatelessWidget {
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Browse by category',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              new SizedBox(
                height: 10.0,
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Expanded(
                        child: GestureDetector(
                            onTap: () {
                              // print("${categories[0].name} Taped");
                              //_show_companies(context, categories[0]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: new Container(
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    // borderRadius: new BorderRadius.circular(5.0),
                                    color: Color(0XFF1A2229)),
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 9.0, right: 9.0),
                                      child: Center(
                                        child: new Text("1",
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                      new Expanded(
                          child: new Container(
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                //print('${categories[13].name} Taped');
                                //_show_companies(context, categories[13]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 2.5, right: 2.5),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    color: Color(0XFF1A2229),
                                    //borderRadius: new BorderRadius.circular(5.0)
                                  ),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 9.0, right: 9.0),
                                          child: new Text('2',
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                //print("${categories[5].name} Taped");
                                //_show_companies(context, categories[5]);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.5, right: 2.5),
                                child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Color(0XFF1A2229),
                                      // borderRadius: new BorderRadius.circular(5.0)
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 9.0, right: 9.0),
                                        child: new Text('3',
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    )),
                              ),
                            )),
                          ],
                        ),
                      )),
                      new Expanded(
                          child: new Container(
                        height: 100.0,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  //print("${categories[6].name} Taped");
                                  //_show_companies(context, categories[6]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2.5, bottom: 2.5),
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Color(0XFF1A2229),
                                      // borderRadius: new BorderRadius.circular(5.0)
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 9.0, right: 9.0),
                                        child: new Text('4',
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                // print("${categories[12].name} Taped");
                                // _show_companies(context, categories[12]);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 2.5, top: 2.5),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    color: Color(0XFF1A2229),
                                    //borderRadius: new BorderRadius.circular(5.0)
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 9.0, right: 9.0),
                                      child: new Text('5',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: new Container(
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: Color(0XFF1A2229),
                              // borderRadius: new BorderRadius.circular(5.0)
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 9.0, right: 9.0),
                                child: new Text('6',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          //print("${categories[4].name} Taped");
                          //_show_companies(context, categories[4]);
                        },
                      )),
                      Expanded(
                          child: GestureDetector(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 2.5, bottom: 2.5),
                          child: new Container(
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: Color(0XFF1A2229),
                              //borderRadius: new BorderRadius.circular(5.0)
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 9.0, right: 9.0),
                                child: new Text('7',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          // print("${categories[7].name} Taped");
                          // _show_companies(context, categories[7]);
                        },
                      )),
                      new SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                          child: GestureDetector(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 2.5, bottom: 2.5),
                          child: new Container(
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: Color(0XFF1A2229),
                              //borderRadius: new BorderRadius.circular(5.0)
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 9.0, right: 9.0),
                                child: new Text('8',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          //print("${categories[11].name} Taped");
                          //_show_companies(context, categories[11]);
                        },
                      )),
                    ],
                  )
                ],
              ),
              build_category_stories(),
              build_category_stories(),
              build_category_stories(),
              build_category_stories(),
              build_category_stories(),
              build_category_stories(),
              build_category_stories(),
              build_category_stories(),
            ],
          ),
        )
      ],
    );
  }
}



//this component builds a stories based on category
class build_category_stories extends StatelessWidget {
  String category;
  News news;
  build_category_stories({this.category, this.news});

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
                          'Category Name',
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 200.0,
                              decoration: BoxDecoration(color: Colors.green),
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
                              'news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25.0),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      decoration:
                                          BoxDecoration(color: Colors.green),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'fgdfgfdg fg dfg dfg dfnews title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title',
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 20.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      decoration:
                                          BoxDecoration(color: Colors.green),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'fgdfgfdg fg dfg dfg dfnews title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title news title',
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 20.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 10.0,
                      ),

                      Container(
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
                                          'title title title title title title title title title title title ',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,fontSize: 20.0),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            'content content content content content content content content content content content ',
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
                                new FadeInImage.assetNetwork(
                                    placeholder: '',
                                    image:
                                        'https://www.newspages.co.za/wp-content/uploads/2018/11/RESTAURANTS.jpg',
                                    fit: BoxFit.cover,
                                    width: 100.0,
                                    height: 100.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                        SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              );
  }
}
