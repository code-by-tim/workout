import 'package:flutter/foundation.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/workout.dart';

class SessionModel extends ChangeNotifier {
  List<Workout> workouts = [];
  late Workout currentWorkout;
  int currentExerciseID = -1;

  // The index of the current workout in the workouts-list.
  get cwIndex {
    return workouts.indexWhere((workout) => workout.id == currentWorkout.id);
  }

  get currentExercise {
    return currentWorkout.exercises
        .firstWhere((exercise) => exercise.id == currentExerciseID);
  }

  /// Returns the index of the workout in workouts[] that satisfies
  /// the specified test
  int getWorkoutIndex(int workoutID) {
    return workouts.indexWhere((workout) => workout.id == workoutID);
  }

  /// Sets the current workout and optionally the current exercise.
  /// Also initializes all sets of this workout if still necessary
  void setCurrentWorkout(int workoutID, [int? wantedExerciseID]) {
    currentWorkout = workouts.firstWhere((workout) => workout.id == workoutID);
    if (wantedExerciseID != null) {
      currentExerciseID = wantedExerciseID;
    }
    if (!currentWorkout.initializedSets) {
      currentWorkout.initializeSets();
    }
  }

  /// Loads all workouts from the db and saves them in SessionModel.workouts
  /// Calls notifyListeners()
  Future loadWorkouts() async {
    this.workouts = await DBService.instance.readAllWorkouts();
    workouts.forEach((workout) {
      workout.initializeExercises();
    });
    notifyListeners();
  }

  /// Get the exercises for a workout
  // Only call after loadWorkouts was called!
  List<Exercise> getExercisesOf(int workoutID) {
    Workout workout = workouts.firstWhere((element) => element.id == workoutID);
    return workout.exercises;
  }

  /// Loads an exercise from the db and overwrites the old exercise in the model.
  /// Only call this method from a point where the respective Exercise is in
  /// the currentWorkout Workout!
  /// Calls notifyListeners()
  Future reloadExercise(int exerciseID) async {
    int index = currentWorkout.exercises
        .indexWhere((exercise) => exercise.id == exerciseID);
    currentWorkout.exercises[index] =
        await DBService.instance.readExercise(exerciseID);
    notifyListeners();
  }

  /// Loads a workout from the db and overwrites the old workout in the model.
  /// If necessary, also the currentWorkout is updated.
  /// Calls notifyListeners()
  Future reloadWorkout(int workoutID) async {
    int index = workouts.indexWhere((workout) => workout.id == workoutID);
    List<Exercise> exercises = workouts[index].exercises;
    workouts[index] = await DBService.instance.readWorkout(workoutID);
    workouts[index].exercises = exercises;

    if (currentWorkout.id == workoutID) {
      currentWorkout = workouts[index];
    }
    notifyListeners();
  }

  /// Loads all Sets into the respective Workout Variable
  Future initializeSets(int workoutID) async {
    if (!workouts[workoutID].initializedSets) {
      workouts[workoutID].initializeSets();
    }
  }

  /// Deletes the exercise from the db and removes it from the model.
  /// Only call this method from a point where the respective Exercise is in
  /// the currentWorkout Workout!
  /// Calls notifyListeners()
  void deleteExercise(int exerciseID) {
    int index = currentWorkout.exercises
        .indexWhere((exercise) => exercise.id == exerciseID);
    currentWorkout.exercises.removeAt(index);
    DBService.instance.deleteExercise(exerciseID);
    notifyListeners();
  }

  /// Deletes the workout from the db and removes it from the model.
  // Calls notifyListeners()
  void deleteWorkout(int workoutID) {
    workouts.removeWhere((element) => element.id == workoutID);
    DBService.instance.deleteWorkout(workoutID);
    notifyListeners();
  }

  /// Deletes the last set of this exercise and removes it from the model.
  /// Only call this method from a point where the Exercise is in
  /// the currentWorkout Workout!
  /// Calls notifyListeners()
  void deleteSet(int exerciseID) {
    if (!currentWorkout.initializedSets) currentWorkout.initializeSets();
    Exercise exercise = currentWorkout.exercises
        .firstWhere((element) => element.id == exerciseID);
    DBService.instance.deleteSet(exercise.sets.last.id!);
    exercise.sets.removeLast();
  }
}
