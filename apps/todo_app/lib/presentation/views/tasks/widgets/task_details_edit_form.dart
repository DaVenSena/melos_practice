import 'package:core_ui/custom_elevated_button.dart';
import 'package:core_ui/custom_text_button.dart';
import 'package:flutter/material.dart';

class TaskDetailsEditForm extends StatelessWidget {
  const TaskDetailsEditForm({
    super.key,
    required this.isLoading,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.onCancel,
    required this.onSave,
  });

  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = size.height * 0.02;
    final fontSize = size.width * 0.04;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalSpacing,
          ),
          children: [
            _InputSection(
              icon: Icons.title_rounded,
              label: 'Título',
              controller: titleController,
              isLoading: isLoading,
              fontSize: fontSize,
              horizontalPadding: horizontalPadding,
              verticalSpacing: verticalSpacing,
              hintText: 'Escribe el título de la tarea',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es requerido';
                }
                if (value.trim().length < 3) {
                  return 'El título debe tener al menos 3 caracteres';
                }
                return null;
              },
              maxLength: 100,
              maxLines: 1,
              minLines: 1,
            ),
            SizedBox(height: verticalSpacing),
            _InputSection(
              icon: Icons.description_outlined,
              label: 'Descripción',
              controller: descriptionController,
              isLoading: isLoading,
              fontSize: fontSize,
              horizontalPadding: horizontalPadding,
              verticalSpacing: verticalSpacing,
              hintText: 'Describe los detalles de la tarea',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es requerida';
                }
                return null;
              },
              maxLength: 500,
              maxLines: null,
              minLines: 4,
            ),
            SizedBox(height: verticalSpacing * 1.5),
            Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height * 0.06,
                      maxHeight: size.height * 0.08,
                    ),
                    child: CustomTextButton(
                      text: 'Cancelar',
                      onPressed: isLoading ? null : onCancel,
                      textColor: Colors.grey.shade700,
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.8,
                        vertical: verticalSpacing * 0.6,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: horizontalPadding * 0.8),
                Expanded(
                  flex: 2,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height * 0.06,
                      maxHeight: size.height * 0.08,
                    ),
                    child: CustomElevatedButton(
                      text: 'Guardar Cambios',
                      onPressed: isLoading
                          ? null
                          : () {
                              onSave();
                            },
                      color: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(14),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.8,
                        vertical: verticalSpacing * 0.6,
                      ),
                      isLoading: isLoading,
                      progressIndicatorSize: size.height * 0.03,
                      child: isLoading
                          ? null
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save, size: fontSize * 1.2),
                                  SizedBox(width: horizontalPadding * 0.6),
                                  Text(
                                    'Guardar Cambios',
                                    style: TextStyle(
                                      fontSize: fontSize,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputSection extends StatelessWidget {
  const _InputSection({
    required this.icon,
    required this.label,
    required this.controller,
    required this.isLoading,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalSpacing,
    required this.hintText,
    required this.validator,
    required this.maxLength,
    required this.maxLines,
    required this.minLines,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isLoading;
  final double fontSize;
  final double horizontalPadding;
  final double verticalSpacing;
  final String hintText;
  final String? Function(String?) validator;
  final int maxLength;
  final int? maxLines;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              horizontalPadding,
              horizontalPadding,
              horizontalPadding * 0.4,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue.shade600,
                  size: fontSize * 1.2,
                ),
                SizedBox(width: horizontalPadding * 0.6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              horizontalPadding,
            ),
            child: TextFormField(
              controller: controller,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.blue.shade600,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.8,
                  vertical: verticalSpacing * 0.8,
                ),
              ),
              style: TextStyle(fontSize: fontSize),
              validator: validator,
              textCapitalization: TextCapitalization.sentences,
              maxLength: maxLength,
              maxLines: maxLines,
              minLines: minLines,
            ),
          ),
        ],
      ),
    );
  }
}
