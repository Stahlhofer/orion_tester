import 'package:flutter/material.dart';
import 'package:orion_tester/models/routine.dart';
import 'package:orion_tester/services/routine_service.dart';

class ExportPdfDialog extends StatefulWidget {
  final Routine routine;
  final Function(String message) onExport;

  const ExportPdfDialog({
    super.key,
    required this.routine,
    required this.onExport,
  });

  @override
  State<ExportPdfDialog> createState() => _ExportPdfDialogState();
}

class _ExportPdfDialogState extends State<ExportPdfDialog> {
  late TextEditingController _messageController;
  final RoutineService _service = RoutineService();
  late String _initialObservations;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageController.text = '';
    _initialObservations = '';
    _loadObservations();
  }

  Future<void> _loadObservations() async {
    try {
      if (widget.routine.id == null) {
        final obs = widget.routine.observations;
        if (!mounted) return;
        setState(() {
          _messageController.text = obs;
          _initialObservations = obs;
        });
        return;
      }

      final latest = await _service.findById(widget.routine.id!);
      final obs = latest?.observations ?? widget.routine.observations;
      if (!mounted) return;
      setState(() {
        _messageController.text = obs;
        _initialObservations = obs;
      });
    } catch (e) {
      // ignore errors and keep existing text
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _updateObs() async {
    final obs = _messageController.text;
    if (obs == _initialObservations) return;
    final updated = widget.routine.copyWith(observations: obs);
    await _service.updateRoutine(updated);
    _initialObservations = obs;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      constraints: BoxConstraints(maxWidth: 1200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título com nome da rotina
              Text(
                widget.routine.name,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Exportar para PDF',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Campo de texto grande
              Text(
                'Observações ao final do PDF',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                maxLines: null,
                minLines: 2,
                decoration: InputDecoration(
                  hintText:
                      'Digite uma mensagem para incluir no PDF...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onEditingComplete: _updateObs,
                onChanged: (value) => _updateObs(),
                onTapOutside: (event) => _updateObs(),
              ),
              const SizedBox(height: 24),
              // Botões de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final obs = _messageController.text;

                      widget.onExport(obs);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Exportar PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
