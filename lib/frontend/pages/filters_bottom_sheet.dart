import 'package:flutter/material.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/frontend/styles/styles.dart';

class CustomerFilterBottomSheet extends StatelessWidget {
  final CustomerFilter selectedFilter;
  final Function(CustomerFilter) onFilterSelected;

  const CustomerFilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        // Using a slightly different background color for the bottom sheet
        color: Color(0xff232A2D), // Darker shade than scaffoldBackgroundColor
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.highlightColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Filter Customers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.highlightColor,
            ),
          ),
          const SizedBox(height: 16),
          ...CustomerFilter.values.map(
            (filter) => _buildFilterOption(context, filter),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, CustomerFilter filter) {
    final theme = Theme.of(context);
    final isSelected = selectedFilter == filter;

    // Get color based on filter type
    Color getFilterColor(CustomerFilter filter) {
      switch (filter) {
        case CustomerFilter.active:
          return AppColors.active;
        case CustomerFilter.expired:
        case CustomerFilter.expiredToday:
          return AppColors.expired;
        case CustomerFilter.inactive:
          return AppColors.inactive;
        default:
          return theme.highlightColor;
      }
    }

    return InkWell(
      onTap: () {
        onFilterSelected(filter);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.primaryColor
                  : Color(
                    0xff2C3639,
                  ), // Using scaffoldBackgroundColor for filter options
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? getFilterColor(filter) : theme.primaryColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getFilterName(filter),
              style: TextStyle(
                color: theme.highlightColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: getFilterColor(filter),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFilterName(CustomerFilter filter) {
    switch (filter) {
      case CustomerFilter.all:
        return 'All Customers';
      case CustomerFilter.active:
        return 'Active Customers';
      case CustomerFilter.expired:
        return 'Expired Customers';
      case CustomerFilter.due:
        return 'Due Customers';
      case CustomerFilter.inactive:
        return 'Inactive Customers';
      case CustomerFilter.expiredToday:
        return 'Expired Today';
    }
  }
}

// Helper function to show the bottom sheet
void showCustomerFilterSheet(
  BuildContext context,
  CustomerFilter currentFilter,
  Function(CustomerFilter) onFilterSelected,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (context) => CustomerFilterBottomSheet(
          selectedFilter: currentFilter,
          onFilterSelected: onFilterSelected,
        ),
  );
}
