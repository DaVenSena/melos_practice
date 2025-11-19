import 'package:core_ui/custom_icon_button.dart';
import 'package:core_ui/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/presentation/providers/task_provider.dart';
import 'package:todo_app/presentation/providers/tasks_provider.dart';
import 'package:todo_app/presentation/providers/user_provider.dart';
import 'package:todo_app/presentation/views/tasks/add_task.dart';
import 'package:todo_app/presentation/views/tasks/task_details.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Color _getTaskColor(bool isDone) {
    return isDone ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksNotifierProvider);
    final user = ref.watch(
      userProvider.select(
        (state) => state.hasValue ? state.value : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          CustomIconButton(
            icon: Icons.logout,
            tooltip: 'Cerrar sesión',
            onPressed: () {
              _showLogoutDialog(context, ref);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con información del usuario
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, ${user?.name ?? 'Invitado'} 👋',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${user?.id ?? '--'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal (tareas)
          Expanded(
            child: tasksAsync.when(
              data: (tasks) => tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay tareas todavía',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toca el botón + para crear una',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) => ListTile(
                        textColor: _getTaskColor(tasks[index].isDone),
                        iconColor: _getTaskColor(tasks[index].isDone),
                        tileColor: _getTaskColor(
                          tasks[index].isDone,
                        ).withValues(alpha: 0.1),
                        onTap: () {
                          ref
                              .read(selectedTaskProvider.notifier)
                              .setTask(tasks[index]);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TaskDetailScreen(),
                            ),
                          );
                        },
                        title: Text(tasks[index].title),
                        subtitle: Text(tasks[index].description),
                        trailing: CustomIconButton(
                          icon: Icons.delete,
                          tooltip: 'Eliminar tarea',
                          onPressed: () => ref
                              .read(tasksNotifierProvider.notifier)
                              .deleteTask(tasks[index].id!),
                        ),
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar tareas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          CustomTextButton(
            text: 'Cancelar',
            onPressed: () => Navigator.of(context).pop(),
          ),
          CustomTextButton(
            text: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(userProvider.notifier).signOut();
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
