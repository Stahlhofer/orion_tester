import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_text_field.dart';

class NewTestDialog extends StatefulWidget {
  final ValueChanged<Map<String, String>> onSave;

  const NewTestDialog({super.key, required this.onSave});

  @override
  State<NewTestDialog> createState() => _NewTestDialogState();
}

class _NewTestDialogState extends State<NewTestDialog> {
  final TextEditingController _tagController =
      TextEditingController();

  final TextEditingController _commentController =
      TextEditingController();

  final TextEditingController _ioController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    _commentController.dispose();
    _ioController.dispose();
    super.dispose();
  }

  void _save() {
    final tag = _tagController.text.trim();

    if (tag.isEmpty) return;

    widget.onSave({
      'tag': tag,
      'io': _ioController.text.trim(),
      'comment': _commentController.text.trim(),
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF323238);
    const borderColor = Color(0xFF4A4A50);

    const labelStyle = TextStyle(
      color: Color(0xFFB0B0B0),
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    const helperStyle = TextStyle(
      color: Color(0xFF8F8F8F),
      fontSize: 12,
    );

    return CustomDialog(
      title: 'Novo Teste',
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        CustomButton(label: 'Salvar', onPressed: _save),
      ],
      child: SizedBox(
        width: 550,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TAG
            const Text('TAG', style: labelStyle),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: CustomTextField(
                controller: _tagController,
                hintText: 'Ex.: LS101',
                label: 'Ex.: LS101',
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Identificação do instrumento ou dispositivo.',
              style: helperStyle,
            ),

            const SizedBox(height: 18),

            /// IO
            const Text('ENDEREÇO I/O', style: labelStyle),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: CustomTextField(
                controller: _ioController,
                hintText: 'Ex.: DQ13.0',
                label: 'Ex.: DQ13.0',
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Exemplos: DQ13.0, X2.1, I0.0, Q4.2',
              style: helperStyle,
            ),

            const SizedBox(height: 18),

            /// COMENTÁRIO
            const Text('OBSERVAÇÃO', style: labelStyle),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: CustomTextField(
                controller: _commentController,
                maxLines: 4,
                hintText: 'Informações adicionais sobre o teste...',
                label: 'Informações adicionais sobre o teste...',
              ),
            ),

            const SizedBox(height: 4),

            const Text('Campo opcional.', style: helperStyle),
          ],
        ),
      ),
    );
  }
}
