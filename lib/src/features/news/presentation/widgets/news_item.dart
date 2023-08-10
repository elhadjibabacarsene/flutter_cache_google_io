import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gallery_cache/src/constants/colors/app_colors.dart';
import 'package:flutter_gallery_cache/src/features/news/models/news_model.dart';
import 'package:readmore/readmore.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key, required this.article});

  final Articles article;

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
            future: _buildCachedImage(article.urlToImage ?? ''),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
              }
              return Container();
            }),
      ),
    );
  }

  Future<Widget> _buildCachedImage(String? imageUrl) async {
    if (imageUrl != null && imageUrl != 'null') {
      var imgFile = await DefaultCacheManager().getFileFromCache(imageUrl);
      return imgFile != null && imgFile.file != null
          ? Image.file(imgFile.file)
          : Image.network(imageUrl, fit: BoxFit.cover,);
    } else {
      return Image.asset('assets/images/default_img.webp');
    }
  }
}
