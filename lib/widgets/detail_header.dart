import 'package:flutter/material.dart';
import 'package:orion_tester/controllers/routine_detail_controller.dart';
import 'package:orion_tester/widgets/filtro_aprovado.dart';
import 'package:orion_tester/widgets/filtro_nome.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    required this.controller,
    required this.filtroTestado,
    required this.filtroAprovado,
    required this.filtroNome,
    super.key,
    required this.totalElements,
  });

  final RoutineDetailController controller;
  final Function(FiltroTestado)? filtroTestado;
  final ValueChanged<FiltroAprovado> filtroAprovado;
  final ValueChanged<String> filtroNome;
  final int totalElements;

  // carrega a informação de testes o botão com filtro
  Widget _buildIndicator({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback? onTap,
    Color? color,
    FiltroTestado? modeValue,
    FiltroTestado? actualMode,
  }) {
    Color? bgColor;

    if (modeValue != null && actualMode != null) {
      if (modeValue == actualMode) {
        if (color == null) {
          bgColor = Colors.white12;
        } else {
          bgColor = color.withAlpha(30);
        }
      }
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: color),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: color?.withAlpha(150)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Theme.of(context).cardColor,
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15,
              left: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIndicator(
                  context: context,
                  label: 'Total de Testes',
                  value: controller.totalTests.toString(),
                  onTap: () =>
                      filtroTestado?.call(FiltroTestado.none),
                  modeValue: FiltroTestado.none,
                  actualMode: controller.filterTestado,
                ),
                _buildIndicator(
                  context: context,
                  label: 'Testados',
                  value: controller.testedCount.toString(),
                  onTap: () =>
                      filtroTestado?.call(FiltroTestado.tested),
                  color: Colors.greenAccent,
                  modeValue: FiltroTestado.tested,
                  actualMode: controller.filterTestado,
                ),
                _buildIndicator(
                  context: context,
                  label: 'Pendentes',
                  value: controller.pendingCount.toString(),
                  onTap: () =>
                      filtroTestado?.call(FiltroTestado.notTested),
                  color: Colors.redAccent,
                  modeValue: FiltroTestado.notTested,
                  actualMode: controller.filterTestado,
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .end,
            children: [
              Flexible(
                child: Container(
                  padding: .only(bottom: 10, left: 10),
                  child: FiltroNome(
                    name: controller.filterName ?? "",
                    filter: filtroNome,
                  ),
                ),
              ),
              SizedBox(width: 75),
              Row(
                children: [
                  Container(
                    padding: .only(bottom: 10, right: 15),
                    child: Text('$totalElements itens'),
                  ),
                  Container(
                    padding: .only(bottom: 10, right: 10),
                    child: ApprovedFilter(
                      onFilterChanged: filtroAprovado,
                      value: controller.filterAprovado,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
