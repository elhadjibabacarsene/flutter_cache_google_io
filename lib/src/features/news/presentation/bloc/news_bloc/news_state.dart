part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  @override
  List<Object> get props => [];
}

class NewsLoaded extends NewsState {
  final List<Articles> articles;
  final bool isCachedData;

  const NewsLoaded({required this.articles, required this.isCachedData});

  @override
  List<Object> get props => [articles,isCachedData];
}


class NewsError extends NewsState {
  final String message;

  const NewsError({required this.message});

  @override
  List<Object> get props => [message];
}

class NewsLoading extends NewsState {
  @override
  List<Object> get props => [];
}
