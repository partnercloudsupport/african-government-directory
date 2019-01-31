import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:government_directory/add_advert.dart';
// import 'package:government_directory/all_news.dart';
import 'package:government_directory/favourites.dart';
import 'package:government_directory/models/news.dart';
import 'package:government_directory/news_page.dart';
import 'package:government_directory/search_page.dart';
import 'package:government_directory/views/pages/news_page.dart';

import 'package:http/http.dart' as http;

import 'models/GovCategory.dart';

import 'package:flutter/cupertino.dart';

//shared preferences import
import 'package:shared_preferences/shared_preferences.dart';
import 'gov_cat.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const String _logged_in_key = 'loggedin';

class _HomePageState extends State<HomePage> {
  bool _logged_in;
  final GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();
  SharedPreferences preferences;
  List<GovCategory> _government_categories = [];
  bool _is_in_async_call = false;
  List<News> _news = [];

  @override
  void initState() {
    super.initState();
    print('runned');
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      preferences = sp;

      get_all_categories(http.Client());
    });
  }

  Future<List<News>> _get_news() async {
    setState(() {
      _is_in_async_call = true;
    });
    final response = await http
        .get('https://government.co.za/api/news')
        .then((response) {
      setState(() {
        _is_in_async_call = false;
        _news = parse_news(response.body);
      });
    });
  }

  List<News> parse_news(String responseBody) {
    final parsed_data = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed_data.map<News>((json) => News.fromjson(json)).toList();
  }

  //get all government posts from api call
  Future<List<GovCategory>> get_all_categories(http.Client client) async {
    setState(() {
      _is_in_async_call = true;
    });
    final response = await client
        .get('https://government.co.za/api/government_categories')
        .then((response) {
      setState(() {
        _is_in_async_call = false;

        _government_categories = parse_category(response.body);
      });

      _get_news();
    }).catchError((error) {
      setState(() {
        _is_in_async_call = false;
      });

      print('Error ' + error);
    });
  }

  static List<GovCategory> parse_category(String responseBody) {
    final parsed_data = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed_data
        .map<GovCategory>((json) => GovCategory.fromjson(json))
        .toList();
  }

  void _remove_local_data(String key) {
    preferences?.remove(key);
  }

  var gridView = new GridView.builder(
      itemCount: 15,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 1.0,
            child: new Container(
              alignment: Alignment.center,
              child: new Text('Item $index'),
            ),
          ),
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              child: new CupertinoAlertDialog(
                title: new Column(
                  children: <Widget>[
                    new Text("GridView"),
                    new Icon(
                      Icons.favorite,
                      color: Colors.green,
                    ),
                  ],
                ),
                content: new Text("Selected Item $index"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("OK"))
                ],
              ),
            );
          },
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        elevation: 0.0,
        backgroundColor: Colors.green,
        title: Text(
          'GOVERNMENT DIRECTORY',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      key: _scaffold_key,
      body: _is_in_async_call
          ? Center(
              child: CircularProgressIndicator(),
            )
          : body_ui(
              categories: _government_categories,
              news: _news,
            ),

      bottomNavigationBar: new BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {
                _app_menu(context);
              },
            ),
            new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            search_page(old_context: context)));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _app_menu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favourites',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavouritesPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Video Channel',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
              onTap: () {
                print('video channel tabbed');
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add A Free Advert',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
              onTap: () {
                print('add free add tabed');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => add_advert()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16.0,
                  )),
              onTap: () {
                print('log out tabed');
                _remove_local_data(_logged_in_key);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            )
          ],
        );
      },
    );
  }
}

class body_ui extends StatelessWidget {
  final List<GovCategory> categories;
  final List<News> news;

  body_ui({Key key, this.categories, this.news}) : super(key: key);

