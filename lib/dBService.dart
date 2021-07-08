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

  final String createWorkoutTable = 'CREATE TABLE workout ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'name TEXT,'
      'emoji TEXT);';

  final String createExerciseTable = 'CREATE TABLE exercise ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'workout INTEGER,'
      'name TEXT,'
      'description TEXT,'
      'pause INTEGER,'
      'scale INTEGER,' //0=Weight, 1=Reps, 2=Time
      'showReps BOOLEAN,'
      'stepSize DOUBLE,'
      'FOREIGN KEY (workout) REFERENCES workout(id));';

  final String createSetTable = 'CREATE TABLE set ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'exercise INTEGER,'
      'weight DOUBLE,'
      'reps INTEGER,'
      'duration INTEGER,'
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
        .execute('$createWorkoutTable $createExerciseTable $createSetTable');
  }

  Future<OPResult> insert(
      {required Workout workout,
      List<Exercise>? exercises,
      List<Set>? sets}) async {
    final Database db = await instance.database;

    int workoutID = await db.insert('workout', workout.toMap());

    if (exercises != null) {
      for (Exercise exercise in exercises) {
        await db.insert('exercise', exercise.toMap());
      }
    }

    if (sets != null) {
      for (Set set in sets) {
        await db.insert('set', set.toMap());
      }
    }

    if (workoutID.runtimeType == int) {
      return OPResult.Success;
    } else {
      return OPResult.Error;
    }
  }
}