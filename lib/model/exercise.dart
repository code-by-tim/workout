enum Scale { Weight, Reps, Time }

class Exercise {
  Exercise(
      {this.id,
      required this.workoutFK,
      required this.name,
      required this.description,
      required this.pause,
      required this.scale,
      required this.showReps,
      required this.stepSize});

  int? id;
  int workoutFK;
  String name;
  String description;
  int pause;
  Scale scale;
  bool showReps;
  double stepSize;

  Map<String, Object?> toMap() => {
        ExerciseColumn.id: id,
        ExerciseColumn.workout: workoutFK,
        ExerciseColumn.name: name,
        ExerciseColumn.description: description,
        ExerciseColumn.pause: pause,
        ExerciseColumn.scale: scale,
        ExerciseColumn.showReps: showReps,
        ExerciseColumn.stepSize: stepSize,
      };
}

/// Provides the names for the columns in the exercise database-table
class ExerciseColumn {
  static final String id = 'id';
  static final String workout = 'workout';
  static final String name = 'name';
  static final String description = 'description';
  static final String pause = 'pause';
  static final String scale = 'scale';
  static final String showReps = 'showReps';
  static final String stepSize = 'stepSize';
}
