import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/set.dart';
import 'package:workout/state/exercise_editing_model.dart';
import 'package:workout/state/session_model.dart';

// IsInDB is used to distinguish later when saving wether I need to update the db
// or if I have to put it in the state model
class EditExercise extends StatefulWidget {
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
        this.descriptionController =
            new TextEditingController(text: exerciseToUpdate.description),
        super(key: key);

  final Exercise exerciseToUpdate;
  final Exercise tempExercise;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool safeToDBDirectly;

  @override
  State<EditExercise> createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  int setCount = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /// safes updates to DB or puts the updated exercise in the ExerciseEditingModel
    void _safeChanges() {
      widget.tempExercise.controlledByUser = true;

      widget.tempExercise.name = widget.titleController.text;
      widget.tempExercise.description = widget.descriptionController.text;
      if (widget.safeToDBDirectly) {
        DBService.instance.updateExercise(widget.tempExercise);
        Provider.of<SessionModel>(context, listen: false)
            .reloadExercise(widget.tempExercise.id!);

        // Safe added Sets to DB or delete if Sets were removed
        int setDifference = setCount - widget.exerciseToUpdate.sets.length;
        if (setDifference > 0) {
          Set setW = new Set(
              exerciseFK: widget.exerciseToUpdate.id!,
              weight: 50,
              reps: 10,
              duration: 20);
          for (var i = 0; i < setDifference; i++) {
            //Todo change createSet the sets to make a nice rising diagramm like in db_service.dart
            DBService.instance.createSet(setW);
          }
        } else if (setDifference < 0) {
          for (var i = 0; i < setDifference.abs(); i++) {
            Provider.of<SessionModel>(context, listen: false)
                .deleteSet(widget.exerciseToUpdate.id!);
          }
        }
      } else {
        widget.tempExercise.setCount = this.setCount;
        Provider.of<ExerciseEditingModel>(context, listen: false)
            .updatedExercise = widget.tempExercise;
        Provider.of<ExerciseEditingModel>(context, listen: false)
            .updateRequested = true;
      }
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
                controller: widget.titleController,
                style: TextStyle(fontSize: 30),
                decoration: const InputDecoration(hintText: 'Exercise name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
              // Exercise description
              TextFormField(
                controller: widget.descriptionController,
                decoration: const InputDecoration(hintText: 'Description...'),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("Number of Sets",
                          style: TextStyle(fontSize: 20))),
                  IconButton(
                      onPressed: () {
                        if (setCount > 0) {
                          setState(() {
                            setCount--;
                          });
                        }
                      },
                      icon: Icon(Icons.remove)),
                  Text('$setCount', style: TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          setCount++;
                        });
                      },
                      icon: Icon(Icons.add))
                ],
              ),

              // Exercise pause
              // Hierzu Number Picker pop up kreieren, dass ich dann auch
              // in der Exercise View wiederverwenden kann
            ],
          )),
    );
  }
}
