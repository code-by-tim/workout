import 'package:flutter/material.dart';

class Workout {
  Workout({this.id, required this.name, required this.iconID});

  int? id;
  String name;
  Icons iconID;

  Map<String, Object?> toMap() => {
        WorkoutColumn.id: id,
        WorkoutColumn.name: name,
        WorkoutColumn.emoji: iconID.toString(),
      };
}

/// Provides the names for the columns in the workout database-table
class WorkoutColumn {
  static final String id = 'id';
  static final String name = 'name';
  static final String emoji = 'emoji';
}
