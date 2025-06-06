import 'package:flutter/foundation.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';

class Customer {
  int id;
  String name;
  String phoneNumber;
  String dob;
  String? email;
  int? height;
  int? weight;
  List<MembershipRecord> records; //just for getx

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.dob,
    required this.records,
    this.email,
    this.height,
    this.weight,
  });

  // Convert Customer to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      // CustomerKeys.id: id,
      CustomerKeys.name: name,
      CustomerKeys.phoneNumber: phoneNumber,
      CustomerKeys.dob: dob,
      CustomerKeys.email: email ?? '',
      CustomerKeys.height: height ?? 0,
      CustomerKeys.weight: weight ?? 0,
    };
  }

  void printCustomer() {
    if (kDebugMode) {
      print('Customer Details:');
      print('ID: $id');
      print('Name: $name');
      print('Phone: $phoneNumber');
      print('DOB: $dob');
      if (email != null) print('Email: $email');
      if (height != null) print('Height: $height cm');
      if (weight != null) print('Weight: $weight kg');

      if (records.isNotEmpty) {
        print('\nMembership Records:');
        for (var record in records) {
          record.printMembershipRecord();
        }
      }
      print("--------------------------------------");
    }
  }

  // Create a Customer from a Map (used when fetching from SQLite)
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map[CustomerKeys.id] ?? 0,
      name: map[CustomerKeys.name] ?? "",
      phoneNumber: map[CustomerKeys.phoneNumber] ?? "",
      dob: map[CustomerKeys.dob] ?? "",
      email: map[CustomerKeys.email] ?? "",
      height: map[CustomerKeys.height] ?? 0,
      weight: map[CustomerKeys.weight] ?? 0,
      records: [], //empty list, will be filled in later
    );
  }

  // Helper to check if there's an active membership
  bool get hasActiveRecord => records.any((record) => record.isActive);

  // Get active records
  List<MembershipRecord> get activeRecords =>
      records.where((record) => record.isActive).toList();

  // Get past records
  List<MembershipRecord> get pastRecords =>
      records.where((record) => !record.isActive).toList();

  void updateCustomerInfo(Customer customer) {
    name = customer.name;
    phoneNumber = customer.phoneNumber;
    email = customer.email;
    dob = customer.dob;
    height = customer.height;
    weight = customer.weight;
    //records are not changed
  }
}

class CustomerKeys {
  static const String tableName = 'customers';
  static const String id = 'id';
  static const String name = 'name';
  static const String phoneNumber = 'phoneNumber';
  static const String dob = 'dob';
  static const String email = 'email';
  static const String height = 'height';
  static const String weight = 'weight';
}
