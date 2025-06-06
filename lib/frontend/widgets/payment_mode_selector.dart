import 'package:flutter/material.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';

class PaymentModeSelector extends StatefulWidget {
  final PaymentMode initialMode;
  final Function(PaymentMode) onModeSelected;

  const PaymentModeSelector({
    super.key,
    this.initialMode = PaymentMode.cash,
    required this.onModeSelected,
  });

  @override
  State<PaymentModeSelector> createState() => _PaymentModeSelectorState();
}

class _PaymentModeSelectorState extends State<PaymentModeSelector> {
  late PaymentMode _selectedPaymentMode;

  // Map of payment modes with their details
  final Map<PaymentMode, Map<String, dynamic>> _paymentModeDetails = {
    PaymentMode.cash: {'label': 'Cash', 'icon': Icons.money},
    PaymentMode.card: {'label': 'Card', 'icon': Icons.credit_card},
    PaymentMode.gpay: {'label': 'GPay', 'icon': Icons.g_mobiledata},
    PaymentMode.phonePay: {'label': 'PhonePe', 'icon': Icons.phone_android},
  };

  @override
  void initState() {
    super.initState();
    _selectedPaymentMode = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    List<PaymentMode> displayModes = PaymentMode.values;
    return Wrap(
      spacing: 8,
      runSpacing: 5,
      children:
          displayModes
              .map(
                (mode) => _buildPaymentModeChip(
                  mode,
                  _paymentModeDetails[mode]!['label'],
                  _paymentModeDetails[mode]!['icon'],
                ),
              )
              .toList(),
    );
  }

  Widget _buildPaymentModeChip(PaymentMode mode, String label, IconData icon) {
    final isSelected = _selectedPaymentMode == mode;

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
          _selectedPaymentMode = mode;
        });
        widget.onModeSelected(_selectedPaymentMode);
      },
    );
  }
}
