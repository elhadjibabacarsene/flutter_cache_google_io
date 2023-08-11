import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gallery_cache/src/features/news/presentation/pages/home_page.dart';


void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


/*
Future<List<Articles>> fetchAndCacheArticleList(ConnectivityResult connectivityResult) async {
  if (connectivityResult == ConnectivityResult.none) {
    print('=================== GET FROM LOCAL ===============');
    return await NewsLocalService.getArticleListFromCache();
  } else {
    print('=================== GET FROM REMOTE =============');
    final articlesList = await NewsRemoteService().getArticlesFromApi();
    NewsLocalService.saveArticleListToCache(articlesList);
    return articlesList;
  }
}*/
