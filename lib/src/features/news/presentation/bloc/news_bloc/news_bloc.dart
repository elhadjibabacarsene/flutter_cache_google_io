import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../../models/news_model.dart';
import '../../../services/local/news_local_service.dart';
import '../../../services/remote/news_remote_service.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<GetNews>((event, emit) async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      emit(NewsLoading());
      try {
        final List<Articles> articles =await fetchAndCacheArticleList(connectivityResult);
        emit(NewsLoaded(articles: articles, isCachedData: connectivityResult == ConnectivityResult.none ? true : false));
      } catch (e) {
        emit(const NewsError(message: 'Une erreur est survenue !'));
      }
    });
  }
}

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
}
