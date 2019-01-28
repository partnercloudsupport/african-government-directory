import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:government_directory/company_page.dart';
import 'package:government_directory/models/company.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesPage extends StatefulWidget{
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>{
  @override
  void initState(){
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _preferences = sp;
      setState(() {
        user_id = _preferences.getString('id');
      });

      _get_favourite_companies();
    });
  }

  SharedPreferences _preferences;

  final GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();
  bool _is_in_sync_call = false;

  List<Company> _favourite_companies = [];
  String user_id;

  Future<List<Company>> _get_favourite_companies() async {
    setState((){
      _is_in_sync_call = true;
    });
    
    var data = json.encode({'user_id': user_id});
    final response = await http
    .post('https://government.co.za/api/favourite_companies',body: data)
    .then((response){
      setState((){
        _is_in_sync_call = false;
      });

      if(response.body == 'none'){
        print('you dont have any company as your favourite');
      }else{
        print('your favourite companies have been found');

        setState((){
          _favourite_companies = parse_favourite_companies(response.body);
        });
      }
    }).catchError((error){
      setState((){
        _is_in_sync_call = false;
      });

      print('error occured ' + error.toString());
    });
  }

  List<Company> parse_favourite_companies(String response_body){
    final parsed_companies = json.decode(response_body).cast<Map<String, dynamic>>();

    return parsed_companies.map<Company>((json) => Company.fromjson(json)).toList();
  }

    Future _delete_company_from_favourite_list(company_id) async {
    var data = json.encode({'company_id':company_id, 'user_id':user_id});

    setState((){
      _is_in_sync_call = true;
    });

    final response = await http
    .post('https://government.co.za/api/delete_favourite/',body: data)
    .then((response){
      setState((){
        _is_in_sync_call = false;
      });
      var incoming_data = json.decode(response.body);
      
      print('company removed from favourites');
    }).catchError((error){
      print('error occured' + error.toString());
      setState((){
        _is_in_sync_call = false;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        title: Text('Favourite Companies'.toUpperCase(),style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: 20.0,
                ),),
                
      ),
      body: _is_in_sync_call ? Center(child: CircularProgressIndicator()) : _build_favourite_companies(),
    );
  }

  Widget _build_favourite_companies(){
    if(_favourite_companies.isNotEmpty){
      return Container(
        child: ListView.builder(
        itemCount: _favourite_companies.length,
        itemBuilder: (context,position){
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: ()async{
                  var navigate = await Navigator.push(context, MaterialPageRoute(builder: (context) => company_page(company: _favourite_companies[position],old_context: context)));

                  //handling return from pushing a company page or opening a company page
                  if(navigate == true || navigate == null){
                    _favourite_companies = [];
                    _get_favourite_companies();
                  }
                },
                child:Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(_rander_company_image(_favourite_companies[position].url),height: 60,),
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
                                          TextSpan(text: _favourite_companies[position].name, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.0, color: Colors.black)),
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
                                    child: Text(_favourite_companies[position].address,style: TextStyle(fontSize: 18.0),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _delete_company_from_favourite_list(_favourite_companies[position].id).then((data){
                          setState((){
                            _favourite_companies = [];
                          });

                          _get_favourite_companies();
                        });
                      },
                      child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.delete),
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
      ),);
    }else{
      return Center(
        child: Text('you dont have favourite companies')
      );
    }
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

}