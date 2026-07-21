import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercise_model.dart';

class WorkoutStorageService {
  static const String completedSetsKey = 'workout_completed_sets';
  static const String elapsedSecondsKey = 'workout_elapsed_seconds';

  Future<void> saveWorkoutState({
    required List<ExerciseModel> exercises,
    required int elapsedSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final completedSetsList = exercises
        .map((exercise) => exercise.completedSets.toString())
        .toList();

    await prefs.setStringList(completedSetsKey, completedSetsList);
    await prefs.setInt(elapsedSecondsKey, elapsedSeconds);
  }

  Future<int> loadWorkoutState(List<ExerciseModel> exercises) async {
    final prefs = await SharedPreferences.getInstance();

    final savedCompletedSets = prefs.getStringList(completedSetsKey);
    final savedElapsedSeconds = prefs.getInt(elapsedSecondsKey) ?? 0;

    if (savedCompletedSets != null &&
        savedCompletedSets.length == exercises.length) {
      for (int i = 0; i < exercises.length; i++) {
        final savedValue = int.tryParse(savedCompletedSets[i]);

        if (savedValue != null) {
          exercises[i].completedSets =
              savedValue.clamp(0, exercises[i].totalSets).toInt();
        }
      }
    }

    return savedElapsedSeconds;
  }

  Future<void> resetWorkoutState() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(completedSetsKey);
    await prefs.remove(elapsedSecondsKey);
  }
}