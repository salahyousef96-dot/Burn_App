class ExerciseModel {
  final String title;
  final String details;
  final int totalSets;
  int completedSets;

  ExerciseModel({
    required this.title,
    required this.details,
    required this.totalSets,
    required this.completedSets,
  });

  bool get isCompleted => completedSets >= totalSets;

  double get progress {
    if (totalSets == 0) return 0;
    return completedSets / totalSets;
  }

  void reset() {
    completedSets = 0;
  }
}