import 'package:flutter/material.dart';
import 'package:workout/model/exercise.dart';

// IsInDB is used to distinguish later when saving wether I need to update the db
// or if I have to put it in the state model
class EditExercise extends StatelessWidget {
  EditExercise({Key? key, required this.exerciseToUpdate, required this.isInDB})
      : tempExercise = new Exercise(
            name: exerciseToUpdate.name,
            description: exerciseToUpdate.description,
            pause: exerciseToUpdate.pause,
            scale: exerciseToUpdate.scale,
            showReps: exerciseToUpdate.showReps,
            stepSize: exerciseToUpdate.stepSize),
        super(key: key);

  final Exercise exerciseToUpdate;
  final Exercise tempExercise;
  final bool isInDB;

  @override
  Widget build(BuildContext context) {
    /// updates Exercise and if necessary saves updates to DB
    void _safeChanges() {
      //exerciseToUpdate = tempExercise; // das ist hier ist auch falsch. Ich
      // setze hier den Zeiger von exerciseToUpdate um, aber nicht den der ursprünglichen
      //Exercise

      if (isInDB) {
        // update this exercise in DB
      }
      Navigator.pop(context);
    }

    return Container(
      child: Center(child: Text("Hello")),
    );
  }
}
