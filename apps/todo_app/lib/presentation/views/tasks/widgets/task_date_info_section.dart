import 'package:flutter/material.dart';

class TaskDateInfoSection extends StatelessWidget {
  const TaskDateInfoSection({
    super.key,
    required this.createdAtLabel,
    required this.updatedAtLabel,
    required this.createdAt,
    required this.updatedAt,
    required this.formatDate,
    required this.horizontalPadding,
    required this.bodyFontSize,
    required this.verticalSpacing,
  });

  final String createdAtLabel;
  final String updatedAtLabel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String Function(DateTime?) formatDate;
  final double horizontalPadding;
  final double bodyFontSize;
  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

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
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        children: [
          _DateRow(
            icon: Icons.calendar_today,
            label: createdAtLabel,
            date: createdAt,
            formatDate: formatDate,
            fontSize: bodyFontSize * 0.9,
            width: width,
          ),
          if (updatedAt != null) ...[
            SizedBox(height: verticalSpacing * 0.6),
            _DateRow(
              icon: Icons.update,
              label: updatedAtLabel,
              date: updatedAt,
              formatDate: formatDate,
              fontSize: bodyFontSize * 0.9,
              width: width,
            ),
          ],
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.icon,
    required this.label,
    required this.date,
    required this.formatDate,
    required this.fontSize,
    required this.width,
  });

  final IconData icon;
  final String label;
  final DateTime? date;
  final String Function(DateTime?) formatDate;
  final double fontSize;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: fontSize * 1.2),
        SizedBox(width: width * 0.03),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(width: width * 0.02),
        Expanded(
          child: Text(
            formatDate(date),
            style: TextStyle(fontSize: fontSize, color: Colors.grey.shade700),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
