import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/state/exercise_editing_model.dart';
import 'package:workout/state/session_model.dart';

// IsInDB is used to distinguish later when saving wether I need to update the db
// or if I have to put it in the state model
class EditExercise extends StatelessWidget {
  EditExercise(
      {Key? key,
      required this.exerciseToUpdate,
      required this.safeToDBDirectly})
      : tempExercise = new Exercise(
            id: exerciseToUpdate.id,
            workoutFK: exerciseToUpdate.workoutFK,
            controlledByUser: exerciseToUpdate.controlledByUser,
            name: exerciseToUpdate.name,
            description: exerciseToUpdate.description,
            pause: exerciseToUpdate.pause,
            scale: exerciseToUpdate.scale,
            showReps: exerciseToUpdate.showReps,
            stepSize: exerciseToUpdate.stepSize),
        super(key: key);

  final Exercise exerciseToUpdate;
  final Exercise tempExercise;
  final bool safeToDBDirectly;

  @override
  Widget build(BuildContext context) {
    /// safes updates to DB or puts the updated exercise in the ExerciseEditingModel
    void _safeChanges() {
      tempExercise.controlledByUser = true;
      if (safeToDBDirectly) {
        DBService.instance.updateExercise(tempExercise);
        Provider.of<SessionModel>(context, listen: false)
            .reloadExercise(tempExercise.id!);
      } else {
        Provider.of<ExerciseEditingModel>(context, listen: false)
            .updatedExercise = tempExercise;
      }
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel)),
          IconButton(onPressed: _safeChanges, icon: Icon(Icons.save))
        ],
      ),
    );
  }
}
