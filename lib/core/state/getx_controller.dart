import 'package:get/get.dart';
import 'package:gym_sync/core/database/database_helper.dart';
import 'package:gym_sync/core/models/customer_model.dart';
import 'package:gym_sync/core/models/membership_record_model.dart';
import 'package:gym_sync/utils/debug/debug_print.dart';
import 'package:gym_sync/utils/debug/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CustomerFilter { all, active, expired, due, inactive, expiredToday }
//!In records of customers ensure that the latest record(the latest payment date is at the start in list)

class CustomerController extends GetxController {
  RxMap<int, Customer> customerRxMap = <int, Customer>{}.obs;
  RxList<Customer> filteredCustomerList = <Customer>[].obs;
  // List<Customer> get customerList =>
  //     filteredCustomersRxMap.values.toList(); // change this
  //personal details
  String gymName = "";
  String ownerName = "";
  //
  RxBool isLoading = true.obs;
  //home page info
  RxInt monthlyIncome = 0.obs;
  RxInt totalMembers = 0.obs;
  RxInt activeMembers = 0.obs;
  RxInt inactiveMembers = 0.obs;
  //expired=total-active-inactive
  //search
  String searchQuery = '';
  CustomerFilter selectedFilter = CustomerFilter.all;
  @override
  void onInit() async {
    super.onInit();
    getUserDetails();
    await fetchCustomers(); // Fetch data when the controller is initialized
    searchAndFilter();
  }

