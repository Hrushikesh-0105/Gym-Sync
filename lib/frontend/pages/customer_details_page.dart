import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/frontend/pages/add_membership_page.dart';
import 'package:gym_sync/frontend/pages/enroll_edit_customer_page.dart';
import 'package:gym_sync/frontend/widgets/custom_button.dart';
import 'package:gym_sync/frontend/widgets/customer_info_card.dart';
import 'package:gym_sync/frontend/widgets/delete_customer_dialog.dart';
import 'package:gym_sync/frontend/widgets/delete_record_dialog.dart';
import 'package:gym_sync/frontend/widgets/membership_record_card.dart';
import 'package:gym_sync/frontend/widgets/snak_bar.dart';

class CustomerDetailsPage extends StatelessWidget {
  final int customerId;

  CustomerDetailsPage({super.key, required this.customerId});
  final CustomerController customerController = Get.put(CustomerController());

  void _clearDue(int customerId, int recordId) async {
    bool dueCleared = await customerController.clearDueOfRecordGetx(
      customerId,
      recordId,
    );
    if (dueCleared) {
      AppSnackBar.showSuccess("Due cleared!");
    } else {
      AppSnackBar.showSuccess("Failed to clear Due (Internal Error)");
    }
  }

  void _deleteRecord(BuildContext context, MembershipRecord currentRecord) {
    showDialog(
      context: context,
      builder:
          (context) => DeleteRecordDialog(
            record: currentRecord,
            onDelete: () async {
              bool recordDeleted = await customerController
                  .deleteMembershipRecordGetx(
                    currentRecord.customerId,
                    currentRecord.recordId,
                  );
              if (recordDeleted) {
                AppSnackBar.showSuccess("Membership deleted!");
              } else {
                AppSnackBar.showSuccess(
                  "Failed to delete Membership (Internal Error)",
                );
              }
              Navigator.pop(context);
            },
          ),
    );
  }

  void _addMembershipRecord(BuildContext context, Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddMembershipPage(customer: customer, newCustomer: false),
      ),
    );
  }

  void _deleteCustomer(BuildContext context, int customerId) {
    Customer? currentCustomer = customerController.getCustomerById(customerId);
    if (currentCustomer != null) {
      showDialog(
        context: context,
        builder:
            (context) => DeleteCustomerDialog(
              customer: currentCustomer,
              onDelete: () async {
                bool customerDeleted = await customerController.deleteCustomer(
                  currentCustomer.id,
                );
                if (customerDeleted) {
                  AppSnackBar.showSuccess("Customer data deleted!");
                  Get.offAllNamed('/base');
                } else {
                  AppSnackBar.showSuccess(
                    "Failed to delete Customer data (Internal Error)",
                  );
                  Get.back(); //go to previous page
                }
              },
            ),
      );
    }
  }

  void _editCustomer(BuildContext context, int customerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EnrollEditCustomerPage(existingCustomerId: customerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Count active memberships

    return Scaffold(
      backgroundColor: const Color(0xff2C3639),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff3F4E4F),
        title: Text(
          'Customer Details',
          style: TextStyle(
            color: const Color(0xffDCD7C9),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(
          color: const Color(0xffDCD7C9),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Obx(() {
        Customer? customer = customerController.getCustomerById(customerId);

        return customer != null
            ? Column(
              children: [
                // Customer Information Card
                CustomerInfoCard(
                  customer: customer,
                  onDelete:
                      (customerId) => _deleteCustomer(context, customerId),
                  onEdit: (customerId) => _editCustomer(context, customerId),
                ),

                // Renew button if no active memberships
                if (!customer.hasActiveRecord)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: CustomButton(
                      title: "Renew Membership",
                      iconData: Icons.refresh,
                      onPressed: () => _addMembershipRecord(context, customer),
                    ),
                  ),

                // Membership Records
                Expanded(child: _buildMembershipRecordsList(context, customer)),
              ],
            )
            : Center(
              child: Text(
                "Customer Not Found!",
                style: TextStyle(color: Color(0xffDCD7C9)),
              ),
            );
      }),
    );
  }

  Widget _buildMembershipRecordsList(BuildContext context, Customer customer) {
    final activeRecords = customer.activeRecords;
    final pastRecords = customer.pastRecords;

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            indicatorColor: const Color(0xffDCD7C9),
            labelColor: const Color(0xffDCD7C9),
            unselectedLabelColor: const Color(0xffDCD7C9).withAlpha(100),
            labelStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Nunito'),
            tabs: [
              Tab(
                text:
                    'Active Membership${activeRecords.isNotEmpty ? " (${activeRecords.length})" : ""}',
              ),
              Tab(text: 'History (${pastRecords.length})'),
            ],
          ),

          Expanded(
            child: TabBarView(
              children: [
                // Active Memberships Tab
                activeRecords.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 48,
                            color: const Color(0xffDCD7C9).withAlpha(100),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No active membership',
                            style: TextStyle(
                              color: Color(0xffDCD7C9),
                              fontFamily: 'Nunito',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: activeRecords.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return MembershipRecordCard(
                          record: activeRecords[index],
                          onClearDue:
                              (customerId, recordId) =>
                                  _clearDue(customerId, recordId),
                          onDelete:
                              (currentRecord) =>
                                  _deleteRecord(context, currentRecord),
                        );
                      },
                    ),

                // Past Memberships Tab
                pastRecords.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: const Color(0xffDCD7C9).withAlpha(100),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No membership history',
                            style: TextStyle(
                              color: Color(0xffDCD7C9),
                              fontFamily: 'Nunito',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: pastRecords.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return MembershipRecordCard(
                          record: pastRecords[index],
                          onClearDue:
                              (customerId, recordId) =>
                                  _clearDue(customerId, recordId),
                          onDelete:
                              (currentRecord) =>
                                  _deleteRecord(context, currentRecord),
                        );
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
