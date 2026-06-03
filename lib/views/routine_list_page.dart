import 'package:flutter/material.dart';

import '../controllers/routine_controller.dart';
import '../models/routine.dart';
import '../views/new_routine_dialog.dart';
import '../views/routine_detail_page.dart';
import '../widgets/routine_card.dart';
import '../widgets/custom_button.dart';

class RoutineListPage extends StatefulWidget {
  const RoutineListPage({super.key});

  @override
  State<RoutineListPage> createState() => _RoutineListPageState();
}

class _RoutineListPageState extends State<RoutineListPage> {
  late final RoutineController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoutineController();
    _controller.loadRoutines();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleNewRoutine() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return NewRoutineDialog(
          onSave: (data) async {
            await _controller.addRoutine(
              data['name'] as String,
              data['date'] as DateTime,
            );
          },
        );
      },
    );
  }

  void _openRoutineDetail(Routine routine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineDetailPage(routine: routine),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Image.asset('assets/logo/logo.png', scale: 1),
        ),
        centerTitle: true,
        title: const Text('Rotinas de Teste'),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceBright,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: CustomButton(
              label: '+ Nova Rotina',
              onPressed: _handleNewRoutine,
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.routines.isEmpty) {
            return const Center(
              child: Text('Nenhuma rotina cadastrada ainda.'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: _controller.routines.length,
              itemBuilder: (context, index) {
                final routine = _controller.routines[index];
                final total = _controller.totalTests[routine.id] ?? 0;
                final completed =
                    _controller.completedTests[routine.id] ?? 0;
                return RoutineCard(
                  routine: routine,
                  testsCount: total,
                  completedCount: completed,
                  onTap: () => _openRoutineDetail(routine),
                  onDelete: () {
                    if (routine.id != null) {
                      _controller.deleteRoutine(routine.id!);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
