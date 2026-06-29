import 'package:flutter/material.dart';

class FiltroNome extends StatefulWidget {
  final String name;
  final Function(String) filter;

  const FiltroNome({
    super.key,
    required this.name,
    required this.filter,
  });

  @override
  State<FiltroNome> createState() => _FiltroNomeState();
}

class _FiltroNomeState extends State<FiltroNome> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.text = widget.name;
    print([widget.name, controller.text, controller.value]);

    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 40, maxWidth: 500),
        hintStyle: TextStyle(color: Colors.white54),
        hintText: 'Filtrar por nome...',
        prefixIcon: const Icon(Icons.search),
        contentPadding: .all(4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (text) {
        setState(() {
          widget.filter.call(text);
        });
      },
      onSubmitted: (text) {
        setState(() {
          widget.filter.call(text);
        });
      },
    );
  }
}
