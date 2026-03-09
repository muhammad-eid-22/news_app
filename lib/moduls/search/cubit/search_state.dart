part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ArticleData> articles;
  final String query;

  SearchLoaded(this.articles, this.query);
}

class SearchSuggestions extends SearchState {
  final List<ArticleData> articles;

  SearchSuggestions(this.articles);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
