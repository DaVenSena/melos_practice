import 'package:domain/models/task.dart';
import 'package:flutter/material.dart';

class TaskStatusCard extends StatelessWidget {
  const TaskStatusCard({
    super.key,
    required this.task,
    required this.horizontalPadding,
    required this.iconSize,
    required this.titleFontSize,
    required this.bodyFontSize,
  });

  final TaskModel task;
  final double horizontalPadding;
  final double iconSize;
  final double titleFontSize;
  final double bodyFontSize;

  @override
  Widget build(BuildContext context) {
    final isDone = task.isDone;
    final backgroundColor =
        isDone ? Colors.green.shade50 : Colors.orange.shade50;
    final borderColor = isDone ? Colors.green.shade200 : Colors.orange.shade200;
    final textColor = isDone ? Colors.green.shade700 : Colors.orange.shade700;
    final descriptionColor =
        isDone ? Colors.green.shade600 : Colors.orange.shade600;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: EdgeInsets.all(horizontalPadding),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: textColor,
            size: iconSize,
          ),
          SizedBox(width: horizontalPadding * 0.8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isDone ? 'Completada' : 'Pendiente',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(height: horizontalPadding * 0.2),
                Text(
                  isDone
                      ? 'Esta tarea ha sido completada'
                      : 'Esta tarea está pendiente',
                  style: TextStyle(
                    fontSize: bodyFontSize * 0.9,
                    color: descriptionColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
