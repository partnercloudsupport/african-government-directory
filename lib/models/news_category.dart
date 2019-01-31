import 'package:government_directory/models/news.dart';

class news_category{
  String name;
  String id;
  List<News> news;

  news_category({
    this.name,
    this.id
  });
  
  news_category.fromJson(Map json) 
  : 
    name =json['name'],
    id = json['id'].toString(),
    news = (json['news'] as List).map((i) => News.fromjson(i)).toList();
  }