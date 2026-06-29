import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:orion_tester/controllers/import_controller.dart';
import 'package:orion_tester/widgets/detail_header.dart';
import 'package:orion_tester/widgets/filtro_aprovado.dart';

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
  final TextEditingController textController =
      TextEditingController();
  List<TestItem> testes = [];
  late final RoutineDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoutineDetailController();
    _controller.loadTests(widget.routine);

    testes = _controller.filterTests;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RoutineDetailPage oldWidget) {
    if (testes.hashCode != _controller.filterTests.hashCode) {
      testes = _controller.filterTests;
    }

    super.didUpdateWidget(oldWidget);
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
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
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
    setState(() {});
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
        testes,
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

  void loadFilterTested(FiltroTestado testado) {
    setState(() {
      _controller.filterTestado = testado;
      _controller.loadTests(widget.routine);
    });
    return;
  }

  void loadFilterApproved(FiltroAprovado aprovado) {
    setState(() {
      _controller.filterAprovado = aprovado;
      _controller.loadTests(widget.routine);
    });
    return;
  }

  void loadFilterName(String texto) {
    setState(() {
      _controller.filterName = texto.trim();
      _controller.loadTests(widget.routine);
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.fullName),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
        surfaceTintColor: Theme.of(context).colorScheme.surfaceBright,
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              mouseCursor: WidgetStatePropertyAll(
                SystemMouseCursors.click,
              ),
            ),
            onPressed: _showExportPdfDialog,
            child: Text(
              'PDF',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ButtonStyle(
              mouseCursor: WidgetStatePropertyAll(
                SystemMouseCursors.click,
              ),
            ),
            onPressed: _importFile,
            child: Text(
              'Importar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            mouseCursor: SystemMouseCursors.click,
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
                DetailHeader(
                  controller: _controller,
                  filtroTestado: loadFilterTested,
                  filtroAprovado: loadFilterApproved,
                  filtroNome: loadFilterName,
                  totalElements: testes.length,
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: testes.isEmpty
                      ? const Center(
                          child: Text('Nenhum teste cadastrado.'),
                        )
                      : ListView.builder(
                          itemCount: testes.length,
                          itemBuilder: (context, index) {
                            final item = testes[index];

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
}
