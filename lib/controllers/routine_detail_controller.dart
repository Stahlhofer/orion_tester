import 'package:flutter/foundation.dart';
import 'package:orion_tester/widgets/filtro_aprovado.dart';

import '../models/routine.dart';
import '../models/test_item.dart';
import '../services/test_service.dart';

class RoutineDetailController extends ChangeNotifier {
  RoutineDetailController({TestService? service})
    : _service = service ?? TestService();

  final TestService _service;
  Routine? routine;

  final List<TestItem> tests = [];
  final List<TestItem> _tested = [];
  final List<TestItem> _approved = [];

  bool isLoading = false;

  FiltroTestado filterTestado = FiltroTestado.none;
  FiltroAprovado filterAprovado = FiltroAprovado.none;
  String? filterName;

  final List<TestItem> filterTests = [];

  Future<void> loadTests(Routine selectedRoutine) async {
    routine = selectedRoutine;
    isLoading = true;
    notifyListeners();

    final loaded = await _service.loadTests(selectedRoutine.id!);

    tests
      ..clear()
      ..addAll(loaded);

    filtrarTestado(filterTestado);
    filtrarAprovado(filterAprovado);
    filtrarNome(filterName);

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

  void filtrarTestado(FiltroTestado mode) {
    switch (mode) {
      case FiltroTestado.none:
        _tested
          ..clear()
          ..addAll(tests);
        break;

      case FiltroTestado.tested:
        _tested
          ..clear()
          ..addAll(tests.where((test) => test.tested));
        break;

      case FiltroTestado.notTested:
        _tested
          ..clear()
          ..addAll(tests.where((test) => !test.tested));
        break;
    }
  }

  void filtrarAprovado(FiltroAprovado filtro) {
    switch (filtro) {
      case FiltroAprovado.none:
        _approved
          ..clear()
          ..addAll(_tested);
        break;

      case FiltroAprovado.approved:
        _approved
          ..clear()
          ..addAll(_tested.where((item) => item.status));
        break;

      case FiltroAprovado.reproved:
        _approved
          ..clear()
          ..addAll(_tested.where((item) => !item.status));
    }
  }

  void filtrarNome(String? nome) {
    if (nome == null) {
      filterTests
        ..clear()
        ..addAll(_approved);
      return;
    }

    filterTests
      ..clear()
      ..addAll(
        _approved.where(
          (test) =>
              test.name.toLowerCase().contains(nome.toLowerCase()),
        ),
      );
  }
}

enum FiltroTestado { none, tested, notTested }
