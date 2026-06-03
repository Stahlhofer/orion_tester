import 'package:flutter/foundation.dart';

import '../models/routine.dart';
import '../models/test_item.dart';
import '../services/test_service.dart';

class RoutineDetailController extends ChangeNotifier {
  RoutineDetailController({TestService? service})
    : _service = service ?? TestService();

  final TestService _service;
  Routine? routine;
  final List<TestItem> tests = [];
  bool isLoading = false;

  Future<void> loadTests(Routine selectedRoutine) async {
    routine = selectedRoutine;
    isLoading = true;
    notifyListeners();

    final loaded = await _service.loadTests(selectedRoutine.id!);
    tests
      ..clear()
      ..addAll(loaded);

    isLoading = false;
    notifyListeners();
  }

  int get totalTests => tests.length;
  int get testedCount => tests.where((item) => item.tested).length;
  int get pendingCount => totalTests - testedCount;

  Future<void> addTest(String tag, String io, String comment) async {
    if (routine == null || tag.trim().isEmpty) return;
    await _service.createTest(routine!.id!, tag, io, comment);
    await loadTests(routine!);
  }

  Future<void> updateTest(TestItem item) async {
    await _service.updateTest(item);
    final index = tests.indexWhere(
      (current) => current.id == item.id,
    );
    if (index >= 0) {
      tests[index] = item;
    }
    notifyListeners();
  }

  Future<void> deleteAllTests() async {
    if (routine == null) return;
    await _service.deleteAllTests(routine!.id!);
    await loadTests(routine!);
  }
}
