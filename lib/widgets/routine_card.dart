import 'package:flutter/material.dart';

import '../models/routine.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final int testsCount;
  final int completedCount;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RoutineCard({
    super.key,
    required this.routine,
    required this.testsCount,
    required this.completedCount,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.fullName,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$testsCount testes cadastrados',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$completedCount concluídos',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.redAccent,
                      size: 35,
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
