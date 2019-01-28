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
