import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tab_bar_event.dart';
part 'tab_bar_state.dart';

class TabBarBloc extends Bloc<TabBarEvent, TabBarState> {
  int currentIndex = 0;
  bool isSelected = false;
  TabBarBloc() : super(TabBarInitial()) {
    on<TabBarItemTappedEvent>((event, emit) async {
      currentIndex = event.index;
      emit(TabBarItemSelectedState(index: currentIndex));
    });
  }
}
