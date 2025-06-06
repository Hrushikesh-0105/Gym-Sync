import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
// import 'package:gym_sync/frontend/pages/base_app_layout.dart';
import 'package:gym_sync/frontend/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({Key? key}) : super(key: key);

  @override
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();

  @override
  void dispose() {
    _gymNameController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final CustomerController customerController = Get.put(
        CustomerController(),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("gymName", _gymNameController.text.trim());
      await prefs.setString("ownerName", _ownerNameController.text.trim());
      customerController.gymName = _gymNameController.text.trim();
      customerController.ownerName = _ownerNameController.text.trim();
      Get.offAllNamed('/base'); //pop full stack and psuh base page
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors from your scheme
    const scaffoldBackgroundColor = Color(0xff2C3639);
    const primaryColor = Color(0xff3F4E4F);
    const highlightColor = Color(0xffDCD7C9);
    const lightTextColor = Color(0xffEEEBE3);
    const buttonColor = Color(0xffA27B5C);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Profile Setup",
          style: TextStyle(color: lightTextColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: highlightColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  "Let's Get to Know You",
                  style: TextStyle(
                    color: lightTextColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Please provide your gym details to personalize your experience",
                  style: TextStyle(
                    color: highlightColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),

                // Gym Name Field
                Text(
                  "Gym Name",
                  style: TextStyle(
                    color: highlightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _gymNameController,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  cursorColor: highlightColor,
                  decoration: customTextFieldInputDecoration(
                    context,
                    "Gym Name",
                    Icons.fitness_center_outlined,
                  ),
                  style: TextStyle(color: lightTextColor, fontSize: 16),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Gym name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Owner Name Field
                Text(
                  "Owner Name",
                  style: TextStyle(
                    color: highlightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ownerNameController,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  cursorColor: highlightColor,
                  decoration: customTextFieldInputDecoration(
                    context,
                    "Name",
                    Icons.abc_outlined,
                  ),
                  style: TextStyle(color: lightTextColor, fontSize: 16),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Owner name is required";
                    }
                    return null;
                  },
                ),

                const Spacer(),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: lightTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
