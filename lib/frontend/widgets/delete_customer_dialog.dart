import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/utils/debug/debug_print.dart';

class DeleteCustomerDialog extends StatelessWidget {
  final Customer customer;
  final Function() onDelete;

  const DeleteCustomerDialog({
    Key? key,
    required this.customer,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Count active records
    final int activeRecordsCount =
        customer.records.where((record) => record.isActive).toList().length;
    final CustomerController controller = Get.put(CustomerController());

    return AlertDialog(
      backgroundColor: const Color(0xff2C3639),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          const Icon(Icons.delete_forever, color: Colors.red, size: 28),
          const SizedBox(width: 8),
          Text(
            'Delete Customer',
            style: const TextStyle(
              color: Color(0xffDCD7C9),
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xffDCD7C9),
                fontFamily: 'Nunito',
                fontSize: 16,
              ),
              children: [
                const TextSpan(text: 'Are you sure you want to delete '),
                TextSpan(
                  text: "${customer.name}'s",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                TextSpan(text: ' data'),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Customer Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff3F4E4F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('ID:', '#${customer.id}'),
                _buildInfoRow('Phone:', customer.phoneNumber),
                if (customer.email != null && customer.email!.isNotEmpty)
                  _buildInfoRow('Email:', customer.email!),
                _buildInfoRow(
                  'Records:',
                  '${customer.records.length} ($activeRecordsCount active)',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Warning message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xffDCD7C9),
                        fontFamily: 'Nunito',
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'This action cannot be undone. Deleting this customer will permanently remove ',
                        ),
                        TextSpan(
                          text:
                              'all ${customer.records.length} membership records',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' associated with this customer.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                    debugLog("isLoading: ${controller.isLoading.value}");
                    Navigator.of(context).pop();
                  },
          child: Text(
            'Cancel',
            style: const TextStyle(
              color: Color(0xffDCD7C9),
              fontFamily: 'Nunito',
            ),
          ),
        ),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => onDelete(),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Color(0xffDCD7C9),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Delete',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                color: Color(0xffDCD7C9),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                color: Color(0xffDCD7C9),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
