import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/frontend/styles/styles.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onPressed;
  final Function(Customer customer) onMessage;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onPressed,
    required this.onMessage,
  });

  int get _daysDifference {
    if (customer.records.isEmpty) return 0;

    DateTime today = DateTime.now();
    DateTime dueDate = customer.records[0].dueDate;

    return (dueDate.difference(today).inDays).abs();
  }

  bool get _isExpired {
    if (customer.records.isEmpty) {
      return true;
    }
    return customer.records[0].calculateExpiration();
  }

  bool get _recordExists => customer.records.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Additional colors for enhanced aesthetics
    final Color accentColor = const Color(0xffA27B5C);
    final Color textSecondaryColor = const Color(0xffDCD7C9).withOpacity(0.8);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Status indicator as a left border
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _getStatusColor().withOpacity(0.8),
                        _getStatusColor(),
                      ],
                    ),
                  ),
                ),
              ),

              // Card content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                child: Row(
                  children: [
                    // Avatar circle with first letter of name
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: accentColor,
                      child: Text(
                        customer.name.isNotEmpty
                            ? customer.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Customer Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name with subtle decoration
                          Row(
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  customer.name,
                                  style: TextStyle(
                                    color: Theme.of(context).highlightColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Membership Status with badge style
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor().withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getStatusColor().withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(),
                                  style: TextStyle(
                                    color: _getStatusColor(),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Days Left/Expired
                              if (_recordExists)
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        _isExpired
                                            ? Icons.history
                                            : Icons.access_time,
                                        size: 14,
                                        color: textSecondaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: AutoSizeText(
                                          _isExpired
                                              ? '${_daysDifference.abs()} days ago'
                                              : '$_daysDifference days left',
                                          style: TextStyle(
                                            color: textSecondaryColor,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (_isExpired && _recordExists)
                      IconButton(
                        onPressed: () {
                          onMessage(customer);
                        },
                        icon: Icon(
                          Icons.message_outlined,
                          color: Theme.of(
                            context,
                          ).highlightColor.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText() {
    if (!_recordExists) return 'Inactive';
    return _isExpired ? 'Expired' : 'Active';
  }

  Color _getStatusColor() {
    if (!_recordExists) return AppColors.inactive;
    return _isExpired ? AppColors.expired : AppColors.active;
  }
}
