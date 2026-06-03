import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_text_field.dart';

class NewRoutineDialog extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSave;

  const NewRoutineDialog({super.key, required this.onSave});

  @override
  State<NewRoutineDialog> createState() => _NewRoutineDialogState();
}

class _NewRoutineDialogState extends State<NewRoutineDialog> {
  final TextEditingController _nameController =
      TextEditingController();
  late final TextEditingController _dateController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: _formattedDate);
  }

  String get _formattedDate {
    return '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    if (selected != null) {
      setState(() {
        _selectedDate = selected;
        _dateController.text = _formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Nova Rotina',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        CustomButton(
          label: 'Salvar',
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            widget.onSave({'name': name, 'date': _selectedDate});
            Navigator.of(context).pop();
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CustomTextField(
                label: 'Nome',
                controller: _nameController,
                hintText: 'Teste Cliente PRJ12345',
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: 'Data',
                    controller: _dateController,
                    readOnly: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
