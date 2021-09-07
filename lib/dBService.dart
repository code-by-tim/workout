import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/set.dart';
import 'package:workout/model/workout.dart';

enum OPResult { Success, Error }

class DBService {
  static DBService instance = DBService();
  static Database? _database;

  final String _createWorkoutTable = 'CREATE TABLE workout ('
      '${WorkoutColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,'
      '${WorkoutColumn.name} TEXT,'
      '${WorkoutColumn.emoji} TEXT);';

  final String _createExerciseTable = 'CREATE TABLE exercise ('
      '${ExerciseColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,'
      '${ExerciseColumn.workout} INTEGER,'
      '${ExerciseColumn.name} TEXT,'
      '${ExerciseColumn.description} TEXT,'
      '${ExerciseColumn.pause} INTEGER,'
      '${ExerciseColumn.scale} INTEGER,' //0=Weight, 1=Reps, 2=Time
      '${ExerciseColumn.showReps} BOOLEAN,'
      '${ExerciseColumn.stepSize} DOUBLE,'
      'FOREIGN KEY (workout) REFERENCES workout(id));';

  final String _createSetTable = 'CREATE TABLE set ('
      '${SetColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT,'
      '${SetColumn.exercise} INTEGER,'
      '${SetColumn.weight} DOUBLE,'
      '${SetColumn.reps} INTEGER,'
      '${SetColumn.duration} INTEGER,'
      'FOREIGN KEY (exercise) REFERENCES exercise(id));';

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'workout.db'),
      version: 1,
      onCreate: _createDB,
    );
    return db;
  }

  Future _createDB(Database db, int version) {
    return db
        .execute('$_createWorkoutTable $_createExerciseTable $_createSetTable');
  }

// CREATE Functions ------------------------------------------------------------
  /// Inserts a workout and optionally also its exercises
  Future<OPResult> createWorkout(
      {required Workout workout, List<Exercise>? exercises}) async {
    final Database db = await instance.database;

    int workoutID = await db.insert('workout', workout.toMap());

    if (exercises != null && workoutID != 0) {
      for (Exercise exercise in exercises) {
        exercise.workoutFK = workoutID;
        await db.insert('exercise', exercise.toMap());
      }
    }

    if (workoutID != 0) {
      return OPResult.Success;
    } else {
      return OPResult.Error;
    }
  }

  /// Inserts an Exercise in the database and assigns the generated and
  /// returned ID to the exercises' id.
  Future<OPResult> createExercise(Exercise exercise) async {
    final Database db = await instance.database;

    int returnedID = await db.insert('exercise', exercise.toMap());

    if (returnedID != 0) {
      exercise.id = returnedID;
      return OPResult.Success;
    } else {
      return OPResult.Error;
    }
  }

  /// Inserts a Set in the database and assigns the generated and
  /// returned ID to the sets' id.
  Future<OPResult> createSet(Set set) async {
    final Database db = await instance.database;

    int returnedID = await db.insert('set', set.toMap());

    if (returnedID != 0) {
      set.id = returnedID;
      return OPResult.Success;
    } else {
      return OPResult.Error;
    }
  }

// READ Functions --------------------------------------------------------------
  /// Needed
  /// Returns the workout with the specified id.
  /// If not found throws an exception
  Future<Workout> readWorkout(int id) async {
    final Database db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'workout',
      columns: WorkoutColumn.allNames,
      where: '${WorkoutColumn.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Workout.fromMap(maps.first);
    } else {
      throw Exception('Workout with ID=$id not found');
    }
  }

  Future<List<Exercise>> readExercisesOfWorkout(int workoutID) async {
    final Database db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'exercise',
      columns: ExerciseColumn.allNames,
      where: '${ExerciseColumn.workout} = ?',
      whereArgs: [workoutID],
    );

    if (maps.isNotEmpty) {
      List<Exercise> exercises = [];
      maps.forEach((map) {
        exercises.add(Exercise.fromMap(map));
      });
      return exercises;
    } else {
      throw Exception('Exercises of workout with ID=$workoutID not found');
    }
  }

  /// Returns a list of all workouts in the database
  Future<List<Workout>> readAllWorkouts() async {
    final Database db = await instance.database;

    final maps = await db.query('workout');
    return maps.map((map) => Workout.fromMap(map)).toList();
  }
}
