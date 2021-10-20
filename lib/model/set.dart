class Set {
  Set(
      {this.id,
      required this.exerciseFK,
      required this.weight,
      required this.reps,
      required this.duration});

  int? id;
  int exerciseFK;
  double weight;
  int reps;
  int duration;

  //This attribute is not safed in the db
  bool isDone = false;

  /// Returns a copy of the set with the specified parameters changed
  Set copyModify(
          {int? id,
          int? exerciseFK,
          double? weight,
          int? reps,
          int? duration}) =>
      Set(
          id: id ?? this.id,
          exerciseFK: exerciseFK ?? this.exerciseFK,
          weight: weight ?? this.weight,
          reps: reps ?? this.reps,
          duration: duration ?? this.duration);

  Map<String, Object?> toMap() => {
        SetColumn.id: id,
        SetColumn.exercise: exerciseFK,
        SetColumn.weight: weight,
        SetColumn.reps: reps,
        SetColumn.duration: duration,
      };

  static Set fromMap(Map<String, Object?> map) => Set(
        id: map[SetColumn.id] as int?,
        exerciseFK: map[SetColumn.exercise] as int,
        weight: map[SetColumn.weight] as double,
        reps: map[SetColumn.reps] as int,
        duration: map[SetColumn.duration] as int,
      );
}

/// Provides the names for the columns in the set database-table
class SetColumn {
  static final String id = 'id';
  static final String exercise = 'exercise';
  static final String weight = 'weight';
  static final String reps = 'reps';
  static final String duration = 'duration';

  static final List<String> allNames = [id, exercise, weight, reps, duration];
}
