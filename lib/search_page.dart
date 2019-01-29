import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:government_directory/company_page.dart';
import 'models/company.dart';
import 'package:http/http.dart' as http;
import 'company_list_tile.dart';

class search_page extends StatefulWidget {
  final BuildContext old_context;

  search_page({Key key, this.old_context}) : super(key: key);
  @override
  _search_page_state createState() => _search_page_state(this.old_context);
}

class _search_page_state extends State<search_page> {
  final old_context;
  final GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();

  _search_page_state(this.old_context);

  TextEditingController _search = new TextEditingController();
  bool _search_term = false;

  bool _is_searching = false;
  bool _after_serching = false;

  List<Company> found_companies = [];
  _onClear() {
    _search.clear();
    setState(() {
      _is_searching = false;
      _after_serching = false;
    });
  }

  _onSearch() {
    print(_search.text);
    call_search_company_api();
  }

  Future<List<Company>> call_search_company_api() async {
    setState(() {
      found_companies = [];
      _is_searching = true;
      _after_serching = false;
    });
    var data = jsonEncode({'data': _search.text});
    final response = await http
        .post('https://government.co.za/api/search_company/', body: data);

        //done searching
        setState((){
          _is_searching = false;
          _after_serching = true;
        });
    if (response.body == 'failed') {
      print('no company was found');
      _call_snackbar(
          'Company Matching ${_search.text.toUpperCase()} Not Found');
    } else {
      print('somthing was found');
      setState(() {
        found_companies = parse_companies(response.body);
      });

      print(found_companies);
    }
  }

  static List<Company> parse_companies(String response_body) {
    final parsed_data = json.decode(response_body).cast<Map<String, dynamic>>();

    return parsed_data.map<Company>((json) => Company.fromjson(json)).toList();
  }

  _call_snackbar(message) {
    final snackbar = SnackBar(
      content: Text(message),
    );

    _scaffold_key.currentState.showSnackBar(snackbar);
  }

  Widget _not_searching(){
    if(_after_serching){
      if(found_companies.isNotEmpty){
        return ListView.builder(
          itemCount: found_companies.length,
          itemBuilder: (context,position){
            return Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => company_page(company: found_companies[position],old_context: context,)));
                },
                child:Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(_rander_company_image(found_companies[position].url),height: 60,),
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
                                          TextSpan(text: found_companies[position].name, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.0, color: Colors.black)),
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
                                    child: Text(found_companies[position].address,style: TextStyle(fontSize: 18.0),),
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
        );
      }else{
        return new Center(
          child: Text('No Results Found!'),
        );
      }
    }else{
      return new Center(
        child: _starting(),
        );
    }
  }
  _starting() => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _on_not_searching()
      ],
    ),
  );
  _on_not_searching() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Icon(Icons.search),
      SizedBox(height: 2.0,),
      Text('Search Government Directory'),
    ],
  );

  _on_no_results_found() => Text(
    'No Results Found!'
  );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffold_key,
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(
          'Government DIrectory'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
        ),
        backgroundColor: Colors.green,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return new Container(
            child: new Column(
              children: <Widget>[
                new Material(
                  color: Colors.green,
                  child: new Container(
                    margin: const EdgeInsets.all(7.0),
                    child: new TextField(
                      autofocus: true,
                      controller: _search,
                      onSubmitted: (value) {
                        run_search();
                      },
                      decoration: new InputDecoration(
                          hintText: "Search",
                          suffixIcon: new IconButton(
                              icon: new Icon(Icons.search),
                              onPressed: () {
                                run_search();
                              }),
                          prefixIcon: new IconButton(
                              icon: new Icon(Icons.clear),
                              onPressed: () {
                                print('clear button pressed');
                                _onClear();
                              }),
                          border: InputBorder.none),
                    ),
                    decoration: new BoxDecoration(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(10.0)),
                      color: Colors.white,
                    ),
                  ),
                ),
                new Expanded(
                  child: new Container(
                    child: _is_searching ? new Center(child: CircularProgressIndicator() ) : _not_searching(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void run_search() {
    print('search button pressed');

    setState(() {
      _search.text.isEmpty ? _search_term = true : _search_term = false;
    });

    if (!_search_term) {
      _onSearch();
    } else {
      print('empty');
      _call_snackbar('Enter Company Name');
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
