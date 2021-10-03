import 'package:flutter/material.dart';

class Workout {
  Workout({this.id, required this.name});

  int? id;
  String name;

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
