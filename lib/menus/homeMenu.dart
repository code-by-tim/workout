import 'package:flutter/material.dart';
import 'package:workout/pages/appSettings.dart';
import 'package:workout/pages/editWorkout.dart';

enum MenuOptions { AddWorkout, AppSettings }

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleSelection(value) {
      switch (value) {
        case MenuOptions.AddWorkout:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditWorkout(workoutID: -1)));
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
