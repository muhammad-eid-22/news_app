part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class ChangeSelectedTapIndexState extends HomeState {
  ChangeSelectedTapIndexState();
}

// Sources

class LoadingGetAllSourcesState extends HomeState {}

class ErrorGetAllSourcesState extends HomeState {}

class SuccessGetAllSourcesState extends HomeState {
  final List<SourceData> sourcesList;

  SuccessGetAllSourcesState(this.sourcesList);
}

// Articles

class LoadingGetAllArticlesState extends HomeState {}

class LoadingMoreArticlesState extends HomeState {}

class ErrorGetAllArticlesState extends HomeState {}

class SuccessGetAllArticlesState extends HomeState {
  final List<ArticleData> articlesList;

  SuccessGetAllArticlesState(this.articlesList);
}
