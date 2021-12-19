import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/menus/exercise_view_menu.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/state/session_model.dart';

class ExerciseView extends StatelessWidget {
  ExerciseView({Key? key}) : super(key: key);

  late Exercise exercise;

  @override
  Widget build(BuildContext context) {
    exercise =
        Provider.of<SessionModel>(context, listen: false).currentExercise;

    return Scaffold(
      body: Consumer<SessionModel>(
        builder: (_, model, __) {
          // if first time on this exercise page, show configuration options
          if (!exercise.controlledByUser) {
            return Scaffold(
              appBar: AppBar(
                title: Text(exercise.name),
                automaticallyImplyLeading: false,
                actions: [ExerciseViewMenu()],
              ),
              body: Center(child: Text("Exercise has not been configured yet")),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(exercise.name),
                automaticallyImplyLeading: false,
              ),
              body: Center(child: Text("Exercise has been configured!!")),
            );
          }
        },
      ),
    );
  }
}
