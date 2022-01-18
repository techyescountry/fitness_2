import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_2/core/const/data_constants.dart';
import 'package:fitness_2/core/service/auth_service.dart';
import 'package:fitness_2/core/service/data_service.dart';
import 'package:fitness_2/core/service/user_storage_service.dart';
import 'package:fitness_2/data/exercise_data.dart';
import 'package:fitness_2/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<WorkoutData> workouts = <WorkoutData>[];
  List<ExerciseData> exercises = <ExerciseData>[];
  int timeSent = 0;

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(
        (HomeInitialEvent event, Emitter<HomeState> emit) async {
      workouts = await DataService.getWorkoutsForUser();
      emit(WorkoutsGotState(workouts: workouts));
    });

    on<ReloadImageEvent>(
        (ReloadImageEvent event, Emitter<HomeState> emit) async {
      String? photoURL = await UserStorageService.readSecureData('image');
      if (photoURL == null) {
        photoURL = AuthService.auth.currentUser?.photoURL;
        photoURL != null
            ? await UserStorageService.writeSecureData('image', photoURL)
            : print('no image');
      }
      emit(ReloadImageState(photoURL: photoURL));
    });

    on<ReloadDisplayNameEvent>(
        (ReloadDisplayNameEvent event, Emitter<HomeState> emit) async {
      final User? user = FirebaseAuth.instance.currentUser;
      final displayName = user?.displayName ?? "No Username";
      // orig code: final displayName = await UserStorageService.readSecureData('name');
      print('this is 2nd $displayName'); //NOTE: no print here
      emit(ReloadDisplayNameState(displayName: displayName));
    });
  }

  int getProgressPercentage() {
    final completed = workouts
        .where((w) =>
            (w.currentProgress ?? 0) > 0 && w.currentProgress == w.progress)
        .toList();
    final percent01 =
        completed.length.toDouble() / DataConstants.workouts.length.toDouble();
    final percent = (percent01 * 100).toInt();
    return percent;
  }

  int? getFinishedWorkouts() {
    final completedWorkouts =
        workouts.where((w) => w.currentProgress == w.progress).toList();
    return completedWorkouts.length;
  }

  int? getInProgressWorkouts() {
    final completedWorkouts = workouts.where(
        (w) => (w.currentProgress ?? 0) > 0 && w.currentProgress != w.progress);
    return completedWorkouts.length;
  }

  int? getTimeSent() {
    for (final WorkoutData workout in workouts) {
      exercises.addAll(workout.exerciseDataList!);
    }
    final exercise = exercises.where((e) => e.progress == 1).toList();
    for (var e in exercise) {
      timeSent += e.minutes!;
    }
    return timeSent;
  }
}
