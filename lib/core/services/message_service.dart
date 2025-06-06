import 'package:get/get.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';
import 'package:gym_sync/core/state/getx_controller.dart';
import 'package:gym_sync/utils/debug/debug_print.dart';
import 'package:flutter_native_sms/flutter_native_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

enum MessageType { enrolled, renewed, expired }

class MessageService {
  static Future<bool> sendSMS(String phoneNumber, String message) async {
    FlutterNativeSms sms = FlutterNativeSms();
    bool smsSent = false;
    var status = await Permission.sms.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      status = await Permission.sms.request();
    }
    if (await Permission.phone.status.isDenied) {
      await Permission.phone.request();
    }
    status = await Permission.sms.status;
    if (status.isGranted && await Permission.phone.status.isGranted) {
      try {
        smsSent = await sms.send(
          phone: phoneNumber,
          smsBody: message,
          sim: "0",
        );
        debugLog("Sms sent");
        smsSent = true;
      } catch (e) {
        debugLog("Failed to send sms: $e");
        smsSent = false;
      }
    } else {
      debugLog("Sms or phone permissions not granted");
    }
    return smsSent;
  }

  static Future<bool> sendWhatsappMessage(
    String phoneNumber,
    String message,
  ) async {
    bool messageSent = true;
    final Uri whatsappUri = Uri.parse(
      "whatsapp://send?phone=+91$phoneNumber&text=${Uri.encodeComponent(message)}",
    );
    try {
      messageSent = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      messageSent = false;
    }
    return messageSent;
  }

  static Future<bool> sendSMSCustomer(
    Customer customer,
    MessageType type,
  ) async {
    String message = createMessage(customer, type);
    String phoneNumber = customer.phoneNumber;
    bool messageSent = false;
    if (phoneNumber.isNotEmpty) {
      messageSent = await sendSMS(phoneNumber, message);
    }
    return messageSent;
  }

  static Future<bool> sendWhatsappMessageCustomer(
    Customer customer,
    MessageType type,
  ) async {
    String message = createMessage(customer, type);
    String phoneNumber = customer.phoneNumber;
    bool messageSent = false;
    if (phoneNumber.isNotEmpty) {
      messageSent = await sendWhatsappMessage(phoneNumber, message);
    }
    return messageSent;
  }

  static String createMessage(Customer customer, MessageType type) {
    String message;
    final CustomerController customerController = Get.put(CustomerController());
    if (customer.records.isEmpty) {
      return "Dear ${customer.name}, we could not find your membership details. Please contact the gym.\n${customerController.gymName}";
    }

    MembershipRecord latestRecord = customer.records.first;

    String paymentDate = _formatDate(latestRecord.paymentDate);
    String dueDate = _formatDate(latestRecord.dueDate);
    String amountPaid = latestRecord.paidAmount.toString();

    switch (type) {
      case MessageType.enrolled:
        message =
            "Dear ${customer.name}\nThank you for enrolling at ${customerController.gymName}.\nAmount Paid: Rs.$amountPaid.\nPayment Date: $paymentDate.\nDue Date: $dueDate.";
        break;
      case MessageType.renewed:
        message =
            "Dear ${customer.name}\nYour membership renewal is successful.\nAmount Paid: Rs.$amountPaid.\nPayment Date: $paymentDate.\nDue Date: $dueDate.\n-${customerController.gymName}";
        break;
      case MessageType.expired:
        message =
            "Dear ${customer.name}\nYour gym membership has expired on $dueDate.\nRenew today to continue your fitness journey!\n-${customerController.gymName}";
        break;
    }
    debugLog(message);
    debugLog("Message Length: ${message.length}");
    return message;
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }
}
