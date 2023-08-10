import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gallery_cache/src/features/news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:flutter_gallery_cache/src/features/news/presentation/pages/home_page.dart';


void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => NewsBloc()..add(GetNews()), child: const HomePage(),
      ),
    );
  }
}