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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () async {
                        print(_favourite_companies[position].name);
                        var nav = await Navigator.push(context, MaterialPageRoute(builder: (context) => company_page(company: _favourite_companies[position],old_context: context,)));
                        
                        //handling callback from push
                        if(nav == true || nav == null){
                          print('i am back');
                          _favourite_companies = [];
                          _get_favourite_companies();
                        }
                      },
                      child: new Container(
                        padding: const EdgeInsets.all(1.0),
                        width: MediaQuery.of(context).size.width - 80,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                              child: Text(_favourite_companies[position].name,style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 16.0,
                )),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                              child: Text(_favourite_companies[position].address,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w400,color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                                                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                
                                 new GestureDetector(
                                   child: Padding(
                              padding: const EdgeInsets.all(8.0),
                                   child: Icon(Icons.delete,
                                   size: 35.0,
                                   color: Colors.grey,),
                                   ),
                                   onTap: (){
                                     print('delete clicked');
                                      _delete_company_from_favourite_list(_favourite_companies[position].id).then((data){
                                      setState((){
                                        _favourite_companies = [];
                                      });
                                       _get_favourite_companies();
                                     });
                                   },
                                 ),
                                 //Text('5M', style: TextStyle(color: Colors.grey),),
                               ],
                             ),
                           ),
                  ],
                ),
                Divider(
                  height: 2.0,
                  color: Colors.grey,
                ),
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
}