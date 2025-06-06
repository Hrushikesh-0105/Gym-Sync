import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MembershipDurationSelector extends StatefulWidget {
  final List<int> availableDurations;
  final int initialDuration;
  final Function(int) onDurationSelected;

  const MembershipDurationSelector({
    Key? key,
    required this.availableDurations,
    required this.initialDuration,
    required this.onDurationSelected,
  }) : super(key: key);

  @override
  State<MembershipDurationSelector> createState() =>
      _MembershipDurationSelectorState();
}

class _MembershipDurationSelectorState
    extends State<MembershipDurationSelector> {
  late int _selectedDuration;

  // Map durations to colors using a more scalable approach
  final Map<int, Color> _durationColors = {
    1: Color(0xFF1976D2), // Blue[700]
    2: Color(0xFF43A047), // Green[600]
    3: Color(0xFFFB8C00), // Orange[600]
    6: Color(0xFFF4511E), // DeepOrange[600]
    12: Color(0xFF8E24AA), // Purple[600]
  };

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // alignment: WrapAlignment.spaceBetween,
      spacing: 15,
      runSpacing: 10,
      children:
          widget.availableDurations.map((duration) {
            // Get color from map or default to theme primary color
            final Color chipColor =
                _durationColors[duration] ?? Theme.of(context).primaryColor;
            final bool isSelected = _selectedDuration == duration;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDuration = duration;
                });
                widget.onDurationSelected(duration);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  color:
                      isSelected ? chipColor : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: chipColor.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                          : null,
                  border: Border.all(
                    color:
                        isSelected
                            ? chipColor
                            : Theme.of(context).highlightColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "$duration",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      duration == 1 ? "Month" : "Months",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).highlightColor.withOpacity(0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
