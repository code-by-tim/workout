import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/model/sessionModel.dart';

class ExerciseView extends StatelessWidget {
  const ExerciseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Text(Provider.of<SessionModel>(context, listen: false)
              .currentWorkoutID
              .toString())),
    );
  }
}
