import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final List<String> filters = [
    'All',
    'Arabica',
    'Robusta',
    'Milk',
    'Chocolate',
    'Caramel',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = widget.selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                widget.onFilterSelected(selected ? filter : 'All');
              },
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.grey[300],
              showCheckmark: true,
            ),
          );
        },
      ),
    );
  }
}
