import 'package:bloc/bloc.dart';
import 'package:fitness_2/core/const/data_constants.dart';
import 'package:fitness_2/core/const/global_constants.dart';
import 'package:fitness_2/core/service/data_service.dart';
import 'package:fitness_2/data/workout_data.dart';

import 'package:meta/meta.dart';
/* always import meta.dart in bloc file to advoid 
this error in event and state files "Undefined name 'immutable' used as an annotation.
Try defining the name or importing it from another library."
 */
part 'workouts_event.dart';
part 'workouts_state.dart';

class WorkoutsBloc extends Bloc<WorkoutsEvent, WorkoutsState> {
  List<WorkoutData> workouts = DataConstants.workouts;
  WorkoutsBloc() : super(WorkoutsInitial()) {
    on<WorkoutsInitialEvent>((event, emit) async {
      GlobalConstants.workouts = await DataService.getWorkoutsForUser();
      for (int i = 0; i < workouts.length; i++) {
        final workoutsUserIndex =
            GlobalConstants.workouts.indexWhere((w) => w.id == workouts[i].id);
        if (workoutsUserIndex != -1) {
          workouts[i] = GlobalConstants.workouts[workoutsUserIndex];
        }
      }
      emit(ReloadWorkoutsState(workouts: workouts));
    });

    on<CardTappedEvent>((event, emit) async {
      emit(CardTappedState(workout: event.workout));
    });
  }
}
