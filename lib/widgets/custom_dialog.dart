import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;

  const CustomDialog({
    super.key,
    required this.title,
    required this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              child,
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
