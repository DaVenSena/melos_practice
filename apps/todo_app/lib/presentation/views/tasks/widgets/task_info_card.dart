import 'package:flutter/material.dart';

class TaskInfoCard extends StatelessWidget {
  const TaskInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.content,
    required this.fontSize,
    required this.padding,
  });

  final IconData icon;
  final String label;
  final String content;
  final double fontSize;
  final double padding;

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
              padding,
              padding,
              padding,
              padding * 0.4,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue.shade600,
                  size: fontSize * 1.2,
                ),
                SizedBox(width: padding * 0.6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
            child: Text(
              content,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey.shade900,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
