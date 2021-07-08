import 'package:flutter/material.dart';

class Workout {
  Workout({required this.name, required this.iconID});

  int? id;
  String name;
  Icons iconID;

  // The String identifiers here must be identical to the column names of
  // the corresponding sqlite table
  Map<String, Object?> toMap() =>
      {'id': id, 'name': name, 'emoji': iconID.toString()};
}
