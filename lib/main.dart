import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_gallery_cache/src/features/news/models/news_model.dart';
import 'package:flutter_gallery_cache/src/features/news/services/remote/news_remote_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/features/news/services/local/news_local_service.dart';

// Bloc pour gérer l'état de l'application
enum GalleryEvent { fetchImages, clearCache }

class GalleryBloc extends Bloc<GalleryEvent, List<String>> {
  GalleryBloc() : super([]);

  @override
  Stream<List<String>> mapEventToState(GalleryEvent event) async* {
    if (event == GalleryEvent.fetchImages) {
      yield await fetchImages();
    } else if (event == GalleryEvent.clearCache) {
      await DefaultCacheManager().emptyCache();
      yield [];
    }
  }

  Future<List<String>> fetchImages() async {
    final url = 'https://example.com/api/images';
    final response = await http.get(Uri.parse(url));

    print('response.statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load images');
    }
  }
}

class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => GalleryBloc(),
        child: GalleryPage(),
      ),
    );
  }
}

class GalleryPage extends StatefulWidget {
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Articles>>(
          future: fetchAndCacheArticleList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index)  {
                  final article = snapshot.data![index];
                  return ListTile(
                    title: Text(article.title?? "---"),
                    subtitle: Text(article.description?? "---"),
                    leading: Container(
                      width: 100,
                      height: 100,
                      child: FutureBuilder(
                        future: _buildCachedImage(article.urlToImage?? ''),
                        builder: (ctx, snp){
                          if (snp.hasData) {
                            return snp.data!;
                          }
                          return Container();
                        }
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Une erreur est survenue'));
            } else {
              return const Center(child: Text('Aucune donnée'));
            }
          },
        ),
      );
  }

  Future<Widget> _buildCachedImage(String? imageUrl)  async {
    if (imageUrl != null && imageUrl != 'null') {
      print('=== URL === $imageUrl');
      var imgFile = await DefaultCacheManager().getFileFromCache(imageUrl);
      print('=== FILE OBJET === $imgFile');
      return imgFile != null && imgFile.file != null
        ? Image.file(imgFile.file)
        : Image.asset('assets/images/default_img.webp');
    }else{
      return Image.asset('assets/images/default_img.webp');
    }
  }

  Future<List<Articles>> fetchAndCacheArticleList() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.ethernet) {
      print('=================== GET FROM LOCAL ===============');
      var rt = await  NewsLocalService.getArticleListFromCache();
      return rt;
    } else {
      print('=================== GET FROM REMOTE =============');
      final articlesList = await NewsRemoteService().getArticlesFromApi();
      NewsLocalService.saveArticleListToCache(articlesList);
      return articlesList;
    }
  }
}

void main() {
  runApp(GalleryApp());
}