  _show_companies(BuildContext context, GovCategory category) async {
    Map result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => gov_cat(govCategory: category)));
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: new Container(
              child: new Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                                    Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('News',style: TextStyle(fontSize: 20.0),),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Text('View More', style: TextStyle(
                          color: Color(0XFF2BD093),
                        ),
                          textAlign: TextAlign.end,
                        ),
                        onTap: (){
                          print('view all clicked');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => all_news_page()));
                        },
                        ) 
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 200.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // <-- Like so
                      itemCount: news.length,
                      itemBuilder: (BuildContext context, int position) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => news_page(news:news[position]) ));
                          },
                          child:Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                color: Colors.black.withOpacity(0.9),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(news[position].title,style: TextStyle(color: Colors.white),)
                                ) ,
                              ),
                                ), 
                              height: 190.0,
                              width: MediaQuery.of(context).size.width - 100.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  image: new NetworkImage(
                                    news[position].thumbnail
                                  ),
                                  fit: BoxFit.fill
                                )
                              ),
                            ),
                            ),

                          ],
                        ),
                        ); 
                      },
                    ),
                    
                    //stop here man
                  ),
                                    SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 5.0,
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Text(
                  //         'Looking For Today?',
                  //         style: TextStyle(
                  //             fontSize: 30.0, fontWeight: FontWeight.w300),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 15.0,
                  ),

                  
                ],
              ),
              Row(
                children: <Widget>[
                  new Text(
                    "Explore",
                    style: new TextStyle(
                      fontSize: 30.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              new SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                    child: GestureDetector(
                        onTap: () {
                          print("${categories[0].name} Taped");
                          _show_companies(context, categories[0]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: new Container(
                            height: 100.0,
                            decoration: new BoxDecoration(
                               // borderRadius: new BorderRadius.circular(5.0),
                                color: Colors.green),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 9.0, right: 9.0),
                                  child: Center(
                                    child: new Text("${categories[0].name}",
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
                            print('${categories[13].name} Taped');
                            _show_companies(context, categories[13]);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2.5, right: 2.5),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.green,
                                  //borderRadius: new BorderRadius.circular(5.0)
                                  ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 9.0, right: 9.0),
                                      child: new Text('${categories[13].name}',
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
                            print("${categories[5].name} Taped");
                            _show_companies(context, categories[5]);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 2.5, right: 2.5),
                            child: new Container(
                                decoration: new BoxDecoration(
                                    color: Colors.green,
                                   // borderRadius: new BorderRadius.circular(5.0)
                                    ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 9.0, right: 9.0),
                                    child: new Text('${categories[5].name}',
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
                              print("${categories[6].name} Taped");
                              _show_companies(context, categories[6]);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.5, bottom: 2.5),
                              child: new Container(
                                decoration: new BoxDecoration(
                                    color: Colors.green,
                                   // borderRadius: new BorderRadius.circular(5.0)
                                        ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 9.0, right: 9.0),
                                    child: new Text('${categories[6].name}',
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
                            print("${categories[12].name} Taped");
                            _show_companies(context, categories[12]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.5, top: 2.5),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.green,
                                  //borderRadius: new BorderRadius.circular(5.0)
                                  ),
                              child: Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 9.0, right: 9.0),
                                  child: new Text('${categories[12].name}',
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
              new SizedBox(
                height: 15.0,
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                      child: new Text("Services",
                          style: new TextStyle(fontSize: 18.0))),
                  // new Expanded(
                  //     child: new Text(
                  //   "View All",
                  //   style: new TextStyle(color: Color(0XFF2BD093)),
                  //   textAlign: TextAlign.end,
                  // ))
                ],
              ),
              new SizedBox(
                height: 10.0,
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: GestureDetector(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 2.5, bottom: 2.5),
                          child: new Container(
                            height: 50.0,
                            decoration: new BoxDecoration(
                                color: Color(0XFF1A2229),
                               // borderRadius: new BorderRadius.circular(5.0)
                                ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 9.0, right: 9.0),
                                child: new Text('${categories[4].name}',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          print("${categories[4].name} Taped");
                          _show_companies(context, categories[4]);
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
                                child: new Text('${categories[7].name}',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          print("${categories[7].name} Taped");
                          _show_companies(context, categories[7]);
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
                                child: new Text('${categories[11].name}',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          print("${categories[11].name} Taped");
                          _show_companies(context, categories[11]);
                        },
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          print("${categories[10].name} Taped");
                          _show_companies(context, categories[10]);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 2.5, bottom: 2.5),
                          child: new Container(
                            height: 100.0,
                            decoration: new BoxDecoration(
                                color: Colors.green,
                                //borderRadius: new BorderRadius.circular(5.0)
                                ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 9.0, right: 9.0),
                                child: new Text('${categories[10].name}',
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
                ],
              ),
              new SizedBox(
                height: 15.0,
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                      child: new Text("Government",
                          style: new TextStyle(fontSize: 18.0))),
                ],
              ),
              new SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.5, bottom: 2.5),
                        child: new Container(
                          height: 100.0,
                          decoration: new BoxDecoration(
                              color: Color(0XFF1A2229),
                              //borderRadius: new BorderRadius.circular(5.0)
                              ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 9.0, right: 9.0),
                              child: new Text('${categories[1].name}',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        print("${categories[1].name} Taped");
                        _show_companies(context, categories[1]);
                      },
                    ),
                  ),
                  new SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.5, bottom: 2.5),
                      child: new Container(
                        height: 100.0,
                        decoration: new BoxDecoration(
                            color: Color(0XFF1A2229),
                            //borderRadius: new BorderRadius.circular(5.0)
                            ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 9.0, right: 9.0),
                            child: new Text('${categories[2].name}',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("${categories[2].name} Taped");
                      _show_companies(context, categories[2]);
                    },
                  )),
                  new SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.5, bottom: 2.5),
                      child: new Container(
                        height: 100.0,
                        decoration: new BoxDecoration(
                            color: Color(0XFF1A2229),
                            //borderRadius: new BorderRadius.circular(5.0)
                            ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 9.0, right: 9.0),
                            child: new Text('${categories[3].name}',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("${categories[3].name} Taped");
                      _show_companies(context, categories[3]);
                    },
                  )),
                ],
              ),
              new SizedBox(
                height: 15.0,
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                      child: new Text("More",
                          style: new TextStyle(fontSize: 18.0))),

                ],
              ),
              new SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.5, bottom: 2.5),
                      child: new Container(
                        height: 100.0,
                        decoration: new BoxDecoration(
                            color: Color(0XFF1A2229),
                            //borderRadius: new BorderRadius.circular(5.0)
                            ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 9.0, right: 9.0),
                            child: new Text('${categories[8].name}',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("${categories[8].name} Taped");
                      _show_companies(context, categories[8]);
                    },
                  )),
                  new SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.5, bottom: 2.5),
                      child: new Container(
                        height: 100.0,
                        decoration: new BoxDecoration(
                            color: Color(0XFF1A2229),
                            //borderRadius: new BorderRadius.circular(5.0)
                            ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 9.0, right: 9.0),
                            child: new Text('${categories[9].name}',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("${categories[9].name} Taped");
                      _show_companies(context, categories[9]);
                    },
                  )),
                  new SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.5, bottom: 2.5),
                      child: new Container(
                        height: 100.0,
                        decoration: new BoxDecoration(
                            color: Color(0XFF1A2229),
                           // borderRadius: new BorderRadius.circular(5.0)
                            ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 9.0, right: 9.0),
                            child: new Text('${categories[14].name}',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("${categories[14].name} Taped");
                      _show_companies(context, categories[14]);
                    },
                  )),
                ],
              )
            ],
          )),
        )
      ],
    );
  }
}
