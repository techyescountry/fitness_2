import 'package:bloc/bloc.dart';
import 'package:fitness_2/data/workout_data.dart';
import 'package:meta/meta.dart';

part 'workout_details_event.dart';
part 'workout_details_state.dart';

class WorkoutDetailsBloc
    extends Bloc<WorkoutDetailsEvent, WorkoutDetailsState> {
  late WorkoutData workout;
  WorkoutDetailsBloc() : super(WorkoutDetailsInitial()) {
    on<WorkoutDetailsInitialEvent>((event, emit) async {
      workout = event.workout;
      emit(ReloadWorkoutDetailsState(workout: workout));
    });

    on<BackTappedEvent>((event, emit) async {
      emit(BackTappedState());
    });

    on<StartTappedEvent>((event, emit) async {
      emit(StartTappedState(
        workout: event.workout ?? workout,
        index: event.index ?? 0,
        isReplace: event.isReplace,
      ));
    });
  }
}
