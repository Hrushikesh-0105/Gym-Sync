import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';
import 'package:gym_sync/utils/debug/debug_print.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  final String dbName = "MY_GYM_CUSTOMER_INFO.db";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), dbName);
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          try {
            await db.execute("PRAGMA foreign_keys = ON");

            await db.execute('''
              CREATE TABLE ${CustomerKeys.tableName} (
                ${CustomerKeys.id} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${CustomerKeys.name} TEXT NOT NULL,
                ${CustomerKeys.phoneNumber} TEXT NOT NULL,
                ${CustomerKeys.dob} TEXT NOT NULL,
                ${CustomerKeys.email} TEXT NOT NULL,
                ${CustomerKeys.height} INTEGER NOT NULL,
                ${CustomerKeys.weight} INTEGER NOT NULL
              )
            ''');

            await db.execute('''
              CREATE TABLE ${MembershipRecordKeys.tableName} (
                ${MembershipRecordKeys.recordId} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${MembershipRecordKeys.customerId} INTEGER NOT NULL,
                ${MembershipRecordKeys.membershipDuration} INTEGER NOT NULL,
                ${MembershipRecordKeys.paidAmount} INTEGER NOT NULL,
                ${MembershipRecordKeys.dueAmount} INTEGER NOT NULL,
                ${MembershipRecordKeys.paymentDate} TEXT NOT NULL,
                ${MembershipRecordKeys.dueDate} TEXT NOT NULL,
                ${MembershipRecordKeys.paymentMode} INTEGER NOT NULL,
                FOREIGN KEY (${MembershipRecordKeys.customerId}) REFERENCES ${CustomerKeys.tableName}(${CustomerKeys.id}) ON DELETE CASCADE
              )
            ''');
          } catch (e) {
            debugLog("Error creating tables: $e");
          }
        },
      );
    } catch (e) {
      debugLog("Error initializing database: $e");
      rethrow;
    }
  }

  // ---------------- CUSTOMER OPERATIONS ----------------
  Future<int> insertCustomer(Customer customer) async {
    try {
      final db = await instance.database;
      int id = await db.insert(
        CustomerKeys.tableName,
        customer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugLog("Customer inserted with ID: $id");
      return id;
    } catch (e) {
      debugLog("Error inserting customer: $e");
      return -1;
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        CustomerKeys.tableName,
      );
      return maps.map((map) => Customer.fromMap(map)).toList();
    } catch (e) {
      debugLog("Error fetching customers: $e");
      return [];
    }
  }

  Future<bool> updateCustomer(Customer customer) async {
    final db = await instance.database; // Get database instance

    int numRowsAffected = await db.update(
      CustomerKeys.tableName,
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
    return (numRowsAffected == 1);
  }

  Future<bool> deleteCustomer(int id) async {
    try {
      final db = await instance.database;
      int rowsDeleted = await db.delete(
        CustomerKeys.tableName,
        where: '${CustomerKeys.id} = ?',
        whereArgs: [id],
      );
      debugLog("Customer deleted, rows affected: $rowsDeleted");
      return true;
    } catch (e) {
      debugLog("Error deleting customer: $e");
      return false;
    }
  }

  // ---------------- MEMBERSHIP RECORD OPERATIONS ----------------
  Future<int> insertMembershipRecord(MembershipRecord record) async {
    try {
      final db = await instance.database;
      int id = await db.insert(
        MembershipRecordKeys.tableName,
        record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugLog("Membership record inserted with ID: $id");
      return id;
    } catch (e) {
      debugLog("Error inserting membership record: $e");
      return -1;
    }
  }

  Future<List<MembershipRecord>> getRecordsForCustomer(int customerId) async {
    try {
      debugLog("In get records of customer db function");
      final db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        MembershipRecordKeys.tableName,
        where: '${MembershipRecordKeys.customerId} = ?',
        whereArgs: [customerId],
      );
      return maps.map((map) => MembershipRecord.fromMap(map)).toList();
    } catch (e) {
      debugLog(
        "Error fetching membership records for customer $customerId: $e",
      );
      return [];
    }
  }

  Future<int> deleteMembershipRecord(int recordId) async {
    try {
      final db = await instance.database;
      int rowsDeleted = await db.delete(
        MembershipRecordKeys.tableName,
        where: '${MembershipRecordKeys.recordId} = ?',
        whereArgs: [recordId],
      );
      debugLog("Membership record deleted, rows affected: $rowsDeleted");
      return rowsDeleted;
    } catch (e) {
      debugLog("Error deleting membership record: $e");
      return -1;
    }
  }

  Future<bool> updateMembershipRecord(MembershipRecord record) async {
    final db = await instance.database;
    int result = await db.update(
      MembershipRecordKeys.tableName, // Table name
      record.toMap(), // Convert the record to a map
      where: 'recordId = ?', // Condition to find the record
      whereArgs: [record.recordId], // Bind the record ID
    );

    return result > 0; // Returns true if update is successful
  }

  // ---------------- DATABASE CLOSE ----------------
  Future<void> close() async {
    try {
      final db = _database;
      if (db != null) {
        await db.close();
        _database = null;
        debugLog("Database closed successfully.");
      }
    } catch (e) {
      debugLog("Error closing database: $e");
    }
  }
}
