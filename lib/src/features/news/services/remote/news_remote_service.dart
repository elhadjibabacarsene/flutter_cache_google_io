import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/news_model.dart';

class NewsRemoteService {
  final url = 'https://newsapi.org/v2/everything?q=tesla&from=2023-07-12&sortBy=publishedAt&apiKey=ef6cfd46ca884b87953c1d5abee5bf69';

  Future<List<Articles>> getArticlesFromApi() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final newsNodel = NewsModel.fromJson(jsonDecode(response.body));
      return newsNodel.articles ?? [];
    } else {
      throw Exception('Failed to load news');
    }
  }
  
}