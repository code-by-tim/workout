import 'package:flutter/foundation.dart';
import 'package:workout/model/workout.dart';

class SessionModel extends ChangeNotifier {
  List<Workout> activeWorkouts = [];
  int currentWorkoutIndex = -1;
}
