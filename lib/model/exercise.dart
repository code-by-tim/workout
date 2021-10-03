enum Scale { Weight, Reps, Time }

class Exercise {
  Exercise(
      {this.id,
      this.workoutFK,
      this.controlledByUser = false,
      required this.name,
      required this.description,
      required this.pause,
      required this.scale,
      required this.showReps,
      required this.stepSize});

  int? id;
  int? workoutFK;
  bool controlledByUser;
  String name;
  String description;
  int pause;
  Scale scale;
  bool showReps;
  double stepSize;

  /// Returns a copy of the exercise with the specified parameters changed
  Exercise copyModify({
    int? id,
    int? workoutFK,
    bool? controlledByUser,
    String? name,
    String? description,
    int? pause,
    Scale? scale,
    bool? showReps,
    double? stepSize,
  }) =>
      Exercise(
          workoutFK: workoutFK ?? this.workoutFK,
          controlledByUser: controlledByUser ?? this.controlledByUser,
          name: name ?? this.name,
          description: description ?? this.description,
          pause: pause ?? this.pause,
          scale: scale ?? this.scale,
          showReps: showReps ?? this.showReps,
          stepSize: stepSize ?? this.stepSize);

  Map<String, Object?> toMap() => {
        ExerciseColumn.id: id,
        ExerciseColumn.workout: workoutFK,
        ExerciseColumn.controlledByUser: controlledByUser ? 1 : 0,
        ExerciseColumn.name: name,
        ExerciseColumn.description: description,
        ExerciseColumn.pause: pause,
        ExerciseColumn.scale: scale.index,
        ExerciseColumn.showReps: showReps ? 1 : 0,
        ExerciseColumn.stepSize: stepSize,
      };

  static Exercise fromMap(Map<String, Object?> map) => Exercise(
      id: map[ExerciseColumn.id] as int?,
      workoutFK: map[ExerciseColumn.workout] as int,
      controlledByUser: map[ExerciseColumn.controlledByUser] == 1,
      name: map[ExerciseColumn.name] as String,
      description: map[ExerciseColumn.description] as String,
      pause: map[ExerciseColumn.pause] as int,
      scale: _getScaleFromNumber(map[ExerciseColumn.scale] as int),
      showReps: map[ExerciseColumn.showReps] == 1,
      stepSize: map[ExerciseColumn.stepSize] as double);
}

Scale _getScaleFromNumber(int num) {
  switch (num) {
    case 0:
      return Scale.Weight;
    case 1:
      return Scale.Reps;
    default:
      return Scale.Time;
  }
}

/// Provides the names for the columns in the exercise database-table
class ExerciseColumn {
  static final String id = 'id';
  static final String workout = 'workout';
  static final String controlledByUser = 'controlledByUser';
  static final String name = 'name';
  static final String description = 'description';
  static final String pause = 'pause';
  static final String scale = 'scale';
  static final String showReps = 'showReps';
  static final String stepSize = 'stepSize';

  static final List<String> allNames = [
    id,
    workout,
    controlledByUser,
    name,
    description,
    pause,
    scale,
    showReps,
    stepSize
  ];
}
