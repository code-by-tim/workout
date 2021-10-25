import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/dBService.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/sessionModel.dart';
import 'package:workout/model/workout.dart';
import 'package:workout/pages/exerciseView.dart';

class WorkoutTile extends StatefulWidget {
  const WorkoutTile({Key? key, required this.workout}) : super(key: key);

  final Workout workout;

  @override
  _WorkoutTileState createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  bool isExtended = false;
  bool isLoadingExercises = false;
  List<Exercise>? exercises;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: onWorkoutTap,
                child: Row(
                  children: [
                    isExtended
                        ? Icon(Icons.keyboard_arrow_up)
                        : Icon(Icons.keyboard_arrow_down),
                    Expanded(
                        child: Text(
                      widget.workout.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    )),
                    isExtended
                        ? Icon(Icons.keyboard_arrow_up)
                        : Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
              isExtended
                  ? isLoadingExercises
                      ? CircularProgressIndicator()
                      : Column(children: _getExtendedPart())
                  : Container(height: 0.0)
            ],
          ),
        ),
      ),
    );
  }

  /// Open or close the Card-Extension after the title or arrow has been
  /// clicked
  void onWorkoutTap() async {
    if (isExtended) {
      setState(() {
        isExtended = false;
      });
    } else {
      setState(() {
        isLoadingExercises = true;
        isExtended = true;
      });
      this.exercises =
          await DBService.instance.readExercisesOfWorkout(widget.workout.id!);
      setState(() {
        isLoadingExercises = false;
      });
    }
  }

  /// Returns the bottom part of a workout Tile (The part, that is only visible when extended).
  /// Handles navigation to the exerciseView
  List<Widget> _getExtendedPart() {
    List<Widget> extensionBody = [
      Divider(indent: 75, endIndent: 75, thickness: 2, color: Colors.white)
    ];

    exercises!.forEach((exercise) {
      extensionBody.add(GestureDetector(
        onTap: () {
          // updated SessionModel and push ExerciseView
          assert(exercise.workoutFK != null);
          assert(exercise.id != null);
          Provider.of<SessionModel>(context, listen: false)
              .initializeFullWorkoutModel(exercise.workoutFK!, exercise.id);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ExerciseView()));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Text(exercise.name, style: TextStyle(fontSize: 20))),
              Icon(Icons.arrow_forward_rounded)
            ],
          ),
        ),
      ));
    });
    return extensionBody;
  }
}
