import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/frontend/pages/add_membership_page.dart';
import 'package:gym_sync/frontend/styles/styles.dart';
import 'package:gym_sync/frontend/widgets/custom_button.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:get/get.dart';
import 'package:gym_sync/frontend/widgets/snak_bar.dart';
import 'package:gym_sync/utils/debug/debug_print.dart';

class EnrollEditCustomerPage extends StatefulWidget {
  final int? existingCustomerId;
  const EnrollEditCustomerPage({super.key, this.existingCustomerId});

  @override
  State<EnrollEditCustomerPage> createState() => _EnrollEditCustomerPageState();
}

class _EnrollEditCustomerPageState extends State<EnrollEditCustomerPage> {
  final CustomerController _customerController = Get.put(CustomerController());
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _selectedDate;
  @override
  void initState() {
    super.initState();
    _isEditing = (widget.existingCustomerId != null);
    if (_isEditing) {
      Customer? existingCustomer = _customerController.getCustomerById(
        widget.existingCustomerId!,
      );
      if (existingCustomer == null) {
        debugLog("Error: Customer not found id${widget.existingCustomerId}");
      }
      _nameController.text = existingCustomer!.name;
      _phoneController.text = existingCustomer.phoneNumber;
      _dobController.text = existingCustomer.dob;
      _emailController.text = existingCustomer.email ?? "";
      _heightController.text = "${existingCustomer.height ?? 0}";
      _weightController.text = "${existingCustomer.weight ?? 0}";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return customDatePickerTheme(context, child!);
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _proceedToNextStep() async {
    if (_formKey.currentState!.validate()) {
      // Create customer object
      final customer = Customer(
        id:
            _isEditing
                ? widget.existingCustomerId!
                : 0, // ID will be assigned by database
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text,
        dob: _dobController.text,
        email:
            _emailController.text.isEmpty ? null : _emailController.text.trim(),
        height:
            _heightController.text.isEmpty
                ? null
                : int.parse(_heightController.text.trim()),
        weight:
            _weightController.text.isEmpty
                ? null
                : int.parse(_weightController.text.trim()),
        records: [],
      );
      if (_isEditing) {
        bool updated = await _customerController.updateCustomerInfo(
          widget.existingCustomerId!,
          customer,
        );
        if (updated) {
          AppSnackBar.showSuccess("Updated Customer Info");
          Navigator.pop(context);
        } else {
          AppSnackBar.showError("Failed to Update Customer Info");
        }
      } else {
        navigateToAddMembershipPage(customer);
      }
    }
  }

  void navigateToAddMembershipPage(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddMembershipPage(customer: customer, newCustomer: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: AutoSizeText(
          _isEditing ? "Edit Customer Details" : "Enroll Customer",
          style: TextStyle(
            color: Theme.of(context).highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Theme.of(context).highlightColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                AutoSizeText(
                  'Personal Information',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  cursorColor: Theme.of(context).highlightColor,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  style: TextStyle(color: Theme.of(context).highlightColor),
                  decoration: customTextFieldInputDecoration(
                    context,
                    'Full Name',
                    Icons.person,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Field
                TextFormField(
                  cursorColor: Theme.of(context).highlightColor,
                  controller: _phoneController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      10,
                    ), // Limit to 20 characters
                    FilteringTextInputFormatter.digitsOnly,
                  ],

                  style: TextStyle(color: Theme.of(context).highlightColor),
                  decoration: customTextFieldInputDecoration(
                    context,
                    'Phone Number',
                    Icons.phone,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date of Birth Field
                TextFormField(
                  controller: _dobController,
                  style: TextStyle(color: Theme.of(context).highlightColor),
                  decoration: customTextFieldInputDecoration(
                    context,
                    'Date of Birth',
                    Icons.calendar_today,
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field (Optional)
                TextFormField(
                  controller: _emailController,
                  cursorColor: Theme.of(context).highlightColor,
                  style: TextStyle(color: Theme.of(context).highlightColor),
                  decoration: customTextFieldInputDecoration(
                    context,
                    'Email (Optional)',
                    Icons.email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Physical Attributes Section
                AutoSizeText(
                  'Physical Attributes (Optional)',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Height and Weight in one row
                Row(
                  children: [
                    // Height Field
                    Expanded(
                      child: TextFormField(
                        cursorColor: Theme.of(context).highlightColor,
                        controller: _heightController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                        ),
                        decoration: customTextFieldInputDecoration(
                          context,
                          'Height (cm)',
                          Icons.height,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Weight Field
                    Expanded(
                      child: TextFormField(
                        cursorColor: Theme.of(context).highlightColor,
                        controller: _weightController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                        ),
                        decoration: customTextFieldInputDecoration(
                          context,
                          'Weight (kg)',
                          Icons.fitness_center,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Next Button
                CustomButton(
                  title:
                      _isEditing ? "Save Changes" : "Next: Membership Details",
                  onPressed: _proceedToNextStep,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
