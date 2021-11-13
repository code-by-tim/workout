import 'package:flutter/material.dart';
import 'package:workout/db_service.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/workout.dart';

class EditWorkout extends StatefulWidget {
  final int workoutID;

  /// Pass a negative value to the constructor when a new workout should be created
  const EditWorkout({Key? key, required this.workoutID}) : super(key: key);

  @override
  _EditWorkoutState createState() => _EditWorkoutState();
}

class _EditWorkoutState extends State<EditWorkout> {
  late Workout _workout;
  late List<Exercise> _exercises;

  TextEditingController _titleController = new TextEditingController();
  List<TextEditingController> _exerciseControllers = [];

  bool _isLoading = false;
  bool _triedSavingWithoutExercises = false;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    loadWorkout();
  }

  /// Initializes the workout and exercises variables as well as the controllers
  Future loadWorkout() async {
    setState(() => _isLoading = true);

    if (widget.workoutID < 0) {
      this._workout = new Workout(name: "");
      this._exercises = [];
    } else {
      this._workout = await DBService.instance.readWorkout(widget.workoutID);
      try {
        this._exercises =
            await DBService.instance.readExercisesOfWorkout(widget.workoutID);
      } catch (e) {}
    }

    _titleController.text = _workout.name;
    _exercises.forEach((exercise) {
      _exerciseControllers.add(new TextEditingController(text: exercise.name));
    });
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
          IconButton(
              onPressed:
                  /*_exercises.isEmpty
                  ? () {
                      setState(() {
                        _triedSavingWithoutExercises = true;
                      });
                    }
                  : */
                  safeWorkout,
              icon: Icon(Icons.save))
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
                  _exerciseControllers.length == 0
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
                            itemCount: _exerciseControllers.length,
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                var item =
                                    _exerciseControllers.removeAt(oldIndex);
                                _exerciseControllers.insert(newIndex, item);
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
                controller: _exerciseControllers[index],
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
            Icon(Icons.tune),
            SizedBox(width: 15),
            IconButton(
                onPressed: () {
                  setState(() {
                    _exerciseControllers.removeAt(index);
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

  /// Adds one element to _exerciseControllers
  void _addExercise() {
    if (_isLoading) return;
    setState(() {
      _exerciseControllers.add(TextEditingController());
    });
  }

  /// Safes the given workout to the database
  // Prevents the saving to the db and popping the page if the workout
  // title or the exercises are missing.
  void safeWorkout() {
    if (_isLoading) return;

    if (_formKey.currentState!.validate()) {
      if (_exerciseControllers.isEmpty) {
        setState(() {
          _triedSavingWithoutExercises = true;
        });
        return;
      }

      _workout.name = _titleController.text;

      // Create exercises
      for (var i = 0; i < _exerciseControllers.length; i++) {
        if (i >= _exercises.length) {
          _exercises.add(new Exercise(
              name: _exerciseControllers[i].text,
              description: "",
              pause: 120,
              scale: Scale.Weight,
              showReps: false,
              stepSize: 0.25));
        }
      }

      DBService.instance
          .createWorkout(workout: _workout, exercises: _exercises);
      Navigator.pop(context);
    }
  }
}
