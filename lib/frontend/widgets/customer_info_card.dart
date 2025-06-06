import 'package:flutter/material.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/frontend/styles/styles.dart';

class CustomerInfoCard extends StatelessWidget {
  final Customer customer;
  final Function(int customerId) onEdit;
  final Function(int customerId) onDelete;

  const CustomerInfoCard({
    super.key,
    required this.customer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: const Color(0xff3F4E4F),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer header section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xffDCD7C9).withOpacity(0.2),
                  child: Text(
                    customer.name.isNotEmpty
                        ? customer.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffDCD7C9),
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Customer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name with menu button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              customer.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffDCD7C9),
                                fontFamily: 'Nunito',
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: PopupMenuButton<String>(
                              color: const Color(0xff364244),
                              onSelected: (value) {
                                if (value == 'Edit') {
                                  onEdit(customer.id);
                                } else if (value == 'Delete') {
                                  onDelete(customer.id);
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    _buildPopupMenuItem(
                                      "Edit",
                                      Icons.edit,
                                      null,
                                    ),
                                    _buildPopupMenuItem(
                                      "Delete",
                                      Icons.delete,
                                      Colors.red,
                                    ),
                                  ],
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color(0xffDCD7C9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Contact information
                      _buildInfoRow(Icons.phone, customer.phoneNumber),
                      if (customer.email != null && customer.email!.isNotEmpty)
                        _buildInfoRow(Icons.email, customer.email!),
                      _buildInfoRow(Icons.cake, customer.dob),
                    ],
                  ),
                ),
              ],
            ),
            // Divider
            const Divider(color: Color(0xffDCD7C9), height: 24, thickness: 0.5),
            // Stats section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Customer ID', '#${customer.id}', Icons.badge),
                if (customer.height != null)
                  _buildStatColumn(
                    'Height',
                    '${customer.height} cm',
                    Icons.height,
                  ),
                if (customer.weight != null)
                  _buildStatColumn(
                    'Weight',
                    '${customer.weight} kg',
                    Icons.monitor_weight,
                  ),
                _buildStatColumn(
                  'Status',
                  getStatusText(),
                  getStatusIcon(),
                  statusColor: getStatusColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String itemName,
    IconData icon,
    Color? itemColor,
  ) {
    return PopupMenuItem<String>(
      value: itemName,
      child: Row(
        children: [
          Icon(icon, color: itemColor ?? Color(0xffDFDBCE)),
          const SizedBox(width: 10),
          Text(
            itemName,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: itemColor ?? Color(0xffDCD7C9),
            ),
          ),
        ],
      ),
    );
  }

  String getStatusText() {
    String status;
    if (customer.records.isEmpty) {
      status = "Inactive";
    } else if (customer.hasActiveRecord) {
      status = "Active";
    } else {
      status = "Expired";
    }
    return status;
  }

  IconData getStatusIcon() {
    IconData statusIcon;
    if (customer.records.isEmpty) {
      statusIcon = Icons.cancel_outlined;
    } else if (customer.hasActiveRecord) {
      statusIcon = Icons.check_circle;
    } else {
      statusIcon = Icons.warning_amber_rounded;
    }
    return statusIcon;
  }

  Color getStatusColor() {
    Color statusColor;
    if (customer.records.isEmpty) {
      statusColor = AppColors.inactive;
    } else if (customer.hasActiveRecord) {
      statusColor = AppColors.active;
    } else {
      statusColor = AppColors.expired;
    }
    return statusColor;
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xffDCD7C9).withOpacity(0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xffDCD7C9).withOpacity(0.9),
                fontFamily: 'Nunito',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: statusColor ?? const Color(0xffDCD7C9).withOpacity(0.8),
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: statusColor ?? const Color(0xffDCD7C9),
            fontFamily: 'Nunito',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xffDCD7C9).withOpacity(0.7),
            fontFamily: 'Nunito',
          ),
        ),
      ],
    );
  }
}
