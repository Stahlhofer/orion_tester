import 'package:flutter/material.dart';

enum FiltroAprovado { none, approved, reproved }

class ApprovedFilter extends StatefulWidget {
  final ValueChanged<FiltroAprovado> onFilterChanged;
  final FiltroAprovado value;

  const ApprovedFilter({
    super.key,
    required this.onFilterChanged,
    required this.value,
  });

  @override
  State<ApprovedFilter> createState() => _ApprovedFilterState();
}

class _ApprovedFilterState extends State<ApprovedFilter> {
  // Começa com "todos" (nenhum filtro aplicado)
  FiltroAprovado _selecao = FiltroAprovado.none;

  @override
  Widget build(BuildContext context) {
    _selecao = widget.value;

    return SegmentedButton<FiltroAprovado>(
      segments: const [
        ButtonSegment(
          value: FiltroAprovado.none,
          label: Text('Todos'),
        ),
        ButtonSegment(
          value: FiltroAprovado.approved,
          label: Text('Aprovados'),
        ),
        ButtonSegment(
          value: FiltroAprovado.reproved,
          label: Text('Reprovados'),
        ),
      ],

      selected: {_selecao},

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            switch (_selecao) {
              case FiltroAprovado.approved:
                return Colors.green.withAlpha(200);
              case FiltroAprovado.reproved:
                return Colors.red.withAlpha(200);
              case FiltroAprovado.none:
                return Colors.blueGrey.withAlpha(200);
            }
          }
          return null; // não selecionado
        }),

        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),

      onSelectionChanged: (Set<FiltroAprovado> novaSelecao) {
        setState(() {
          _selecao = novaSelecao.first;
        });

        widget.onFilterChanged(_selecao);
      },
    );
  }
}
