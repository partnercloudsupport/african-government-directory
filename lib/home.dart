import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:government_directory/add_advert.dart';
import 'package:government_directory/favourites.dart';
import 'package:government_directory/search_page.dart';
import 'models/government_category.dart';
import 'package:http/http.dart' as http;
import 'services/post_service.dart';
import 'list_view_posts.dart';
import 'models/GovCategory.dart';
import 'GovCategory_list_tile.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//shared preferences import
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const String _logged_in_key = 'loggedin';

class _HomePageState extends State<HomePage> {
  bool _logged_in;
  final GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();
  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    print('runned');
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      preferences = sp;
    });
  }

  //get all government posts from api call
  Future<List<GovCategory>> get_all_categories(http.Client client) async {
    final response =
        await client.get('https://government.co.za/api/government_categories');
    return compute(parse_category, response.body);
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
      key: _scaffold_key,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.green,
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'GOVERNMENT DIRECTORY',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )
          ];
        },
        body: Column(
          children: <Widget>[
                        SizedBox(
              height: 5.0,
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 4,
                child: Center(child:Text('Image Here',style: TextStyle(fontSize: 25.0,color: Colors.black, fontWeight: FontWeight.w600),),
              ),)  
              //Image.network('https://www.gettyimages.com/gi-resources/images/CreativeLandingPage/HP_Sept_24_2018/CR3_GettyImages-159018836.jpg',fit: BoxFit.cover,height: MediaQuery.of(context).size.width / 4,width: MediaQuery.of(context).size.width,),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<GovCategory>>(
                future: get_all_categories(http.Client()),
                builder: (context, snapshot){
                  if(snapshot.hasError)
                    print(Error);
                  return snapshot.hasData ? GovCategory_list_tile(gov_categories: snapshot.data,) : Center(child: CircularProgressIndicator(),);
                },
              )
            ),
          ],
        )
        // body: FutureBuilder<List<GovCategory>>(
        //   future: get_all_categories(http.Client()),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       print(snapshot.error);
        //     }
        //     return snapshot.hasData
        //         ? GovCategory_list_tile(gov_categories: snapshot.data)
        //         : Center(child: CircularProgressIndicator());
        //   },
        // ),
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
