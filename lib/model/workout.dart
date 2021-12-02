import 'package:flutter/material.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/exercise.dart';

class Workout {
  Workout({this.id, required this.name});

  int? id;
  String name;

  //These attributes are not safed in the db
  List<Exercise> exercises = [];
  int curExPosition = 0;
  bool initializedSets = false;

  // assigns the exercises of this workout to the exercises variable
  // in the correct order
  Future initializeExercises() async {
    assert(this.id != null);
    this.exercises = await DBService.instance.readExercisesOfWorkout(id!);
  }

  // Initializes the sets of each exercise
  Future initializeSets() async {
    this.exercises.forEach((exercise) async {
      await exercise.initializeSets();
    });
    initializedSets = true;
  }

  /// Returns a copy of the workout with the specified parameters changed
  Workout copyModify({int? id, String? name, IconData? iconID}) =>
      Workout(id: id ?? this.id, name: name ?? this.name);

  Map<String, Object?> toMap() => {
        WorkoutColumn.id: id,
        WorkoutColumn.name: name,
      };

  static Workout fromMap(Map<String, Object?> map) => Workout(
        id: map[WorkoutColumn.id] as int?,
        name: map[WorkoutColumn.name] as String,
      );
}

/// Provides the names for the columns in the workout database-table
class WorkoutColumn {
  static final String id = 'id';
  static final String name = 'name';

  static final List<String> allNames = [id, name];
}
