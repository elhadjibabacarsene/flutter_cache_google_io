import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gallery_cache/src/constants/colors/app_colors.dart';
import 'package:flutter_gallery_cache/src/features/news/models/news_model.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key, required this.article, required this.isCachedData});
  final Articles article;
  final bool isCachedData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title ?? "---"),
      subtitle: ReadMoreText(
        article.description ?? "---",
        trimLines: 2,
        colorClickableText: gray03,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Show more',
        moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      leading: SizedBox(
        width: 100,
        height: 100,
        child: FutureBuilder(
          future: buildImage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }else{
              return Image.asset('assets/images/default_img.webp');
            }
          },
        )
      ),
    );
  }

  Future<Widget> buildImage() async {
    if (isCachedData) {
      final imageFile = await DefaultCacheManager().getSingleFile(article.urlToImage?? "");
      return Image.file(imageFile,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/default_img.webp', fit: BoxFit.cover,);
        },
      );
    }
    saveImageFromCash();
    return Image.network(article.urlToImage?? "", fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/default_img.webp', fit: BoxFit.cover,);
      },
    );
  }

  saveImageFromCash() async {
    try {
      final imageData = await NetworkAssetBundle(Uri.parse(article.urlToImage?? "")).load(article.urlToImage?? "");
      final imageBytes = imageData.buffer.asUint8List();
      DefaultCacheManager().putFile(article.urlToImage?? "", imageBytes);
    // ignore: empty_catches
    } catch (e) {}
  }
}
