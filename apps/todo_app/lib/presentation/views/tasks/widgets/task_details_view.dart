import 'package:core_ui/custom_elevated_button.dart';
import 'package:domain/models/task.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/views/tasks/widgets/task_date_info_section.dart';
import 'package:todo_app/presentation/views/tasks/widgets/task_info_card.dart';
import 'package:todo_app/presentation/views/tasks/widgets/task_status_card.dart';

class TaskDetailsView extends StatelessWidget {
  const TaskDetailsView({
    super.key,
    required this.task,
    required this.isLoading,
    required this.onToggleTaskStatus,
    required this.formatDate,
  });

  final TaskModel task;
  final bool isLoading;
  final VoidCallback onToggleTaskStatus;
  final String Function(DateTime?) formatDate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = size.height * 0.02;
    final iconSize = size.width * 0.08;
    final titleFontSize = size.width * 0.045;
    final bodyFontSize = size.width * 0.04;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TaskStatusCard(
            task: task,
            horizontalPadding: horizontalPadding,
            iconSize: iconSize,
            titleFontSize: titleFontSize,
            bodyFontSize: bodyFontSize,
          ),
          SizedBox(height: verticalSpacing),
          TaskInfoCard(
            icon: Icons.title_rounded,
            label: 'Título',
            content: task.title,
            fontSize: titleFontSize,
            padding: horizontalPadding,
          ),
          SizedBox(height: verticalSpacing),
          TaskInfoCard(
            icon: Icons.description_outlined,
            label: 'Descripción',
            content: task.description,
            fontSize: bodyFontSize,
            padding: horizontalPadding,
          ),
          SizedBox(height: verticalSpacing),
          TaskDateInfoSection(
            createdAtLabel: 'Creada:',
            updatedAtLabel: 'Actualizada:',
            createdAt: task.createdAt,
            updatedAt: task.updatedAt,
            formatDate: formatDate,
            horizontalPadding: horizontalPadding,
            bodyFontSize: bodyFontSize,
            verticalSpacing: verticalSpacing,
          ),
          SizedBox(height: verticalSpacing * 1.5),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height * 0.06,
              maxHeight: size.height * 0.08,
            ),
            child: CustomElevatedButton(
              text: task.isDone
                  ? 'Marcar como Pendiente'
                  : 'Marcar como Completada',
              onPressed: isLoading ? null : onToggleTaskStatus,
              color:
                  task.isDone ? Colors.orange.shade600 : Colors.green.shade600,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.6,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      task.isDone ? Icons.replay : Icons.check_circle_outline,
                      size: iconSize * 0.6,
                      color: Colors.white,
                    ),
                    SizedBox(width: horizontalPadding * 0.6),
                    Text(
                      task.isDone
                          ? 'Marcar como Pendiente'
                          : 'Marcar como Completada',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
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
}
