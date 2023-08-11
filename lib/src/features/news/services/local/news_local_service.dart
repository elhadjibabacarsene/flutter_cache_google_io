import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../models/news_model.dart';

class NewsLocalService {

  static const _cacheKey = 'news_cache_key';

  static Future<void> saveArticleListToCache(List<Articles> articles) async {

    final List<Map<String, dynamic>> articleMapList = articles.map((article) => article.toJson()).toList();
    final jsonEncoded = json.encode(articleMapList);
    await DefaultCacheManager().putFile(_cacheKey, Uint8List.fromList(utf8.encode(jsonEncoded)));
  }

  static Future<List<Articles>> getArticleListFromCache() async {
    final file = await DefaultCacheManager().getFileFromCache(_cacheKey);
    if (file != null) {
      final jsonEncoded = await file.file.readAsString();
      final List<dynamic> articlesMapList = json.decode(jsonEncoded);
      final articles = articlesMapList.map((map) => Articles.fromJson(map)).toList();
      return articles.cast<Articles>();
    }
    return [];
  }

}