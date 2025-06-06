import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';

class MembershipRecordCard extends StatelessWidget {
  final MembershipRecord record;
  final void Function(MembershipRecord currentRecord) onDelete;
  final void Function(int customerId, int recordId) onClearDue;

  const MembershipRecordCard({
    super.key,
    required this.record,
    required this.onDelete,
    required this.onClearDue,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDue = record.dueAmount > 0;

    return Card(
      color: const Color(0xff3F4E4F),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateWidget("Payment Date", record.paymentDate),
                _buildMonthWidget(),
                _buildDateWidget("Due Date", record.dueDate),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildAmountText(
                        'Paid: ',
                        '₹${record.paidAmount}',
                        Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _buildPaymentModeWidget(),
                    ],
                  ),
                ),
                if (hasDue)
                  _buildAmountText(
                    'Due: ',
                    '₹${record.dueAmount}',
                    Colors.red.shade300,
                  ),
              ],
            ),
            Divider(color: Color(0xffDCD7C9), height: 20, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => onDelete(record),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Color(0xffDCD7C9),
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Color(0xffDCD7C9),
                      fontFamily: 'Nunito',
                      fontSize: 13,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.red.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (hasDue)
                  TextButton.icon(
                    onPressed:
                        () => onClearDue(record.customerId, record.recordId),

                    icon: const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: Color(0xffDCD7C9),
                    ),
                    label: const Text(
                      'Clear Due',
                      style: TextStyle(
                        color: Color(0xffDCD7C9),
                        fontFamily: 'Nunito',
                        fontSize: 13,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      backgroundColor: Colors.green.withAlpha(100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

  RichText _buildAmountText(String label, String amount, Color amountColor) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Color(0xffDCD7C9), fontFamily: 'Nunito'),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: amount,
            style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Column _buildDateWidget(String heading, DateTime date) {
    final DateFormat dateFormat = DateFormat('dd MMM, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xffDCD7C9).withAlpha(150),
            fontFamily: 'Nunito',
          ),
        ),
        Text(
          dateFormat.format(date),
          style: const TextStyle(
            color: Color(0xffDCD7C9),
            fontFamily: 'Nunito',
          ),
        ),
      ],
    );
  }

  Container _buildMonthWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffDCD7C9).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '${record.membershipDuration}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffDCD7C9),
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(width: 4),
          Text(
            record.membershipDuration == 1 ? 'Month' : 'Months',
            style: TextStyle(
              color: const Color(0xffDCD7C9).withAlpha(200),
              fontSize: 12,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPaymentModeWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPaymentModeColor(record.paymentMode).withAlpha(50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            _getPaymentModeIcon(record.paymentMode),
            size: 14,
            color: _getPaymentModeColor(record.paymentMode),
          ),
          const SizedBox(width: 4),
          Text(
            record.paymentMode.toString().split('.').last,
            style: TextStyle(
              color: _getPaymentModeColor(record.paymentMode),
              fontSize: 12,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentModeIcon(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return Icons.money;
      case PaymentMode.card:
        return Icons.credit_card;
      case PaymentMode.gpay:
        return Icons.g_mobiledata;
      case PaymentMode.phonePay:
        return Icons.phone_android;
    }
  }

  Color _getPaymentModeColor(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return Colors.green.shade300;
      case PaymentMode.card:
        return Colors.blue.shade300;
      case PaymentMode.gpay:
        return Colors.teal.shade300;
      case PaymentMode.phonePay:
        return Colors.indigoAccent.shade100;
    }
  }
}
