import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/news_model.dart';

class NewsRemoteService {
  final url = 'https://newsapi.org/v2/everything?q=tesla&from=2023-07-06&sortBy=publishedAt&apiKey=821440346a494e7dab7afed916f44fac';

  Future<List<Articles>> getArticlesFromApi() async {
    final response = await http.get(Uri.parse(url));
    print('=================${response.statusCode}');
    if (response.statusCode == 200) {
      final newsNodel = NewsModel.fromJson(jsonDecode(response.body));
     
      return newsNodel.articles ?? [];
    } else {
      throw Exception('Failed to load news');
    }
  }
  
}