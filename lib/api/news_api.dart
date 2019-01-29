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

  Future<List> get_news_by_category(String category) async{
    final response = await http.get('https://government.co.za/api/news');
    return jsonDecode(response.body);
  }
}