  void getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedGymName = prefs.getString(SharedPrefKeys.gymName) ?? "";
    String storedOwnerName = prefs.getString(SharedPrefKeys.ownerName) ?? "";
    if (storedOwnerName.isNotEmpty) {
      ownerName = storedOwnerName;
    }
    if (storedGymName.isNotEmpty) {
      gymName = storedGymName;
    }
  }

  // Fetch all customers and their records
  Future<void> fetchCustomers() async {
    isLoading.value = true;
    debugLog("Fetching customers from db");
    List<Customer> fetchedCustomerList =
        await DatabaseHelper.instance.getAllCustomers();
    int lengthOfList = fetchedCustomerList.length;
    for (int i = 0; i < lengthOfList; i++) {
      List<MembershipRecord> records = await DatabaseHelper.instance
          .getRecordsForCustomer(fetchedCustomerList[i].id);
      List<MembershipRecord> sortedRecords = sortMembershipRecords(records);
      fetchedCustomerList[i].records = sortedRecords;
      int currentCustomerId = fetchedCustomerList[i].id;
      customerRxMap[currentCustomerId] = fetchedCustomerList[i];
      //?for home page
      incrementActiveOrInactive(fetchedCustomerList[i]);
      updateMonthlyIncome(fetchedCustomerList[i]);
      //?for home page
    }
    totalMembers.value = lengthOfList;
    isLoading.value = false;
    printCustomerList();
  }

  Future<int> addCustomer(
    Customer newCustomer,
    MembershipRecord newRecord,
  ) async {
    isLoading.value = true;
    debugLog("In add customer getx");
    int addedId = 0;
    int newCustomerId = await DatabaseHelper.instance.insertCustomer(
      newCustomer,
    );
    debugLog("Id: $newCustomerId");
    if (newCustomerId > 0) {
      //inserted successfully
      debugLog("Customer added successfully");
      newCustomer.id = newCustomerId;
      newRecord.customerId = newCustomerId;
      int newRecordId = await DatabaseHelper.instance.insertMembershipRecord(
        newRecord,
      );
      if (newRecordId > 0) {
        //inserted successfully
        debugLog("Record added successfully");
        addedId = newCustomer.id;
        newRecord.recordId = newRecordId;
        newCustomer.records = [newRecord]; //adding record to customer
        customerRxMap[newCustomer.id] = newCustomer;
        newCustomer.printCustomer();
        //?for home page
        incrementActiveOrInactive(newCustomer);
        totalMembers.value = customerRxMap.length;
        updateMonthlyIncome(newCustomer);
        //?for home page
      } else {
        DatabaseHelper.instance.deleteCustomer(newCustomerId);
      }
    }
    searchAndFilter();
    isLoading.value = false;
    return addedId;
  }

  void printCustomerList() {
    for (var customer in customerRxMap.values) {
      customer.printCustomer();
    }
  }

  List<MembershipRecord> sortMembershipRecords(List<MembershipRecord> records) {
    records.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    return records;
  }

  Customer? getCustomerById(int customerId) {
    //! check that its not null even once, dangerous
    return customerRxMap[customerId];
  }

  Future<bool> clearDueOfRecordGetx(int customerId, int recordId) async {
    isLoading.value = true;
    bool dueCleared = false;

    if (!customerRxMap.containsKey(customerId)) {
      return dueCleared;
    }

    Customer customer = customerRxMap[customerId]!;

    int index = customer.records.indexWhere((r) => r.recordId == recordId);
    if (index == -1) return dueCleared; // If record not found

    MembershipRecord record = customer.records[index];
    int dueAmount = record.dueAmount; //?for home page
    // Add due amount to paid amount and set due to zero
    record.paidAmount += record.dueAmount;
    record.dueAmount = 0;

    // Update in the database
    bool success = await DatabaseHelper.instance.updateMembershipRecord(record);

    if (success) {
      // Update the record in the local reactive state
      customer.records[index] = record;
      customerRxMap[customerId] = customer; // Update reactive map
      dueCleared = true;
      //?for home page
      if (isSameMonthAndYear(DateTime.now(), record.paymentDate)) {
        monthlyIncome.value = monthlyIncome.value + dueAmount;
      }
      //?for home page
    }
    searchAndFilter();
    isLoading.value = false;
    return dueCleared;
  }

  Future<bool> deleteMembershipRecordGetx(int customerId, int recordId) async {
    isLoading.value = true;
    bool recordDeleted = false;

    if (!customerRxMap.containsKey(customerId)) {
      return recordDeleted; // If customer not found
    }

    Customer customer = customerRxMap[customerId]!;

    // Find the index of the record
    int index = customer.records.indexWhere((r) => r.recordId == recordId);
    if (index == -1) return recordDeleted; // If record not found
    //?for home page
    int paidAmount = customer.records[index].paidAmount;
    DateTime paymentDate = customer.records[index].paymentDate;
    //?for home page
    // Delete from the database
    bool success =
        await DatabaseHelper.instance.deleteMembershipRecord(recordId) != -1;

    if (success) {
      //before removing update homepage info
      bool wasCustomerActiveBefore = customer.hasActiveRecord;
      // Remove the record from the customer's list
      customer.records.removeAt(index);

      bool isCustomerActiveNow = customer.hasActiveRecord;
      int numRecordsAfter = customer.records.length;

      // Update customerMap with the new record list
      customerRxMap[customerId] = customer;

      recordDeleted = true;

      //?for home page
      if (wasCustomerActiveBefore && !isCustomerActiveNow) {
        //if customers active status has changed then we have to check if he has become expired or inactive
        activeMembers.value = activeMembers.value - 1;
        if (numRecordsAfter == 0) {
          inactiveMembers.value = inactiveMembers.value + 1;
        }
      } else if (!wasCustomerActiveBefore && !isCustomerActiveNow) {
        if (numRecordsAfter == 0) {
          inactiveMembers.value = inactiveMembers.value + 1;
          //expired = total-active -inactive
        }
      }
      if (isSameMonthAndYear(DateTime.now(), paymentDate)) {
        monthlyIncome.value = monthlyIncome.value - paidAmount;
      }

      //?for home page
    }
    searchAndFilter();
    isLoading.value = false;
    return recordDeleted;
  }

  Future<bool> addRecordToCustomer(
    int customerId,
    MembershipRecord newRecord,
  ) async {
    isLoading.value = true;
    bool recordAdded = false;
    if (!customerRxMap.containsKey(customerId)) {
      recordAdded = false;
    } else {
      Customer customer = customerRxMap[customerId]!;
      int newRecordId = await DatabaseHelper.instance.insertMembershipRecord(
        newRecord,
      );
      if (newRecordId > 0) {
        bool wasInactiveBefore = customer.records.isEmpty;
        newRecord.recordId = newRecordId;
        customer.records.insert(0, newRecord);
        customerRxMap[customerId] = customer;
        recordAdded = true;
        //?for home page info
        if (wasInactiveBefore) {
          inactiveMembers.value = inactiveMembers.value - 1;
        }
        if (customer.hasActiveRecord) {
          activeMembers.value = activeMembers.value + 1;
        }
        if (isSameMonthAndYear(DateTime.now(), newRecord.paymentDate)) {
          monthlyIncome.value = monthlyIncome.value + newRecord.paidAmount;
        }
        //? for home page
      }
    }
    searchAndFilter();
    isLoading.value = false;
    return recordAdded;
  }

  Future<bool> deleteCustomer(int customerId) async {
    isLoading.value = true;
    bool customerDeleted = false;
    if (!customerRxMap.containsKey(customerId)) {
      return customerDeleted; // If customer not found
    }
    Customer customer = customerRxMap[customerId]!;
    List<int> recordIds =
        customer.records.map((record) => record.recordId).toList();
    bool recordsDeleted = true;
    for (int i = 0; i < recordIds.length && recordsDeleted; i++) {
      recordsDeleted = await deleteMembershipRecordGetx(
        customerId,
        recordIds[i],
      );
      //In the above function the home page details will be changed, and all records will be deleted
      //so the customer will become inactive and we just have to decrement inactive and total count
    }
    if (recordsDeleted) {
      customerDeleted = await DatabaseHelper.instance.deleteCustomer(
        customerId,
      );

      if (customerDeleted) {
        customerRxMap.remove(customerId);
        //updating home page info
        totalMembers.value = customerRxMap.length;

        inactiveMembers.value = inactiveMembers.value - 1;
      }
    }
    searchAndFilter();
    isLoading.value = false;
    return customerDeleted;
  }

  Future<bool> updateCustomerInfo(
    int customerId,
    Customer newCustomerInfo,
  ) async {
    isLoading.value = true;
    bool updated = false;
    newCustomerInfo.id = customerId; //safety
    updated = await DatabaseHelper.instance.updateCustomer(newCustomerInfo);
    if (updated) {
      customerRxMap[customerId]!.updateCustomerInfo(
        newCustomerInfo,
      ); //this change is not detected by obx
      customerRxMap.refresh();
    }
    isLoading.value = false;
    return updated;
  }

  void incrementActiveOrInactive(Customer customer) {
    if (customer.hasActiveRecord) {
      activeMembers.value = activeMembers.value + 1;
    } else if (customer.records.isEmpty) {
      inactiveMembers.value = inactiveMembers.value + 1;
    }
  }

  void updateMonthlyIncome(Customer customer) {
    DateTime todaysDate = DateTime.now();
    for (MembershipRecord record in customer.records) {
      if (isSameMonthAndYear(todaysDate, record.paymentDate)) {
        monthlyIncome.value = monthlyIncome.value + record.paidAmount;
      }
    }
  }

  bool isSameMonthAndYear(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month;
  }

  //Filtering and searching
  void searchCustomer(String searchText) {
    searchQuery = searchText.toLowerCase();
    searchAndFilter();
  }

  void filterCustomer(CustomerFilter filter) {
    selectedFilter = filter;
    searchAndFilter();
  }

  void resetFilterAndSearch() {
    selectedFilter = CustomerFilter.all;
    searchQuery = "";
    searchAndFilter();
  }

  void searchAndFilter() {
    String finalSearchText = searchQuery.trim().toLowerCase();
    if (finalSearchText.isEmpty && selectedFilter == CustomerFilter.all) {
      filteredCustomerList.assignAll(customerRxMap.values.toList());
    } else {
      bool customerSelected = false;
      List<Customer> temp = [];
      for (Customer customer in customerRxMap.values) {
        customerSelected = false;
        if (finalSearchText.isEmpty ||
            customer.name.toLowerCase().contains(finalSearchText) ||
            customer.phoneNumber.contains(finalSearchText)) {
          customerSelected = true;
        }
        if (customerSelected) {
          //now check for filters
          customerSelected = checkFilter(customer, selectedFilter);
        }
        if (customerSelected) {
          temp.add(customer);
        }
      }
      filteredCustomerList.assignAll(temp);
    }
  }

  bool checkFilter(Customer customer, CustomerFilter selectedFilter) {
    bool selected = false;
    switch (selectedFilter) {
      case CustomerFilter.all:
        {
          selected = true;
        }
        break;
      case CustomerFilter.active:
        {
          selected = customer.hasActiveRecord;
        }
        break;
      case CustomerFilter.expired:
        {
          selected = (!customer.hasActiveRecord && customer.records.isNotEmpty);
        }
        break;
      case CustomerFilter.due:
        {
          int length = customer.records.length;
          for (int i = 0; i < length && !selected; i++) {
            selected = (customer.records[i].dueAmount > 0);
          }
        }
        break;
      case CustomerFilter.inactive:
        {
          selected = customer.records.isEmpty;
        }
        break;
      case CustomerFilter.expiredToday:
        {
          DateTime today = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
          int length = customer.records.length;
          for (int i = 0; i < length && !selected; i++) {
            selected = (customer.records[i].dueDate == today);
          }
        }
        break;
    }
    return selected;
  }
}
