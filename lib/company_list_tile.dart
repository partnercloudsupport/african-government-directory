import 'package:flutter/material.dart';
import 'models/company.dart';
import 'company_page.dart';

class company_list_tile extends StatelessWidget {
  final List<Company> companies;

  company_list_tile({Key key, this.companies}) : super(key: key);

  _on_favourite_click() {}

  _change_favourite_icon() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  print(companies[position].name);
                  _show_company(context,companies[position]);
                },
                child:Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(_rander_company_image(companies[position].url),height: 60,),
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
                                        children: [
                                          TextSpan(text: companies[position].name, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.0, color: Colors.black)),
                                        ]
                                      ),overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

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
                                    child: Text(companies[position].address,style: TextStyle(fontSize: 18.0),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ) ,
              ),
              
                                        Divider(),
            ],
          );
          // return Column(
          //   children: <Widget>[
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         Container(
          //           width: 80,
          //           //height: 70,
          //           child: Image.network('https://tinypng.com/images/social/website.jpg',fit: BoxFit.fill,),
          //         ),
          //         GestureDetector(
          //           child: Container(
          //             padding: EdgeInsets.all(1.0),
          //             width: MediaQuery.of(context).size.width - 80,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 Padding(
          //                   padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
          //                   child: Text(companies[position].name,style: TextStyle(
          //         fontWeight: FontWeight.w400,
          //         color: Colors.black,
          //         fontSize: 16.0,
          //       )),
          //                 ),
          //                 Padding(
          //                   padding: EdgeInsets.all(12.0),
          //                   child: Text(companies[position].address,
          //                     style: TextStyle(
          //                         fontSize: 15.0, fontWeight: FontWeight.w400,color: Colors.grey)),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //                     Divider(
          //         height: 2.0,
          //         color: Colors.grey,
          //       ),
          //   ],
          // );
          // return Padding(
          //   padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          //   child: GestureDetector(
          //     child: Row(
          //       children: <Widget>[
          //         new Container(
          //           height: 100.0,
          //           width: 100.0,
          //           child: Image.network('https://tinypng.com/images/social/website.jpg',fit: BoxFit.cover,
          //           ),
          //         ),
          //         Expanded(
          //           child: Padding(
          //             padding: EdgeInsets.only(left: 5.0),
          //             child: Container(
          //             height: 100.0,
          //             child: Column(
          //               children: <Widget>[
          //                 Expanded(
          //                     child: new Container(
          //                       child: Center(
          //                             child: Padding(
          //                               padding: EdgeInsets.only(
          //                                   left: 9.0, right: 9.0),
          //                               child: new Text(companies[position].name,
          //                                   style: new TextStyle(
          //                                       color: Colors.black,
          //                                       fontSize: 16.0,
          //                                       fontWeight: FontWeight.w400)),
          //                             ),
          //                           )                      
          //                     ),
          //                 ),
          //                 Divider(
          //                   height: 2.0,
          //                   color: Colors.pink,
          //                 ),
          //                 Expanded(
          //                     child: new Container(
          //                       child: Center(
          //                             child: Padding(
          //                               padding: EdgeInsets.only(
          //                                   left: 9.0, right: 9.0),
          //                               child: new Text(companies[position].address,
          //                                   style: new TextStyle(
          //                                       color: Colors.grey,
          //                                       fontSize: 15.0,
          //                                       fontWeight: FontWeight.w400)),
          //                             ),
          //                           )                      
          //                     ),
          //                 ),
          //               ],
          //             ),
          //           )
          //           ),
          //         )
          //       ],
          //     ),
          //     onTap: () {},
          //   ),
          // );
          // return Column(
          //   children: <Widget>[
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         new GestureDetector(
          //           onTap: () {
          //             print(companies[position].name);
          //             _show_company(context, companies[position]);
          //           },
          //           child: new Container(
          //             padding: const EdgeInsets.all(1.0),
          //             width: MediaQuery.of(context).size.width * 0.9,
          //             child: new Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 Padding(
          //                   padding: const EdgeInsets.fromLTRB(
          //                       12.0, 12.0, 12.0, 6.0),
          //                   child: Text(companies[position].name,
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w400,
          //                         color: Colors.black,
          //                         fontSize: 16.0,
          //                       )),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.fromLTRB(
          //                       12.0, 6.0, 12.0, 12.0),
          //                   child: Text(
          //                     companies[position].address,
          //                     style: TextStyle(
          //                         fontSize: 15.0,
          //                         fontWeight: FontWeight.w400,
          //                         color: Colors.grey),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     Divider(
          //       height: 2.0,
          //       color: Colors.grey,
          //     )
          //   ],
          // );
        },
      ),
    );
  }

  String _rander_company_image(String image__url){
    bool _empty = false;

    try{
      if(image__url.isEmpty || image__url == null){
        _empty = true;
      }
    }catch(ex){
      _empty = true;
      print('displaying company image failed');
    }

    if(_empty){
      return 'https://www.labx.com/images/image-not-found.png';
    }else{
      return 'http://cdn.adslive.com/${image__url}';
    }
  }

  void _show_company(BuildContext context, Company company) async {
    print(company.name);
    Map result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => company_page(
                  company: company,
                  old_context: context,
                )));
  }
}
