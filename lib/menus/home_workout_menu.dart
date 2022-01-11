import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/pages/app_settings.dart';
import 'package:workout/pages/edit_workout.dart';
import 'package:workout/state/session_model.dart';

enum MenuOptions { EditWorkout, DeleteWorkout }

class WorkoutContextMenu extends StatelessWidget {
  const WorkoutContextMenu(
      {Key? key, required this.workoutID, required this.refreshWorkouts})
      : super(key: key);

  final int workoutID;
  final Future<dynamic> Function() refreshWorkouts;

  @override
  Widget build(BuildContext context) {
    void _handleSelection(value) async {
      switch (value) {
        case MenuOptions.EditWorkout:
          Provider.of<SessionModel>(context, listen: false)
              .setCurrentWorkout(workoutID);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditWorkout(workoutID: workoutID)));
          //refreshWorkouts(); Unnecessary cause handled through provider and notifyListener.
          break;
        case MenuOptions.DeleteWorkout:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AppSettings()));
          break;
        default:
      }
    }

    return PopupMenuButton(
      tooltip: "Öffne Optionen",
      icon: Icon(Icons.more_horiz),
      onSelected: _handleSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          value: MenuOptions.EditWorkout,
          child: ListTile(
            leading: Icon(Icons.tune),
            title: Text("Workout bearbeiten"),
          ),
        ),
        const PopupMenuItem(
          value: MenuOptions.DeleteWorkout,
          child: ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text("Löschen"),
          ),
        ),
      ],
    );
  }
}
