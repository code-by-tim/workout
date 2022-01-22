import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/menus/exercise_view_menu.dart';
import 'package:workout/model/exercise.dart';
import 'package:workout/state/session_model.dart';

class ExerciseView extends StatefulWidget {
  ExerciseView({Key? key}) : super(key: key);

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  late Exercise exercise;
  bool isLoading = false;

  Future refreshExercise() async {
    setState(() => isLoading = true);

    await Provider.of<SessionModel>(context, listen: false)
        .reloadExercise(exercise.id!);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    exercise =
        Provider.of<SessionModel>(context, listen: false).currentExercise;

    return Scaffold(
      body: Consumer<SessionModel>(
        builder: (_, model, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(exercise.name),
              automaticallyImplyLeading: false,
              actions: [ExerciseViewMenu()],
            ),
            // if first time on this exercise page, show Button to edit_exercise
            body: exercise.controlledByUser
                ? Center(child: Text("Exercise has been configured yet"))
                : Center(child: Text("Exercise has not been configured yet")),
          );
        },
      ),
    );
  }
}
