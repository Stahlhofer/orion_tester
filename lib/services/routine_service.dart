import '../models/routine.dart';
import '../repositories/routine_repository.dart';

class RoutineService {
  final RoutineRepository _repository;

  RoutineService({RoutineRepository? repository})
    : _repository = repository ?? RoutineRepository();

  Future<List<Routine>> loadRoutines() => _repository.findAll();
  Future<void> deleteRoutine(int id) => _repository.delete(id);

  Future<Routine> createRoutine(String name, DateTime date) {
    final isoDate = date.toIso8601String().split('T').first;
    final displayDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final fullName = '$name - $displayDate';
    final routine = Routine(
      name: name.trim(),
      date: isoDate,
      fullName: fullName,
      createdAt: DateTime.now().toIso8601String(),
      observations: '',
    );
    return _repository.insert(routine);
  }

  Future<void> updateRoutine(Routine routine) async {
    if (routine.id == null) return;
    await _repository.update(routine.id!, routine);
  }

  Future<Routine?> findById(int id) => _repository.findById(id);
}
