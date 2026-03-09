import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/source_data_model.dart';
import '../../../../network_handler/network_handler.dart';

part 'sources_state.dart';

class SourcesCubit extends Cubit<SourcesState> {
  SourcesCubit() : super(SourcesInitial());
  List<SourceData> _sourcesList = [];
  int _selectedTab = 0;

  List<SourceData> get sourcesList => _sourcesList;

  int get selectedTab => _selectedTab;

  void setSelectedTab(int index) {
    _selectedTab = index;
    emit(SourcesStateUpdated());
  }

  Future<void> getAllSources(String categoryId) async {
    try {
      emit(LoadingGetSources());
      _sourcesList = await NetworkHandler.getAllSources(categoryId);
      emit(SuccessGetSources(_sourcesList));
    } catch (e) {
      emit(ErrorGetSources());
    }
  }
}
