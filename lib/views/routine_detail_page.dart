import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:orion_tester/controllers/import_controller.dart';

import '../controllers/routine_detail_controller.dart';
import '../models/routine.dart';
import '../models/test_item.dart';
import '../views/export_pdf_dialog.dart';
import '../views/new_test_dialog.dart';
import '../widgets/test_card.dart';

class RoutineDetailPage extends StatefulWidget {
  final Routine routine;

  const RoutineDetailPage({super.key, required this.routine});

  @override
  State<RoutineDetailPage> createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage> {
  final controller = ImportController();
  late final RoutineDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoutineDetailController();
    _controller.loadTests(widget.routine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAddTest() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return NewTestDialog(
          onSave: (data) async {
            await _controller.addTest(
              data['tag']!,
              data['io']!,
              data['comment']!,
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteAllTests() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: const Text('Excluir Testes'),
          content: const Text(
            'Deseja apagar todos os testes desta rotina?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _controller.deleteAllTests();
    }
  }

  void _updateTestItem(TestItem item) {
    _controller.updateTest(item);
  }

  void _importFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv', 'xlsx', 'xml'],
        type: FileType.custom,
      );

      if (result == null) return;

      await controller.import(result.files.single.path!);

      for (var item in controller.items) {
        _controller.addTest(item.name, item.address, item.comment);
      }

      setState(() {});

      return;
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _showExportPdfDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return ExportPdfDialog(
          routine: widget.routine,
          onExport: (message) {
            _exportarPDF(message);
          },
        );
      },
    );
  }

  void _exportarPDF(String? message) async {
    try {
      String path = await controller.exportPdf(
        _controller.tests,
        _controller.routine?.name ?? "padrão",
        message ?? '',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Salvo em: ${path.replaceAll('\\', '/')}"),
          ),
        );
      }
      return;
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('observation: ${widget.routine.observations}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.fullName),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceBright,
        actions: [
          ElevatedButton(
            onPressed: _showExportPdfDialog,
            child: Text(
              'PDF',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _importFile,
            child: Text(
              'Importar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Apagar todos os testes',
            onPressed: _confirmDeleteAllTests,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(context).cardColor,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIndicator(
                          label: 'Total de Testes',
                          value: _controller.totalTests.toString(),
                        ),
                        _buildIndicator(
                          label: 'Testados',
                          value: _controller.testedCount.toString(),
                          color: Colors.greenAccent,
                        ),
                        _buildIndicator(
                          label: 'Pendentes',
                          value: _controller.pendingCount.toString(),
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _controller.tests.isEmpty
                      ? const Center(
                          child: Text('Nenhum teste cadastrado.'),
                        )
                      : ListView.builder(
                          itemCount: _controller.tests.length,
                          itemBuilder: (context, index) {
                            final item = _controller.tests[index];
                            return TestCard(
                              item: item,
                              onCommentChanged: (comment) {
                                final updated = item.copyWith(
                                  comment: comment,
                                );
                                _updateTestItem(updated);
                              },
                              onTestedChanged: (tested) {
                                final updated = item.copyWith(
                                  tested: tested,
                                  dateTime: tested
                                      ? DateTime.now().toString()
                                      : '',
                                );
                                _updateTestItem(updated);
                              },
                              onStatusChanged: (status) {
                                final updated = item.copyWith(
                                  status: status,
                                );

                                _updateTestItem(updated);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddTest,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildIndicator({
    required String label,
    required String value,
    Color? color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color?.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
