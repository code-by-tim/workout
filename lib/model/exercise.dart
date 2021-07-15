import 'package:workout/model/set.dart';

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

  /// Returns a copy of the exercise with the specified parameters changed
  Exercise copyModify({
    int? id,
    int? workoutFK,
    String? name,
    String? description,
    int? pause,
    Scale? scale,
    bool? showReps,
    double? stepSize,
  }) =>
      Exercise(
          workoutFK: workoutFK ?? this.workoutFK,
          name: name ?? this.name,
          description: description ?? this.description,
          pause: pause ?? this.pause,
          scale: scale ?? this.scale,
          showReps: showReps ?? this.showReps,
          stepSize: stepSize ?? this.stepSize);

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

  static Exercise fromMap(Map<String, Object?> map) => Exercise(
      id: map[SetColumn.id] as int?,
      workoutFK: map[ExerciseColumn.workout] as int,
      name: map[ExerciseColumn.name] as String,
      description: map[ExerciseColumn.description] as String,
      pause: map[ExerciseColumn.pause] as int,
      scale: map[ExerciseColumn.scale] as Scale,
      showReps: map[ExerciseColumn.showReps] as bool,
      stepSize: map[ExerciseColumn.stepSize] as double);
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

  static final List<String> allNames = [
    id,
    workout,
    name,
    description,
    pause,
    scale,
    showReps,
    stepSize
  ];
}
