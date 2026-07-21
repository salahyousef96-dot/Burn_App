import '../models/exercise_model.dart';

List<ExerciseModel> createDefaultWorkoutExercises() {
  return [
    ExerciseModel(
      title: 'Bench Press',
      details: '80 kg · 90s rest',
      totalSets: 4,
      completedSets: 4,
    ),
    ExerciseModel(
      title: 'Incline Dumbbell Press',
      details: '30 kg × 2 · 60s rest',
      totalSets: 4,
      completedSets: 2,
    ),
    ExerciseModel(
      title: 'Cable Fly',
      details: '20 kg · 45s rest',
      totalSets: 3,
      completedSets: 0,
    ),
    ExerciseModel(
      title: 'OHP Barbell',
      details: '45 kg · 90s rest',
      totalSets: 4,
      completedSets: 0,
    ),
  ];
}