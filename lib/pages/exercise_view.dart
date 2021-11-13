import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/state/session_model.dart';

class ExerciseView extends StatelessWidget {
  const ExerciseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Consumer<SessionModel>(
            builder: (_, model, __) => Text(model.currentWorkoutID.toString()),
          ),
        ));
  }
}
