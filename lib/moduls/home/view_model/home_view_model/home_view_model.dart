import 'package:flutter/material.dart';

import '../../../../models/artical_data.dart';
import '../../../../models/source_data_model.dart';
import '../../../../network_handler/network_handler.dart';

class HomeViewModelProvider extends ChangeNotifier {
  List<SourceData> _sourcesList = [];
  List<ArticleData> _articlesList = [];
  int _selectedTab = 0;

  List<SourceData> get sourcesList => _sourcesList;

  List<ArticleData> get articlesList => _articlesList;

  int get selectedTab => _selectedTab;

  Future<void> getAllSources(String categoryId) async {
    try {
      _sourcesList = await NetworkHandler.getAllSources(categoryId);
      notifyListeners();
    } catch (e) {}
  }

  Future<void> getAllArticles() async {
    try {
      _articlesList = await NetworkHandler.getAllArticles(
        sourcesList[selectedTab].id,
      );
      notifyListeners();
    } catch (e) {}
  }

  void setSelectedTab(int index) {
    _selectedTab = index;
    getAllArticles();
    notifyListeners();
  }
}
