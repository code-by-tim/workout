import 'package:flutter/material.dart';
import 'package:workout/pages/edit_exercise.dart';

enum MenuOptions { ConfigureExercise }

class ExerciseViewMenu extends StatelessWidget {
  const ExerciseViewMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _handleSelection(value) {
      switch (value) {
        case MenuOptions.ConfigureExercise:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditExercise()));
          break;
        default:
      }
    }

    return PopupMenuButton(
        onSelected: _handleSelection,
        icon: Icon(Icons.menu),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                  value: MenuOptions.ConfigureExercise,
                  child: ListTile(
                    leading: Icon(Icons.tune),
                    title: Text("Übung bearbeiten"),
                  ))
            ]);
  }
}
