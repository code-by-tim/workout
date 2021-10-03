import 'package:flutter/material.dart';
import 'package:workout/dBService.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/model/workout.dart';

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
    return Card(
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
                ? Column(children: [Text('Extended')])
                : Container(height: 0.0)
          ],
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
}
