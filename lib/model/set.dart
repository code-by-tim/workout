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

  Map<String, Object?> toMap() => {
        SetColumn.id: id,
        SetColumn.exercise: exerciseFK,
        SetColumn.weight: weight,
        SetColumn.reps: reps,
        SetColumn.duration: duration,
      };
}

class SetColumn {
  static final String id = 'id';
  static final String exercise = 'exercise';
  static final String weight = 'weight';
  static final String reps = 'reps';
  static final String duration = 'duration';
}
