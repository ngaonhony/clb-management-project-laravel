import 'package:flutter/material.dart';

class NotificationFilter extends StatelessWidget {
  final String currentFilter;
  final List<String> filterOptions;
  final Function(String) onFilterChanged;

  const NotificationFilter({
    super.key,
    required this.currentFilter,
    required this.filterOptions,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.filter_list,
            size: 18,
            color: Colors.black54,
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: currentFilter,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            underline: Container(
              height: 0,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onFilterChanged(newValue);
              }
            },
            items: filterOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
