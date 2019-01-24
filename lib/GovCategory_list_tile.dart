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
      // child: ListView.builder(
      //   itemCount: gov_categories.length,
      //   padding: const EdgeInsets.all(0.0),
      //   itemBuilder: (context, position){
      //     return Column(
      //       children: <Widget>[
      //         Divider(
      //           height: 10.0,
      //         ),
      //         ListTile(
      //           title: 
      //           Text(
      //             '${gov_categories[position].name.toUpperCase()}',
      //             // style: TextStyle(
      //             //   fontSize: 15.0,
      //             //   fontWeight: FontWeight.w900,
      //             style: TextStyle(
      //             fontWeight: FontWeight.w300,
      //             color: Colors.black,
      //             fontSize: 16.0,
                
      //               //color: Colors.grey,
                    
      //             ),
      //             textAlign: TextAlign.left,
      //           ),
      //           onTap: () => _show_category(context, gov_categories[position]),
      //         )
      //       ],
      //     );
      //   },
      // ),
       color: Colors.white30,
                 child: GridView.builder(
                  //remove space in the top
                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0,left: 5.0,right: 5.0),
                  shrinkWrap: false,
                  primary: true,
                  itemCount: gov_categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.0,crossAxisSpacing: 4.0,mainAxisSpacing: 4.0),
                  itemBuilder: (BuildContext context, int index){
                    return                   new Expanded(
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

                    // return GridTile(
                    //   child: Card(
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         Image.network("https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681",fit: BoxFit.fill,),
                    //         Expanded(
                    //           child: Center(
                    //             child: Column(
                    //               children: <Widget>[
                    //                 SizedBox(
                    //                   height: 8.0,
                    //                 ),
                    //                 Padding(
                    //                   padding: EdgeInsets.only(left: 5.0,right: 5.0),
                    //                   child: Text("${gov_categories[index].name}"),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                      // child: RaisedButton(
                      //   child: SizedBox(
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //       Icon(Icons.business_center,size: 25.0,),
                      //       Text('${gov_categories[index].name}',style: TextStyle(
                      //         color: Colors.grey,
                      //         fontWeight: FontWeight.w300
                      //       ),)
                      //       ],
                      //     ),
                      //   ),
                      //   color: Colors.white,
                      //   //padding: EdgeInsets.all(1.0),
                      //   onPressed: (){},) 
                    );
                  },
                )
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