import 'package:flutter/material.dart';
import 'package:workout/pages/app_settings.dart';
import 'package:workout/pages/edit_workout.dart';

enum MenuOptions { AddWorkout, AppSettings }

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key, required this.refreshWorkouts}) : super(key: key);

  final Future<dynamic> Function() refreshWorkouts;

  @override
  Widget build(BuildContext context) {
    void _handleSelection(value) async {
      switch (value) {
        case MenuOptions.AddWorkout:
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditWorkout(workoutID: -1)));
          refreshWorkouts();
          print("refreshWorkouts called");
          break;
        case MenuOptions.AppSettings:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AppSettings()));
          break;
        default:
      }
    }

    return PopupMenuButton(
      icon: Icon(Icons.menu),
      onSelected: _handleSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          value: MenuOptions.AddWorkout,
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text("Workout"),
          ),
        ),
        const PopupMenuItem(
          value: MenuOptions.AppSettings,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
          ),
        ),
      ],
    );
  }
}
