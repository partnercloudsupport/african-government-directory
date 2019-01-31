import 'package:flutter/foundation.dart';
import 'package:government_directory/models/news.dart';
import 'package:government_directory/models/news_category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class news_api{
    Future<List> loadNews() async {
    final response = await http.get('https://government.co.za/api/news');
    return jsonDecode(response.body);
  }


  Future<List> get_news_categories() async{
    final response = await http.get('https://government.co.za/api/news');
    return jsonDecode(response.body);
  }

  Future<List<News>> get_news_by_category(String id) async{
    var news = List<News>();
    
    final response = await http.get('https://government.co.za/api/news_category/${id}');
    //print(jsonDecode(response.body));

    news = parse_news(response.body);
    return news;

    //return jsonDecode(response.body);
  }

  List<News> parse_news(String response){
    final parsed_data = json.decode(response).cast<Map<String, dynamic>>();
    return parsed_data.map<News>((json) => News.fromjson(json)).toList();
  }

  Future<List<news_category>> get_recent() async{
    var cats = List<news_category>();

    final response = await http.get('https://government.co.za/api/recent_news');
   // print(response.body);

    cats = parse_category(response.body);

    return cats;
    //print(cats[0].news[1].title);
    //return compute(parse_category,response.body);
  }

  List<news_category> parse_category(String response) {
    final parsed_data = json.decode(response).cast<Map<String, dynamic>>();
    return parsed_data.map<news_category>((json) => news_category.fromJson(json)).toList();
  }
}