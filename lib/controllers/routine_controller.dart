import 'package:flutter/foundation.dart';

import '../models/routine.dart';
import '../services/routine_service.dart';
import '../services/test_service.dart';

class RoutineController extends ChangeNotifier {
  RoutineController({
    RoutineService? service,
    TestService? testService,
  }) : _service = service ?? RoutineService(),
       _testService = testService ?? TestService();

  final RoutineService _service;
  final TestService _testService;
  final List<Routine> routines = [];
  final Map<int, int> totalTests = {};
  final Map<int, int> completedTests = {};
  bool isLoading = false;

  Future<void> loadRoutines() async {
    isLoading = true;
    notifyListeners();

    final loaded = await _service.loadRoutines();
    routines
      ..clear()
      ..addAll(loaded);

    await _loadCounts();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCounts() async {
    totalTests.clear();
    completedTests.clear();

    for (final routine in routines) {
      final total = await _testService.countTests(routine.id!);
      final completed = await _testService.countTested(routine.id!);
      totalTests[routine.id!] = total;
      completedTests[routine.id!] = completed;
    }
  }

  Future<void> addRoutine(String name, DateTime date) async {
    if (name.trim().isEmpty) return;
    await _service.createRoutine(name, date);
    await loadRoutines();
  }

  Future<void> deleteRoutine(int id) async {
    await _service.deleteRoutine(id);
    await loadRoutines();
  }
}
