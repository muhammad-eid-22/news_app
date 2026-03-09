part of 'sources_cubit.dart';

@immutable
sealed class SourcesState {}

final class SourcesInitial extends SourcesState {}

class LoadingGetSources extends SourcesState {}

class ErrorGetSources extends SourcesState {}

class SuccessGetSources extends SourcesState {
  final List<SourceData> sourcesList;

  SuccessGetSources(this.sourcesList);
}

class SourcesStateUpdated extends SourcesState {}
