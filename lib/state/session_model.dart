import 'package:flutter/foundation.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/workout.dart';

class SessionModel extends ChangeNotifier {
  List<Workout> workouts = [];
  late Workout currentWorkout;
  int currentWorkoutID = -1;
  int currentExerciseID = -1;

  // The list index of the current workout
  get cwIndex {
    return workouts.indexWhere((workout) => workout.id == currentWorkoutID);
  }

  /// Sets the current workout and optionally the current exercise.
  void setCurrentWorkout(int workoutID, [int? wantedExerciseID]) {
    currentWorkoutID = workoutID;
    currentWorkout =
        workouts.firstWhere((workout) => workout.id == currentWorkoutID);
    if (wantedExerciseID != null) {
      currentExerciseID = wantedExerciseID;
    }
  }

  /// Loads all workouts from the db and saves them in SessionModel.workouts
  Future loadWorkouts() async {
    this.workouts = await DBService.instance.readAllWorkouts();
    workouts.forEach((workout) {
      workout.initializeExercises();
    });
    notifyListeners();
  }

  /// Loads all Sets into the respective Exercise Variable
  Future initializeSets(int workoutID) async {
    if (!workouts[cwIndex].initializedSets) {
      workouts[cwIndex].initializeSets();
    }
  }
}
