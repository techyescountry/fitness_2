import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'start_workout_event.dart';
part 'start_workout_state.dart';

class StartWorkoutBloc extends Bloc<StartWorkoutEvent, StartWorkoutState> {
  int time = 0;
  StartWorkoutBloc() : super(StartWorkoutInitial()) {
    on<BackTappedEvent>((event, emit) async {
      emit(BackTappedState());
    });

    on<PlayTappedEvent>((event, emit) async {
      time = event.time;
      emit(PlayTimerState(time: event.time));
    });

    on<PauseTappedEvent>((event, emit) async {
      time = event.time;
      emit(PauseTimerState(currentTime: time));
    });
  }
}
