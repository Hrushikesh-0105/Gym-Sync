import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MessagingMode { sms, whatsapp }

class MessageChipWidget extends StatefulWidget {
  final bool selectedInitially;
  final MessagingMode mode;
  final Function(bool) onSelected;
  const MessageChipWidget({
    super.key,
    required this.mode,
    required this.onSelected,
    this.selectedInitially = false,
  });

  @override
  State<MessageChipWidget> createState() => _MessageChipWidgetState();
}

class _MessageChipWidgetState extends State<MessageChipWidget> {
  bool isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = widget.selectedInitially;
  }

  @override
  Widget build(BuildContext context) {
    IconData icon =
        (widget.mode == MessagingMode.sms)
            ? Icons.message_outlined
            : FontAwesomeIcons.whatsapp;
    String label = (widget.mode == MessagingMode.sms) ? "SMS" : "Whatsapp";

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color:
                isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).highlightColor,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      selectedColor: Theme.of(context).highlightColor,
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color:
            isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).highlightColor,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).primaryColor,
        ), // Change border color
        borderRadius: BorderRadius.circular(10),
      ),
      onSelected: (selected) {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onSelected(isSelected);
      },
    );
  }
}
