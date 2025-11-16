import 'package:core_ui/custom_icon_button.dart';
import 'package:core_ui/custom_text_button.dart';
import 'package:domain/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:todo_app/presentation/providers/task_provider.dart';
import 'package:todo_app/presentation/providers/tasks_provider.dart';
import 'package:todo_app/presentation/views/tasks/widgets/task_details_edit_form.dart';
import 'package:todo_app/presentation/views/tasks/widgets/task_details_view.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _isLoading = false;
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final task = ref.read(selectedTaskProvider);
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No disponible';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<void> _toggleTaskStatus() async {
    final task = ref.read(selectedTaskProvider);
    if (task == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedTask = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        description: task.description,
        isDone: !task.isDone,
        createdAt: task.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(tasksNotifierProvider.notifier).updateTask(updatedTask);
      ref.read(selectedTaskProvider.notifier).setTask(updatedTask);

      if (mounted) {
        _showSuccessSnackBar(
          updatedTask.isDone
              ? '✓ Tarea marcada como completada'
              : '○ Tarea marcada como pendiente',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al actualizar la tarea: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final task = ref.read(selectedTaskProvider);
    if (task == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedTask = TaskModel(
        id: task.id,
        userId: task.userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isDone: task.isDone,
        createdAt: task.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(tasksNotifierProvider.notifier).updateTask(updatedTask);
      ref.read(selectedTaskProvider.notifier).setTask(updatedTask);

      if (mounted) {
        setState(() => _isEditing = false);
        _showSuccessSnackBar('Tarea actualizada exitosamente');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al actualizar la tarea: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteTask() async {
    final task = ref.read(selectedTaskProvider);
    if (task == null || task.id == null) return;

    final confirmed = await _showDeleteConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(tasksNotifierProvider.notifier).deleteTask(task.id!);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tarea eliminada exitosamente'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al eliminar la tarea: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminar tarea'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar esta tarea?',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actions: [
              CustomTextButton(
                onPressed: () => Navigator.of(context).pop(false),
                text: 'Cancelar',
              ),
              CustomTextButton(
                onPressed: () => Navigator.of(context).pop(true),
                text: 'Eliminar',
                color: Colors.red,
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(selectedTaskProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          leading: CustomIconButton(
            icon: Icons.arrow_back_ios_rounded,
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Volver',
          ),
        ),
        body: const Center(child: Text('No se encontró la tarea')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: CustomIconButton(
          icon: Icons.arrow_back_ios_rounded,
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _isEditing ? 'Editar Tarea' : 'Detalles de Tarea',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          if (!_isEditing && !isSmallScreen)
            CustomIconButton(
              icon: Icons.edit,
              tooltip: 'Editar',
              onPressed:
                  _isLoading ? null : () => setState(() => _isEditing = true),
            ),
          if (!_isEditing)
            PopupMenuButton<String>(
              icon: Icon(
                isSmallScreen ? Icons.more_vert : Icons.delete,
                color:
                    isSmallScreen ? Colors.grey.shade700 : Colors.red.shade600,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  setState(() => _isEditing = true);
                } else if (value == 'delete') {
                  _deleteTask();
                }
              },
              itemBuilder: (context) => [
                if (isSmallScreen)
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 12),
                        Text('Editar'),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red.shade600),
                      const SizedBox(width: 12),
                      const Text('Eliminar'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isEditing
              ? TaskDetailsEditForm(
                  isLoading: _isLoading,
                  formKey: _formKey,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  onCancel: () {
                    setState(() {
                      _isEditing = false;
                      _titleController.text = task.title;
                      _descriptionController.text = task.description;
                    });
                  },
                  onSave: _saveChanges,
                )
              : TaskDetailsView(
                  task: task,
                  isLoading: _isLoading,
                  onToggleTaskStatus: () {
                    _toggleTaskStatus();
                  },
                  formatDate: _formatDate,
                ),
    );
  }
}
