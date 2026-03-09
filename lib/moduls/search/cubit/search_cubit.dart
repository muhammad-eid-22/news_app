import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

import '../../../models/artical_data.dart';
import '../../../network_handler/network_handler.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> searchArticles(
    String query, {
    String? sortBy,
    String? language,
  }) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final articles = await NetworkHandler.searchArticles(
        query,
        sortBy: sortBy ?? 'publishedAt',
        language: language ?? 'en',
      );
      debugPrint('Search for "$query" returned ${articles.length} articles');
      emit(SearchLoaded(articles, query));
    } catch (e) {
      debugPrint('Error searching articles: $e');
      emit(SearchError('Failed to search articles. Please try again.'));
    }
  }

  Future<void> fetchSuggestions() async {
    try {
      emit(SearchLoading());
      final articles = await NetworkHandler.getTopHeadlines(country: 'us');
      debugPrint('Fetched ${articles.length} suggestions');
      emit(SearchSuggestions(articles));
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      emit(SearchError('Failed to load suggestions. Please try again.'));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
