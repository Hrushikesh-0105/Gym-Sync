import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';
import 'package:gym_sync/core/services/message_service.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/frontend/styles/styles.dart';
// import 'package:gym_sync/frontend/widgets/custom_button.dart';
import 'package:gym_sync/frontend/widgets/membership_duration_selector.dart';
import 'package:gym_sync/frontend/widgets/message_chip_widget.dart';
import 'package:gym_sync/frontend/widgets/payment_mode_selector.dart';
import 'package:gym_sync/frontend/widgets/snak_bar.dart';
// import 'package:gym_sync/utils/debug/debug_print.dart';
// import 'package:gym_sync/utils/debug/debug_print.dart';

class AddMembershipPage extends StatefulWidget {
  final Customer customer;
  final bool newCustomer;

  const AddMembershipPage({
    super.key,
    required this.customer,
    required this.newCustomer,
  });

  @override
  State createState() => _AddMembershipPageState();
}

class _AddMembershipPageState extends State<AddMembershipPage> {
  final CustomerController customerController = Get.put(CustomerController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _dueAmountController = TextEditingController();
  int _selectedDuration = 1;
  final List<int> _availableDurations = [1, 2, 3, 6, 12];

  DateTime _paymentDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  PaymentMode _selectedPaymentMode = PaymentMode.cash;
  bool whatsappSelected = true;
  bool smsSelected = true;

  @override
  void initState() {
    super.initState();
    _calculateDueDate();
  }

  @override
  void dispose() {
    // _durationController.dispose();
    _paidAmountController.dispose();
    _dueAmountController.dispose();
    super.dispose();
  }

  void _calculateDueDate() {
    // Calculate due date based on duration
    int months = _selectedDuration;
    _dueDate = DateTime(
      _paymentDate.year,
      _paymentDate.month + months,
      _paymentDate.day,
    );
    setState(() {});
  }

  Future<void> _selectPaymentDate(BuildContext context) async {
    DateTime firstDate = DateTime(DateTime.now().year, 1, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: firstDate,
      lastDate: DateTime(firstDate.year + 5, 12, 31),
      builder: (context, child) => customDatePickerTheme(context, child!),
    );
    if (picked != null && picked != _paymentDate) {
      setState(() {
        _paymentDate = picked;
        _calculateDueDate();
      });
    }
  }

  void _saveMembership() async {
    if (_formKey.currentState!.validate()) {
      MembershipRecord membershipRecord = MembershipRecord(
        recordId: 0,
        customerId: widget.customer.id,
        membershipDuration: _selectedDuration,
        paidAmount: int.parse(_paidAmountController.text),
        dueAmount:
            _dueAmountController.text.isEmpty
                ? 0
                : int.parse(_dueAmountController.text),
        paymentDate: DateTime(
          _paymentDate.year,
          _paymentDate.month,
          _paymentDate.day,
        ),
        dueDate: DateTime(_dueDate.year, _dueDate.month, _dueDate.day),
        paymentMode: _selectedPaymentMode,
      );
      if (widget.newCustomer) {
        bool saved = await _handleNewCustomer(
          widget.customer,
          membershipRecord,
        );
        if (saved) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/base', (route) => false);
        }
      } else {
        bool saved = await _handleExistingCustomer(
          widget.customer,
          membershipRecord,
        );
        if (saved) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<bool> _handleNewCustomer(
    Customer newCustomer,
    MembershipRecord newMembershipRecord,
  ) async {
    int newCustomerID = 0;
    newCustomerID = await customerController.addCustomer(
      newCustomer,
      newMembershipRecord,
    );
    // ignore: unrelated_type_equality_checks
    if (newCustomer != 0) {
      AppSnackBar.showSuccess("Customer Enrolled Successfully");
      await _sendMessage(
        customerController.getCustomerById(newCustomerID)!,
        MessageType.enrolled,
      );
    } else {
      AppSnackBar.showError("Failed to Enroll Customer");
    }
    return (newCustomerID != 0);
    // Navigate to home or customer details page
  }

  Future<bool> _handleExistingCustomer(
    Customer customer,
    MembershipRecord newMembershipRecord,
  ) async {
    bool status = await customerController.addRecordToCustomer(
      customer.id,
      newMembershipRecord,
    );
    if (status) {
      AppSnackBar.showSuccess("Membership Renewed Successfully");
      await _sendMessage(customer, MessageType.renewed);
    } else {
      AppSnackBar.showError("Failed Renew Membership");
    }
    return status;
  }

  Future<void> _sendMessage(Customer customer, MessageType type) async {
    if (smsSelected) {
      bool smsSent = await MessageService.sendSMSCustomer(customer, type);
      if (smsSent) {
        AppSnackBar.showSuccess("SMS Sent!");
      } else {
        AppSnackBar.showSuccess("Failed to send SMS");
      }
    }
    if (whatsappSelected) {
      await MessageService.sendWhatsappMessageCustomer(customer, type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          'Membership Details',
          style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).highlightColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerCard(),
              const SizedBox(height: 16),
              AutoSizeText(
                'Membership Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              const SizedBox(height: 12),
              MembershipDurationSelector(
                availableDurations: _availableDurations,
                initialDuration: _selectedDuration,
                onDurationSelected: (duration) {
                  setState(() {
                    _selectedDuration = duration;
                    _calculateDueDate();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                cursorColor: Theme.of(context).highlightColor,

                controller: _paidAmountController,
                decoration: customTextFieldInputDecoration(
                  context,
                  'Paid Amount',
                  Icons.attach_money,
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Theme.of(context).highlightColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter paid amount';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Due Amount TextField
              TextFormField(
                cursorColor: Theme.of(context).highlightColor,
                controller: _dueAmountController,
                decoration: customTextFieldInputDecoration(
                  context,
                  'Due Amount',
                  Icons.money_off,
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Theme.of(context).highlightColor),
              ),
              const SizedBox(height: 24),
              // Date Selection
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectPaymentDate(context),
                      child: InputDecorator(
                        decoration: customTextFieldInputDecoration(
                          context,
                          'Payment Date',
                          Icons.calendar_today,
                        ),
                        child: AutoSizeText(
                          DateFormat('dd-MM-yyyy').format(_paymentDate),
                          style: TextStyle(
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputDecorator(
                      decoration: customTextFieldInputDecoration(
                        context,
                        'Due Date',
                        Icons.event,
                      ),
                      child: AutoSizeText(
                        DateFormat('dd-MM-yyyy').format(_dueDate),
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Payment Mode Selection
              AutoSizeText(
                'Payment Mode',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              const SizedBox(height: 5),
              PaymentModeSelector(
                initialMode: PaymentMode.cash,
                onModeSelected: (mode) {
                  _selectedPaymentMode = mode;
                },
              ),

              const SizedBox(height: 10),
              AutoSizeText(
                'Notify',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8.0,
                runSpacing: 5,
                children: [
                  MessageChipWidget(
                    mode: MessagingMode.sms,
                    onSelected: (selected) {
                      smsSelected = selected;
                    },
                    selectedInitially: smsSelected,
                  ),
                  MessageChipWidget(
                    mode: MessagingMode.whatsapp,
                    onSelected: (selected) {
                      whatsappSelected = selected;
                    },
                    selectedInitially: whatsappSelected,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMembership,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).highlightColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: AutoSizeText(
                    widget.newCustomer ? 'Save Membership' : "Renew Membership",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildCustomerCard() {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor.withAlpha(100),
              child: Icon(
                Icons.person,
                color: Theme.of(context).highlightColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.customer.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AutoSizeText(
                    widget.customer.phoneNumber,
                    style: TextStyle(color: Theme.of(context).highlightColor),
                  ),
                ],
              ),
            ),
            if (widget.newCustomer)
              SizedBox(
                height: 30,
                width: 60,
                child: Chip(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  label: Text('New'),
                  backgroundColor: Colors.green,
                  labelStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
