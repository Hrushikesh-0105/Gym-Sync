import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';
import 'package:gym_sync/core/state/getx_controller.dart';

class DeleteRecordDialog extends StatelessWidget {
  final MembershipRecord record;
  final Function() onDelete;

  const DeleteRecordDialog({
    super.key,
    required this.record,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.put(CustomerController());
    final DateFormat dateFormat = DateFormat('dd MMM, yyyy');
    final String paymentDate = dateFormat.format(record.paymentDate);

    return AlertDialog(
      backgroundColor: const Color(0xff2C3639),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Delete Payment Record',
        style: TextStyle(
          color: Color(0xffDCD7C9),
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to delete this payment record?',
            style: TextStyle(
              color: const Color(0xffDCD7C9).withOpacity(0.9),
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff3F4E4F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Payment Date:', paymentDate),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Amount Paid:',
                  '₹${record.paidAmount}',
                  valueColor: Colors.green,
                ),
                if (record.dueAmount > 0) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Due Amount:',
                    '₹${record.dueAmount}',
                    valueColor: Colors.red.shade300,
                  ),
                ],
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Duration:',
                  '${record.membershipDuration} ${record.membershipDuration == 1 ? 'Month' : 'Months'}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This action cannot be undone.',
            style: TextStyle(
              color: Colors.red.shade300,
              fontFamily: 'Nunito',
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: const Color(0xffDCD7C9).withOpacity(0.8),
              fontFamily: 'Nunito',
            ),
          ),
        ),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value ? null : onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child:
                controller.isLoading.value
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xffDCD7C9).withOpacity(0.7),
            fontFamily: 'Nunito',
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xffDCD7C9),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
