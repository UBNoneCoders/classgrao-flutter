import 'package:flutter/material.dart';

class AnalysisFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const AnalysisFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['Todos', 'Aptos', 'Inaptos'];

    return Row(
      children: filters.map((filter) {
        final isSelected = filter == selectedFilter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onFilterChanged(filter);
              }
            },
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFF00695C),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF00695C)
                  : Colors.grey.shade300,
            ),
          ),
        );
      }).toList(),
    );
  }
}
