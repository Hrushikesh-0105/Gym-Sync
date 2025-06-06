import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/services/message_service.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/frontend/pages/customer_details_page.dart';
import 'package:gym_sync/frontend/pages/filters_bottom_sheet.dart';
import 'package:gym_sync/frontend/styles/styles.dart';
import 'package:gym_sync/frontend/widgets/customer_main_card.dart';
import 'package:gym_sync/frontend/widgets/message_customer_dialog.dart';
import 'package:gym_sync/frontend/widgets/search_bar.dart';
import 'package:gym_sync/frontend/widgets/snak_bar.dart';
import 'package:gym_sync/utils/debug/debug_print.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  // final TextEditingController _searchController = TextEditingController();
  // List<int> _filteredCustomers = [];
  final CustomerController customerController = Get.put(CustomerController());
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    debugLog("Customers page diposed");
    customerController.resetFilterAndSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search and Filter Row
          Row(
            children: [
              //Search Bar
              CustomSearchBar(
                onSearch: (searchText) {
                  debugLog(searchText);
                  customerController.searchCustomer(searchText);
                },
              ),
              const SizedBox(width: 16),

              //Filter button
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: Theme.of(context).highlightColor,
                    ),
                    onPressed: () {
                      showCustomerFilterSheet(
                        context,
                        customerController.selectedFilter,
                        (filter) {
                          customerController.filterCustomer(filter);
                          setState(() {});
                        },
                      );
                    },
                  ),

                  if (customerController.selectedFilter != CustomerFilter.all)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getFilterColor(
                            customerController.selectedFilter,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Customer List
          Expanded(
            child: Obx(() {
              List<Customer> customerList =
                  customerController.filteredCustomerList;

              return customerList.isNotEmpty
                  ? ListView.builder(
                    itemCount: customerList.length,
                    itemBuilder: (context, index) {
                      return CustomerCard(
                        customer: customerList[index],
                        onPressed: () {
                          navigateToCustomerDetailsPage(customerList[index]);
                        },
                        onMessage: (customer) {
                          showMessageDialog(context, customer);
                        },
                      );
                    },
                  )
                  : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 180,
                          child: Image.asset("assets/images/no_data.png"),
                        ),
                        // SizedBox(height: 10),
                        Text(
                          "No Customer Data Found!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                        Text(
                          "Try adding a customer or changing filter",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ],
                    ),
                  );
            }),
          ),
        ],
      ),
    );
  }

  void navigateToCustomerDetailsPage(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsPage(customerId: customer.id),
      ),
    );
  }

  Color _getFilterColor(CustomerFilter filter) {
    switch (filter) {
      case CustomerFilter.active:
        return AppColors.active;
      case CustomerFilter.expired:
      case CustomerFilter.expiredToday:
        return AppColors.expired;
      case CustomerFilter.inactive:
        return AppColors.inactive;
      default:
        return Theme.of(context).highlightColor;
    }
  }

  void showMessageDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder:
          (context) => MessageCustomerDialog(
            customer: customer,
            onSend: (customer, smsSelected, whatsappSelected) async {
              if (smsSelected) {
                bool smsSent = await MessageService.sendSMSCustomer(
                  customer,
                  MessageType.expired,
                );
                if (smsSent) {
                  AppSnackBar.showSuccess("SMS sent!");
                } else {
                  AppSnackBar.showError("Failed to send SMS");
                }
              }
              Navigator.pop(context);
              if (whatsappSelected) {
                MessageService.sendWhatsappMessageCustomer(
                  customer,
                  MessageType.expired,
                );
              }
            },
          ),
    );
  }
}
