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
        this.titleController =
            new TextEditingController(text: exerciseToUpdate.name),
        super(key: key);

  final Exercise exerciseToUpdate;
  final Exercise tempExercise;
  final TextEditingController titleController;
  final bool safeToDBDirectly;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /// safes updates to DB or puts the updated exercise in the ExerciseEditingModel
    void _safeChanges() {
      tempExercise.controlledByUser = true;

      tempExercise.name = titleController.text;
      if (safeToDBDirectly) {
        DBService.instance.updateExercise(tempExercise);
        Provider.of<SessionModel>(context, listen: false)
            .reloadExercise(tempExercise.id!);
      } else {
        Provider.of<ExerciseEditingModel>(context, listen: false)
            .updatedExercise = tempExercise;
      }
      Provider.of<ExerciseEditingModel>(context, listen: false)
          .updateRequested = true;
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ExerciseEditingModel>(context, listen: false)
                    .updateRequested = false;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel)),
          IconButton(onPressed: _safeChanges, icon: Icon(Icons.save))
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              // Exercise title
              TextFormField(
                controller: titleController,
                style: TextStyle(fontSize: 30),
                decoration: const InputDecoration(hintText: 'Exercise name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
            ],
          )),
    );
  }
}
