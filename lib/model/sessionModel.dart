import 'package:flutter/foundation.dart';
import 'package:workout/dBService.dart';
import 'package:workout/model/workout.dart';

class SessionModel extends ChangeNotifier {
  List<Workout> activeWorkouts = [];
  int currentWorkoutID = -1;

  /// Initializes the workout with its exercises and
  /// the sets of those exercises.
  /// Updates the respective variables of the SessionModel.
  void initializeFullWorkoutModel(int workoutID,
      [int? wantedExerciseID]) async {
    currentWorkoutID = workoutID;
    Workout workout = await DBService.instance.readWorkout(workoutID);
    activeWorkouts.add(workout);
    await workout.initializeExercises();
    workout.exercises.forEach((exercise) {
      exercise.initializeSets();
    });
  }
}
