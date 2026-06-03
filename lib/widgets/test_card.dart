import 'package:flutter/material.dart';

import '../models/test_item.dart';

class TestCard extends StatefulWidget {
  final TestItem item;
  final ValueChanged<String> onCommentChanged;
  final ValueChanged<bool> onTestedChanged;
  final ValueChanged<bool?> onStatusChanged;

  const TestCard({
    super.key,
    required this.item,
    required this.onCommentChanged,
    required this.onTestedChanged,
    required this.onStatusChanged,
  });

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  late final TextEditingController _commentController;
  late bool _tested;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(
      text: widget.item.comment,
    );
    _tested = widget.item.tested;
    _status = widget.item.status;
  }

  @override
  void didUpdateWidget(covariant TestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.comment != widget.item.comment) {
      _commentController.text = widget.item.comment;
    }
    if (oldWidget.item.tested != widget.item.tested) {
      _tested = widget.item.tested;
    }
    if (oldWidget.item.status != widget.item.status) {
      _status = widget.item.status;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _tested
        ? const Color.fromARGB(255, 39, 64, 92)
        : Theme.of(context).cardColor;

    final bgColor2 = _tested
        ? const Color.fromARGB(255, 29, 44, 70)
        : const Color(0xFF323238);

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: _tested ? Colors.blueAccent : Colors.transparent,
          width: 2,
        ),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 65,
              width: 275,
              child: _buildLabel('TAG', widget.item.name, bgColor2),
            ),
            const SizedBox(width: 12),

            SizedBox(
              height: 65,
              width: 120,
              child: _buildLabel(
                'I/O',
                widget.item.address,
                bgColor2,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Container(
                height: 65,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                  color: bgColor2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    labelText: 'Comentário',
                    labelStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 15,
                    ),
                    // border: Bor
                  ),
                  onSubmitted: widget.onCommentChanged,
                  onTapOutside: (_) => widget.onCommentChanged(
                    _commentController.text,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            SizedBox(
              height: 65,
              width: 200,
              child: _buildLabel(
                'Data Testado',
                widget.item.formattedDateTime,
                bgColor2,
              ),
            ),

            const SizedBox(width: 12),

            Container(
              height: 65,
              width: 150,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: bgColor2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _customCheckBox(
                value: _status,
                onTap: () {
                  setState(() {
                    _status = !_status;
                  });

                  widget.onStatusChanged(_status);
                },
                activeColor: Colors.greenAccent,
                inactiveColor: Colors.redAccent,
                activeLabel: 'Aprovado',
                inactiveLabel: 'Reprovado',
              ),
            ),

            const SizedBox(width: 12),

            Container(
              width: 150,
              height: 65,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: bgColor2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  _customCheckBox(
                    value: _tested,
                    onTap: () {
                      setState(() {
                        _tested = !_tested;
                      });

                      widget.onTestedChanged(_tested);
                    },
                    activeColor: Colors.white,
                    inactiveColor: const Color.fromARGB(
                      255,
                      139,
                      139,
                      139,
                    ),
                    activeLabel: 'Testado',
                    inactiveLabel: 'Não Testado',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _customCheckBox({
    required bool value,
    required Function()? onTap,
    required Color activeColor,
    required Color inactiveColor,
    required String activeLabel,
    required String inactiveLabel,
  }) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: value
                    ? activeColor.withAlpha(30)
                    : inactiveColor.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: value ? activeColor : inactiveColor,
                  width: 2,
                ),
              ),
              child: Icon(
                value ? Icons.check : Icons.close,
                color: value ? activeColor : inactiveColor,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          value ? activeLabel : inactiveLabel,
          style: TextStyle(
            color: value ? activeColor : inactiveColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String title, String value, Color bgColor2) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: bgColor2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8F8F8F),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
