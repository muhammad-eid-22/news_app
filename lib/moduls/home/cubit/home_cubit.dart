import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/artical_data.dart';
import '../../../models/source_data_model.dart';
import '../../../network_handler/network_handler.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  List<ArticleData> _articlesList = [];
  List<SourceData> _sourcesList = [];
  int _selectedTab = 0;
  int _currentPage = 1;
  int _pageSize = 10;
  bool _hasMore = true;
  String? _currentSourceId;
  bool _isLoadingMore = false;

  List<ArticleData> get articlesList => _articlesList;
  List<SourceData> get sourcesList => _sourcesList;
  int get selectedTab => _selectedTab;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> getAllArticles([String? sourceId, bool reset = true]) async {
    try {
      if (reset) {
        _currentPage = 1;
        _articlesList.clear();
        _hasMore = false; // API doesn't support pagination, so no more pages
      }
      
      _currentSourceId = sourceId ?? 
          (_sourcesList.isNotEmpty ? _sourcesList[_selectedTab].id : null);
      
      if (_currentSourceId == null) {
        emit(ErrorGetAllArticlesState());
        return;
      }
      
      emit(LoadingGetAllArticlesState());
      
      final newArticles = await NetworkHandler.getAllArticles(_currentSourceId!);
      
      if (reset) {
        _articlesList = newArticles;
      } else {
        _articlesList.addAll(newArticles);
      }
      
      // Since API doesn't support pagination, we set hasMore to false
      _hasMore = false;
      emit(SuccessGetAllArticlesState(_articlesList));
    } catch (e) {
      emit(ErrorGetAllArticlesState());
    }
  }
  
  Future<void> loadMoreArticles() async {
    // Since API doesn't support pagination, this method does nothing
    // but we keep it for UI consistency
    if (!_hasMore || _isLoadingMore || _currentSourceId == null) return;
    
    // No pagination support from API, so we don't load more
    return;
  }

  void setSelectedTab(int index) {
    _selectedTab = index;
    emit(ChangeSelectedTapIndexState());
  }
  
  void setSourcesList(List<SourceData> sources) {
    _sourcesList = sources;
  }
  
  void resetPagination() {
    _currentPage = 1;
    _articlesList.clear();
    _hasMore = true;
    _isLoadingMore = false;
    _currentSourceId = null;
  }
}
