import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery App'),
      ),
      body: BlocBuilder<GalleryBloc, List<String>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<GalleryBloc>(context).add(GalleryEvent.fetchImages);
                },
                child: Text('Fetch Images'),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                final imageUrl = state[index];
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<GalleryBloc>(context).add(GalleryEvent.clearCache);
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}

void main() {
  runApp(GalleryApp());
}
