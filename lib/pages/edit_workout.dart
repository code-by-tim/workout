import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/set.dart';
import 'package:workout/model/workout.dart';
import 'package:workout/state/exercise_editing_model.dart';
import 'package:workout/state/session_model.dart';

import 'edit_exercise.dart';

/// Class to bind exercise to its controller
/// Updates the exercise title upon changes to the controller
class ExConPair {
  Exercise exercise;
  TextEditingController controller;
  bool isNew;
  bool wasModified = false;

  ExConPair(this.exercise, this.controller, {this.isNew = true}) {
    this.controller.addListener(() {
      this.exercise.name = this.controller.text;
      this.wasModified = true;
    });
  }
}

class EditWorkout extends StatefulWidget {
  final int workoutID; //if set to negative number, a new workout is created.
  const EditWorkout({Key? key, required this.workoutID}) : super(key: key);
  const EditWorkout.createNew({Key? key}) : this.workoutID = -1;

  @override
  _EditWorkoutState createState() => _EditWorkoutState();
}

class _EditWorkoutState extends State<EditWorkout> {
  late Workout _workout;
  bool _workoutWasModified = false;
  TextEditingController _titleController = new TextEditingController();

  List<ExConPair> _exConPairs = [];
  List<int> deletedExerciseIDs = [];

  bool _isLoading = false;
  bool _triedSavingWithoutExercises = false;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    // Remember if workout was modified for the saving-method
    this._titleController.addListener(() {
      this._workoutWasModified = true;
    });
    loadWorkout();
  }

  /// Initializes the workout and exercises variables as well as the controllers
  Future loadWorkout() async {
    setState(() => _isLoading = true);

    if (widget.workoutID < 0) {
      // new Workout should be created
      this._workout = new Workout(name: "");
    } else {
      // existing workout is edited
      this._workout =
          Provider.of<SessionModel>(context, listen: false).currentWorkout;
      try {
        List<Exercise> _exercise = this._workout.exercises;
        _exercise.forEach((exercise) {
          _exConPairs.add(new ExConPair(
              exercise, new TextEditingController(text: exercise.name),
              isNew: false));
        });
      } catch (e) {}
    }

    _titleController.text = _workout.name;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.cancel)),
          IconButton(onPressed: safeWorkout, icon: Icon(Icons.save))
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: _addExercise, child: Icon(Icons.add)),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  // Workout title
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(fontSize: 30),
                    decoration: const InputDecoration(hintText: 'New workout'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a workout name';
                      }
                      return null;
                    },
                  ),
                  // Give note when no exercises yet
                  _exConPairs.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "No exercises created yet. Click + to add one.",
                              style: _triedSavingWithoutExercises
                                  ? TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)
                                  : null,
                            ),
                          ),
                        )
                      :
                      // Exercises
                      Expanded(
                          child: ReorderableListView.builder(
                            itemBuilder: _buildExerciseListTile,
                            itemCount: _exConPairs.length,
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                var item = _exConPairs.removeAt(oldIndex);
                                _exConPairs.insert(newIndex, item);
                              });
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  /// Returns an editable ListTile.
  /// The keys of the tiles start from 1 (not 0)!
  Widget _buildExerciseListTile(context, index) {
    int shownIndex = index + 1;
    return Card(
      key: Key('$index'),
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$shownIndex.', style: TextStyle(fontSize: 20)),
            SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: _exConPairs[index].controller,
                decoration: InputDecoration(
                  hintText: 'Exercise $index',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 15),
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditExercise(
                                exerciseToUpdate: _exConPairs[index].exercise,
                                safeToDBDirectly: false,
                              )));
                  if (Provider.of<ExerciseEditingModel>(context, listen: false)
                      .updateRequested) {
                    _exConPairs[index].exercise =
                        Provider.of<ExerciseEditingModel>(context,
                                listen: false)
                            .updatedExercise;
                    // update Exercise title (it might have been changed in the edit_exercise view)
                    _exConPairs[index].controller.text =
                        _exConPairs[index].exercise.name;
                  }
                },
                icon: Icon(Icons.tune)),
            SizedBox(width: 15),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (!_exConPairs[index].isNew) {
                      deletedExerciseIDs.add(_exConPairs[index].exercise.id!);
                    }
                    _exConPairs.removeAt(index);
                  });
                },
                icon: Icon(Icons.delete)),
            SizedBox(width: 15),
            Icon(Icons.drag_handle),
          ],
        ),
      ),
    );
  }

  /// Adds one element to _exConPairs
  void _addExercise() {
    if (_isLoading) return;
    setState(() {
      _exConPairs.add(new ExConPair(
          new Exercise(
              name: "",
              description: "",
              workoutFK: _workout.id,
              pause: 120,
              scale: Scale.Weight,
              showReps: false,
              stepSize: 0.25),
          new TextEditingController()));
    });
  }

  /// Safes the given workout to the database
  // Prevents the saving to the db and popping the page if the workout
  // title or the exercises are missing.
  void safeWorkout() {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      if (_exConPairs.isEmpty) {
        setState(() {
          _triedSavingWithoutExercises = true;
        });
        return;
      }

      if (widget.workoutID < 0) {
        //If workout is new
        _workout.name = _titleController.text;

        List<Exercise> _exercises = [];
        _exConPairs.forEach((exConPair) {
          _exercises.add(exConPair.exercise);
        });

        DBService.instance
            .createWorkout(workout: _workout, exercises: _exercises);
      } else {
        // if workout already exists in DB:
        // update workout and its exercises if necessary
        if (_workoutWasModified) {
          _workout.name = _titleController.text;
          DBService.instance.updateWorkout(_workout);
          Provider.of<SessionModel>(context, listen: false)
              .reloadWorkout(_workout.id!);
        }

        _exConPairs.forEach((pair) {
          if (pair.isNew) {
            // exercise newly created, not existend in DB
            DBService.instance.createExercise(pair.exercise);
            int index = Provider.of<SessionModel>(context, listen: false)
                .getWorkoutIndex(_workout.id!);
            Provider.of<SessionModel>(context, listen: false)
                .workouts[index]
                .exercises
                .add(pair.exercise);
          } else if (pair.wasModified) {
            // exercise exists in DB
            DBService.instance.updateExercise(pair.exercise);
            Provider.of<SessionModel>(context, listen: false)
                .reloadExercise(pair.exercise.id!);
          }
        });

        deletedExerciseIDs.forEach((id) {
          Provider.of<SessionModel>(context, listen: false).deleteExercise(id);
        });
      }

      Navigator.pop(context);
    }
  }
}
