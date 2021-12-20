import 'package:flutter/material.dart';
import 'package:workout/model/exercise.dart';

// IsInDB is used to distinguish later when saving wether I need to update the db
// or if I have to put it in the state model
class EditExercise extends StatelessWidget {
  const EditExercise({Key? key, required this.exercise, required this.isInDB})
      : super(key: key);

  final Exercise exercise;
  final bool isInDB;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Hello")),
    );
  }

  /// If isInDB == true, save to the db, otherwise dont do anything (will be saved
  /// later in edit_workout class)
  void safeChanges() {}
}
