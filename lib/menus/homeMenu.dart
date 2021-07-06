import 'package:flutter/material.dart';

enum MenuOptions { AddWorkout, AppSettings }

class HomePopUpMenu extends StatelessWidget {
  const HomePopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  void _handleSelection(value) {
    switch (value) {
      case MenuOptions.AddWorkout:
        break;
      case MenuOptions.AppSettings:
        break;
      default:
    }
  }
}
