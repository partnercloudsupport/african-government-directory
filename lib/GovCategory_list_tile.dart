import 'package:flutter/material.dart';
import 'models/GovCategory.dart';
import 'gov_cat.dart';

class GovCategory_list_tile extends StatelessWidget{
  final List<GovCategory> gov_categories;

  GovCategory_list_tile({
    Key key, this.gov_categories
  }) : super(key : key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                     child: Container(
                      height: 150.0,
                       child: new Column(
                         children: <Widget>[
                           new Container(
                             height: 100.0,
                             decoration: new BoxDecoration(
                                 borderRadius: new BorderRadius.circular(5.0),
                                 image: new DecorationImage(
                                     image: new NetworkImage(
                                         'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                           new Text(
                             "Play Station",
                           style: new TextStyle(fontSize: 16.0),
                             textAlign: TextAlign.center,
                           )
                         ],
                       ),
                     ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                                            Expanded(
                     child: Container(
                      height: 150.0,
                       child: new Column(
                         children: <Widget>[
                           new Container(
                             height: 100.0,
                             decoration: new BoxDecoration(
                                 borderRadius: new BorderRadius.circular(5.0),
                                 image: new DecorationImage(
                                     image: new NetworkImage(
                                         'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                           new Text(
                             "Play Station",
                           style: new TextStyle(fontSize: 16.0),
                             textAlign: TextAlign.center,
                           )
                         ],
                       ),
                     ),
                      ),
                                            SizedBox(
                        width: 5.0,
                      ),
                                                            Expanded(
                     child: Container(
                      height: 150.0,
                       child: new Column(
                         children: <Widget>[
                           new Container(
                             height: 100.0,
                             decoration: new BoxDecoration(
                                 borderRadius: new BorderRadius.circular(5.0),
                                 image: new DecorationImage(
                                     image: new NetworkImage(
                                         'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                           new Text(
                             "Play Station",
                           style: new TextStyle(fontSize: 16.0),
                             textAlign: TextAlign.center,
                           )
                         ],
                       ),
                     ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                     child: Container(
                      height: 150.0,
                       child: new Column(
                         children: <Widget>[
                           new Container(
                             height: 100.0,
                             decoration: new BoxDecoration(
                                 borderRadius: new BorderRadius.circular(5.0),
                                 image: new DecorationImage(
                                     image: new NetworkImage(
                                         'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                           new Text(
                             "Play Station",
                           style: new TextStyle(fontSize: 16.0),
                             textAlign: TextAlign.center,
                           )
                         ],
                       ),
                     ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                                            Expanded(
                     child: Container(
                      height: 150.0,
                       child: new Column(
                         children: <Widget>[
                           new Container(
                             height: 100.0,
                             decoration: new BoxDecoration(
                                 borderRadius: new BorderRadius.circular(5.0),
                                 image: new DecorationImage(
                                     image: new NetworkImage(
                                         'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                           new Text(
                             "Play Station",
                           style: new TextStyle(fontSize: 16.0),
                             textAlign: TextAlign.center,
                           )
                         ],
                       ),
                     ),
                      ),
                                            SizedBox(
                        width: 5.0,
                      ),
                                                            Expanded(
                     child: Container(
                      height: 150.0,
                       child: new Column(
                         children: <Widget>[
                           new Container(
                             height: 100.0,
                             decoration: new BoxDecoration(
                                 borderRadius: new BorderRadius.circular(5.0),
                                 image: new DecorationImage(
                                     image: new NetworkImage(
                                         'https://www.howtogeek.com/wp-content/uploads/2016/01/steam-and-xbox-controllers.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                           new Text(
                             "Play Station",
                           style: new TextStyle(fontSize: 16.0),
                             textAlign: TextAlign.center,
                           )
                         ],
                       ),
                     ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _on_category_tap(BuildContext context, GovCategory category){
    Scaffold
    .of(context)
    .showSnackBar(new SnackBar(content: new Text(category.name + ' clicked'),));
  }

  void _show_category(BuildContext context, GovCategory category) async{
    print(category.id);
    Map result = await Navigator.push(context, MaterialPageRoute(builder: (context) => gov_cat(govCategory: category)));
  }
}