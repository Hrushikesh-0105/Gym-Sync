import 'package:flutter/foundation.dart';

class MembershipRecord {
  int recordId;
  int customerId;
  int membershipDuration;
  int paidAmount;
  int dueAmount;
  DateTime paymentDate;
  DateTime dueDate;
  PaymentMode paymentMode;

  MembershipRecord({
    required this.recordId,
    required this.customerId,
    required this.membershipDuration,
    required this.paidAmount,
    required this.dueAmount,
    required this.paymentDate,
    required this.dueDate,
    required this.paymentMode,
  });

  Map<String, dynamic> toMap() {
    return {
      // MembershipRecordKeys.recordId: recordId,
      MembershipRecordKeys.customerId: customerId,
      MembershipRecordKeys.membershipDuration: membershipDuration,
      MembershipRecordKeys.paidAmount: paidAmount,
      MembershipRecordKeys.dueAmount: dueAmount,
      MembershipRecordKeys.paymentDate: _formatDate(paymentDate),
      MembershipRecordKeys.dueDate: _formatDate(dueDate),
      MembershipRecordKeys.paymentMode: paymentMode.index, // Stored as int
    };
  }

  void printMembershipRecord() {
    if (kDebugMode) {
      print('Record ID: $recordId');
      print('Customer ID: $customerId');
      print('Membership Duration: $membershipDuration months');
      print('Paid Amount: \$$paidAmount');
      print('Due Amount: \$$dueAmount');
      print('Payment Date: ${paymentDate.toLocal()}');
      print('Due Date: ${dueDate.toLocal()}');
      print('Payment Mode: ${paymentMode.name}');
      print('---');
    }
  }

  // Create a MembershipRecord from a Map
  factory MembershipRecord.fromMap(Map<String, dynamic> map) {
    return MembershipRecord(
      recordId: map[MembershipRecordKeys.recordId],
      customerId: map[MembershipRecordKeys.customerId],
      membershipDuration: map[MembershipRecordKeys.membershipDuration],
      paidAmount: map[MembershipRecordKeys.paidAmount],
      dueAmount: map[MembershipRecordKeys.dueAmount],
      paymentDate: DateTime.parse(map[MembershipRecordKeys.paymentDate]),
      dueDate: DateTime.parse(map[MembershipRecordKeys.dueDate]),
      paymentMode: PaymentMode.values[map[MembershipRecordKeys.paymentMode]],
    );
  }

  // Helper function to format DateTime as YYYY-MM-DD
  static String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  bool get isActive => !calculateExpiration();

  bool calculateExpiration() {
    DateTime today = DateTime.now();
    DateTime onlyToday = DateTime(today.year, today.month, today.day);

    return onlyToday.isAfter(dueDate) || onlyToday.isAtSameMomentAs(dueDate);
  }
}

class MembershipRecordKeys {
  static const String tableName = 'membership_records';
  static const String recordId = 'recordId';
  static const String customerId = 'customerId';
  static const String membershipDuration = 'membershipDuration';
  static const String paidAmount = 'paidAmount';
  static const String dueAmount = 'dueAmount';
  static const String paymentDate = 'paymentDate';
  static const String dueDate = 'dueDate';
  static const String paymentMode = 'paymentMode';
}

enum PaymentMode { cash, card, gpay, phonePay }
