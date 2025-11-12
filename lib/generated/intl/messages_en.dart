// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Bind ${name} account";

  static String m1(name) => "Confirm to unbind ${name} account";

  static String m2(title) => "Delete ${title} success!";

  static String m3(count) => "Total ${count} Person";

  static String m4(title) => "Enter ${title}";

  static String m5(count) =>
      "Meal delivery successful, ${count} packages remaining";

  static String m6(name) => "Please enter ${name} account";

  static String m7(name) => "Please enter ${name} password";

  static String m8(title) => "Please fill in ${title}";

  static String m9(label) => "Please enter ${label}";

  static String m10(title) => "Please select ${title}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "acceptOrder": MessageLookupByLibrary.simpleMessage("Accept order"),
        "acceptOrderFailed":
            MessageLookupByLibrary.simpleMessage("Accept order failed"),
        "acceptOrderSuccess":
            MessageLookupByLibrary.simpleMessage("Accept order success"),
        "acceptTime": MessageLookupByLibrary.simpleMessage("Accept time"),
        "accommodationProcess":
            MessageLookupByLibrary.simpleMessage("Accommodation process"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "actualPayment": MessageLookupByLibrary.simpleMessage("Actual payment"),
        "addAddress": MessageLookupByLibrary.simpleMessage("Add address"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "addressInfo": MessageLookupByLibrary.simpleMessage("Address info"),
        "addressManagement":
            MessageLookupByLibrary.simpleMessage("Address Management"),
        "addressOutOfRange": MessageLookupByLibrary.simpleMessage(
            "Out of delivery range, please select another address"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "allRead": MessageLookupByLibrary.simpleMessage("All read"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("IWIP Integrated Platform"),
        "appVersion": MessageLookupByLibrary.simpleMessage("App Version"),
        "attachment": MessageLookupByLibrary.simpleMessage("Attachment"),
        "attention": MessageLookupByLibrary.simpleMessage("Attention"),
        "auditRejected":
            MessageLookupByLibrary.simpleMessage("Rejected by Review"),
        "author": MessageLookupByLibrary.simpleMessage("Author"),
        "barcode": MessageLookupByLibrary.simpleMessage("Barcode"),
        "basic_info": MessageLookupByLibrary.simpleMessage("Basic Info"),
        "batch": MessageLookupByLibrary.simpleMessage("Batch"),
        "bind": MessageLookupByLibrary.simpleMessage("Bind"),
        "bindAccount": m0,
        "bindFail": MessageLookupByLibrary.simpleMessage("Bind failed"),
        "bindMealDeliveryAccount": MessageLookupByLibrary.simpleMessage(
            "Bind meal delivery account, get meal delivery system permission function information"),
        "bindSuccess": MessageLookupByLibrary.simpleMessage("Bind success"),
        "bindThirdPartyAccount":
            MessageLookupByLibrary.simpleMessage("Bind third-party account"),
        "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
        "book_location": MessageLookupByLibrary.simpleMessage("Book Location"),
        "borrow_info": MessageLookupByLibrary.simpleMessage("Borrow Info"),
        "bottleWater": MessageLookupByLibrary.simpleMessage("Bottle Water"),
        "bound": MessageLookupByLibrary.simpleMessage("Bound"),
        "breakfast": MessageLookupByLibrary.simpleMessage("Breakfast"),
        "busTimetable": MessageLookupByLibrary.simpleMessage("Bus Timetable"),
        "busToday": MessageLookupByLibrary.simpleMessage("Today"),
        "businessHours": MessageLookupByLibrary.simpleMessage("Business hours"),
        "cameraPermissionDenied": MessageLookupByLibrary.simpleMessage(
            "Camera permission is permanently denied, open the settings page"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelDefault": MessageLookupByLibrary.simpleMessage(
            "Confirm to cancel the default address?"),
        "cancelOrder": MessageLookupByLibrary.simpleMessage("Cancel order"),
        "cancelOrderFailed":
            MessageLookupByLibrary.simpleMessage("Cancel order failed"),
        "cancelOrderSuccess":
            MessageLookupByLibrary.simpleMessage("Cancel order success"),
        "cardBalance": MessageLookupByLibrary.simpleMessage("Card Balance"),
        "cardBill": MessageLookupByLibrary.simpleMessage("Card Bill"),
        "cardDelete": MessageLookupByLibrary.simpleMessage("Delete"),
        "cardDep": MessageLookupByLibrary.simpleMessage("Department"),
        "cardFreeze": MessageLookupByLibrary.simpleMessage("Freeze"),
        "cardInfo": MessageLookupByLibrary.simpleMessage("Card Info"),
        "cardLock": MessageLookupByLibrary.simpleMessage("Lock"),
        "cardLockSuccess":
            MessageLookupByLibrary.simpleMessage("Successfully unlocked card"),
        "cardLoss": MessageLookupByLibrary.simpleMessage("Loss"),
        "cardLossSuccess": MessageLookupByLibrary.simpleMessage(
            "Successfully reported lost card"),
        "cardName": MessageLookupByLibrary.simpleMessage("Name"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("Card Number"),
        "cardPassword": MessageLookupByLibrary.simpleMessage("Card Password"),
        "cardPreDelete": MessageLookupByLibrary.simpleMessage("Pre Delete"),
        "cardStatus": MessageLookupByLibrary.simpleMessage("Card Status"),
        "cardType": MessageLookupByLibrary.simpleMessage("Card Type"),
        "cardValid": MessageLookupByLibrary.simpleMessage("Valid"),
        "cart": MessageLookupByLibrary.simpleMessage("Cart"),
        "cartEmpty": MessageLookupByLibrary.simpleMessage("Cart is empty"),
        "changeAvatar":
            MessageLookupByLibrary.simpleMessage("Click to Change Avatar"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change language"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "changeSuccess":
            MessageLookupByLibrary.simpleMessage("Change Successful"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Change theme"),
        "checkUpdate": MessageLookupByLibrary.simpleMessage("Check Update"),
        "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
        "chineseFood": MessageLookupByLibrary.simpleMessage("Chinese Food"),
        "chooseRoute": MessageLookupByLibrary.simpleMessage("Choose Route"),
        "cleaning_area": MessageLookupByLibrary.simpleMessage("Cleaning Area"),
        "cleaning_basic_info":
            MessageLookupByLibrary.simpleMessage("Basic Info"),
        "cleaning_contacts": MessageLookupByLibrary.simpleMessage("Contacts"),
        "cleaning_date": MessageLookupByLibrary.simpleMessage("Date"),
        "cleaning_deep_cleaning":
            MessageLookupByLibrary.simpleMessage("Deep Cleaning"),
        "cleaning_evaluate": MessageLookupByLibrary.simpleMessage("Evaluate"),
        "cleaning_loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "cleaning_order":
            MessageLookupByLibrary.simpleMessage("Cleaning Order"),
        "cleaning_order_create": MessageLookupByLibrary.simpleMessage("Create"),
        "cleaning_order_detail":
            MessageLookupByLibrary.simpleMessage("Cleaning Order Detail"),
        "cleaning_order_evaluate":
            MessageLookupByLibrary.simpleMessage("Evaluate Order"),
        "cleaning_order_evaluate_average":
            MessageLookupByLibrary.simpleMessage("Average"),
        "cleaning_order_evaluate_content":
            MessageLookupByLibrary.simpleMessage("Evaluation Content"),
        "cleaning_order_evaluate_content_hint":
            MessageLookupByLibrary.simpleMessage(
                "Please enter your evaluation content (optional)"),
        "cleaning_order_evaluate_dissatisfied":
            MessageLookupByLibrary.simpleMessage("Dissatisfied"),
        "cleaning_order_evaluate_fail":
            MessageLookupByLibrary.simpleMessage("Evaluation Failed"),
        "cleaning_order_evaluate_satisfied":
            MessageLookupByLibrary.simpleMessage("Satisfied"),
        "cleaning_order_evaluate_select_rating":
            MessageLookupByLibrary.simpleMessage("Please select a rating"),
        "cleaning_order_evaluate_submit":
            MessageLookupByLibrary.simpleMessage("Submit Evaluation"),
        "cleaning_order_evaluate_success":
            MessageLookupByLibrary.simpleMessage("Evaluation Success"),
        "cleaning_order_evaluate_title":
            MessageLookupByLibrary.simpleMessage("Service Rating"),
        "cleaning_order_evaluate_very_dissatisfied":
            MessageLookupByLibrary.simpleMessage("Very Dissatisfied"),
        "cleaning_order_evaluate_very_satisfied":
            MessageLookupByLibrary.simpleMessage("Very Satisfied"),
        "cleaning_order_handle": MessageLookupByLibrary.simpleMessage("Handle"),
        "cleaning_order_number":
            MessageLookupByLibrary.simpleMessage("Order Number"),
        "cleaning_order_pending":
            MessageLookupByLibrary.simpleMessage("Pending"),
        "cleaning_order_progress":
            MessageLookupByLibrary.simpleMessage("Order Progress"),
        "cleaning_order_search": MessageLookupByLibrary.simpleMessage(
            "Please enter the order number or room number to search"),
        "cleaning_order_status": MessageLookupByLibrary.simpleMessage("Status"),
        "cleaning_order_submit":
            MessageLookupByLibrary.simpleMessage("Submit Order"),
        "cleaning_order_view": MessageLookupByLibrary.simpleMessage("View"),
        "cleaning_other_info":
            MessageLookupByLibrary.simpleMessage("Other Info"),
        "cleaning_price": MessageLookupByLibrary.simpleMessage("Price"),
        "cleaning_project":
            MessageLookupByLibrary.simpleMessage("Cleaning Project"),
        "cleaning_remark": MessageLookupByLibrary.simpleMessage("Remark"),
        "cleaning_remark_hint": MessageLookupByLibrary.simpleMessage(
            "Please enter additional information (optional)"),
        "cleaning_room_number":
            MessageLookupByLibrary.simpleMessage("Room Number"),
        "cleaning_search": MessageLookupByLibrary.simpleMessage("Search"),
        "cleaning_select_address":
            MessageLookupByLibrary.simpleMessage("Select Address"),
        "cleaning_select_address_error": MessageLookupByLibrary.simpleMessage(
            "Address is not in the cleaning project area, please select again!"),
        "cleaning_select_cleaning_project":
            MessageLookupByLibrary.simpleMessage("Select Cleaning Project"),
        "cleaning_select_date":
            MessageLookupByLibrary.simpleMessage("Select Date"),
        "cleaning_service_detail":
            MessageLookupByLibrary.simpleMessage("Service Detail"),
        "cleaning_special_cleaning":
            MessageLookupByLibrary.simpleMessage("Special Cleaning"),
        "cleaning_submit":
            MessageLookupByLibrary.simpleMessage("Submit Cleaning Service"),
        "cleaning_tel": MessageLookupByLibrary.simpleMessage("Tel"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clearCart": MessageLookupByLibrary.simpleMessage("Clear cart"),
        "clearCartTips":
            MessageLookupByLibrary.simpleMessage("Confirm to clear the cart?"),
        "clickConfirmButtonToViewUnreceivedOrders":
            MessageLookupByLibrary.simpleMessage(
                "Click the confirm button to view the unreceived orders"),
        "clickRetry":
            MessageLookupByLibrary.simpleMessage("Click to try again"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "companyNews": MessageLookupByLibrary.simpleMessage("Company News"),
        "completed": MessageLookupByLibrary.simpleMessage("Completed"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmDelete":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
        "confirmDeleteContent": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this entry? It cannot be recovered!"),
        "confirmDelivery":
            MessageLookupByLibrary.simpleMessage("Confirm delivery"),
        "confirmDeliveryContent": MessageLookupByLibrary.simpleMessage(
            "Confirm delivery, the order will not be modified after confirmation, please confirm whether to receive the order?"),
        "confirmModify": MessageLookupByLibrary.simpleMessage("Confirm modify"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "confirmPublish":
            MessageLookupByLibrary.simpleMessage("Confirm publish"),
        "confirmReceive":
            MessageLookupByLibrary.simpleMessage("Confirm Receipt"),
        "confirmReceiveContent": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to receive this item?"),
        "confirmSubmit": MessageLookupByLibrary.simpleMessage("Confirm submit"),
        "confirmSubmitContent":
            MessageLookupByLibrary.simpleMessage("Confirm to submit order?"),
        "confirmToUnbind": m1,
        "confirm_empty_all_input":
            MessageLookupByLibrary.simpleMessage("Confirm empty all input?"),
        "confirm_reset": MessageLookupByLibrary.simpleMessage("Confirm Reset"),
        "contact": MessageLookupByLibrary.simpleMessage("Contact"),
        "contactNumber": MessageLookupByLibrary.simpleMessage("Contact Number"),
        "contactPerson": MessageLookupByLibrary.simpleMessage("Contact person"),
        "contactPhone": MessageLookupByLibrary.simpleMessage("Contact Phone"),
        "contactPhoneNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Contact phone cannot be empty"),
        "contactUs": MessageLookupByLibrary.simpleMessage("Contact us"),
        "contact_info": MessageLookupByLibrary.simpleMessage("Contact Info"),
        "contentUpdating": MessageLookupByLibrary.simpleMessage(
            "Content is updating, please wait..."),
        "copySuccess": MessageLookupByLibrary.simpleMessage("Copy Success"),
        "coupleRoom": MessageLookupByLibrary.simpleMessage("Room"),
        "coupleRoom_feedback":
            MessageLookupByLibrary.simpleMessage("Room Feedback"),
        "coupleRoom_feedback_content":
            MessageLookupByLibrary.simpleMessage("Feedback Content"),
        "coupleRoom_feedback_other":
            MessageLookupByLibrary.simpleMessage("Other"),
        "coupleRoom_feedback_room":
            MessageLookupByLibrary.simpleMessage("Room Problem"),
        "coupleRoom_feedback_submit":
            MessageLookupByLibrary.simpleMessage("Submit"),
        "coupleRoom_feedback_submit_fail":
            MessageLookupByLibrary.simpleMessage("Submit Failed"),
        "coupleRoom_feedback_submit_success":
            MessageLookupByLibrary.simpleMessage("Submit Success"),
        "coupleRoom_feedback_system":
            MessageLookupByLibrary.simpleMessage("System Problem"),
        "coupleRoom_feedback_type":
            MessageLookupByLibrary.simpleMessage("Feedback Type"),
        "coupleRoom_room_all": MessageLookupByLibrary.simpleMessage("All"),
        "coupleRoom_room_approved":
            MessageLookupByLibrary.simpleMessage("Approved"),
        "coupleRoom_room_audit_info":
            MessageLookupByLibrary.simpleMessage("Audit Info"),
        "coupleRoom_room_audit_remark":
            MessageLookupByLibrary.simpleMessage("Audit Remark"),
        "coupleRoom_room_audit_staff":
            MessageLookupByLibrary.simpleMessage("Audit Staff"),
        "coupleRoom_room_audit_status":
            MessageLookupByLibrary.simpleMessage("Audit Status"),
        "coupleRoom_room_audit_status_pass":
            MessageLookupByLibrary.simpleMessage("Pass"),
        "coupleRoom_room_audit_status_reject":
            MessageLookupByLibrary.simpleMessage("Reject"),
        "coupleRoom_room_audit_time":
            MessageLookupByLibrary.simpleMessage("Audit Time"),
        "coupleRoom_room_available":
            MessageLookupByLibrary.simpleMessage("Available"),
        "coupleRoom_room_available_days":
            MessageLookupByLibrary.simpleMessage("Available Days"),
        "coupleRoom_room_booking":
            MessageLookupByLibrary.simpleMessage("Room Booking"),
        "coupleRoom_room_booking_body": MessageLookupByLibrary.simpleMessage(
            "You have a new room booking, please confirm the order in time"),
        "coupleRoom_room_booking_book":
            MessageLookupByLibrary.simpleMessage("Book"),
        "coupleRoom_room_booking_book_fail":
            MessageLookupByLibrary.simpleMessage("Book Failed"),
        "coupleRoom_room_booking_book_success":
            MessageLookupByLibrary.simpleMessage("Book Success"),
        "coupleRoom_room_booking_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "coupleRoom_room_booking_remark":
            MessageLookupByLibrary.simpleMessage("Remark"),
        "coupleRoom_room_booking_search": MessageLookupByLibrary.simpleMessage(
            "Please enter the room number to search"),
        "coupleRoom_room_booking_select_date": MessageLookupByLibrary.simpleMessage(
            "Please select the check-in date (multiple selection is allowed, and must be continuous)"),
        "coupleRoom_room_booking_submit":
            MessageLookupByLibrary.simpleMessage("Submit"),
        "coupleRoom_room_booking_submit_fail":
            MessageLookupByLibrary.simpleMessage("Submit Failed"),
        "coupleRoom_room_booking_submit_success":
            MessageLookupByLibrary.simpleMessage("Submit Success"),
        "coupleRoom_room_cancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "coupleRoom_room_cancel_order":
            MessageLookupByLibrary.simpleMessage("Cancel order"),
        "coupleRoom_room_cancel_order_confirm":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to cancel this order?"),
        "coupleRoom_room_cancel_order_success":
            MessageLookupByLibrary.simpleMessage("Cancel order success"),
        "coupleRoom_room_canceled":
            MessageLookupByLibrary.simpleMessage("Canceled"),
        "coupleRoom_room_check_in_date": MessageLookupByLibrary.simpleMessage(
            "Please select the check-in date"),
        "coupleRoom_room_check_in_time":
            MessageLookupByLibrary.simpleMessage("Check-in Time"),
        "coupleRoom_room_check_out_time":
            MessageLookupByLibrary.simpleMessage("Check-out Time"),
        "coupleRoom_room_confirm_content": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to confirm this order?"),
        "coupleRoom_room_confirm_fail":
            MessageLookupByLibrary.simpleMessage("Confirm order failed"),
        "coupleRoom_room_confirm_order":
            MessageLookupByLibrary.simpleMessage("Confirm order"),
        "coupleRoom_room_confirm_success":
            MessageLookupByLibrary.simpleMessage("Confirm order success"),
        "coupleRoom_room_days": MessageLookupByLibrary.simpleMessage("Days"),
        "coupleRoom_room_info":
            MessageLookupByLibrary.simpleMessage("Room Info"),
        "coupleRoom_room_number":
            MessageLookupByLibrary.simpleMessage("Room Number"),
        "coupleRoom_room_order":
            MessageLookupByLibrary.simpleMessage("Room Order"),
        "coupleRoom_room_order_cancel_fail":
            MessageLookupByLibrary.simpleMessage("Cancel order failed"),
        "coupleRoom_room_order_cancel_success":
            MessageLookupByLibrary.simpleMessage(
                "Your room booking has been canceled, please re-book"),
        "coupleRoom_room_order_create_time":
            MessageLookupByLibrary.simpleMessage("Create time"),
        "coupleRoom_room_order_detail":
            MessageLookupByLibrary.simpleMessage("Order Detail"),
        "coupleRoom_room_order_end_time":
            MessageLookupByLibrary.simpleMessage("Check-out time"),
        "coupleRoom_room_order_price":
            MessageLookupByLibrary.simpleMessage("Total price"),
        "coupleRoom_room_order_search": MessageLookupByLibrary.simpleMessage(
            "Please enter the room number to search"),
        "coupleRoom_room_order_start_time":
            MessageLookupByLibrary.simpleMessage("Check-in time"),
        "coupleRoom_room_pending":
            MessageLookupByLibrary.simpleMessage("Pending Review"),
        "coupleRoom_room_price": MessageLookupByLibrary.simpleMessage("Price"),
        "coupleRoom_room_price_unit":
            MessageLookupByLibrary.simpleMessage("KRP/Day"),
        "coupleRoom_room_rejected":
            MessageLookupByLibrary.simpleMessage("Rejected"),
        "coupleRoom_room_search":
            MessageLookupByLibrary.simpleMessage("Search"),
        "coupleRoom_room_staff_dept":
            MessageLookupByLibrary.simpleMessage("Department"),
        "coupleRoom_room_staff_info":
            MessageLookupByLibrary.simpleMessage("Staff Info"),
        "coupleRoom_room_staff_job":
            MessageLookupByLibrary.simpleMessage("Job/Service"),
        "coupleRoom_room_staff_name":
            MessageLookupByLibrary.simpleMessage("Name"),
        "coupleRoom_room_staff_sex":
            MessageLookupByLibrary.simpleMessage("Sex"),
        "coupleRoom_room_staff_tel":
            MessageLookupByLibrary.simpleMessage("Tel"),
        "coupleRoom_room_staff_username":
            MessageLookupByLibrary.simpleMessage("Employee"),
        "coupleRoom_room_view": MessageLookupByLibrary.simpleMessage("View"),
        "createTime": MessageLookupByLibrary.simpleMessage("Create time"),
        "currentBound": MessageLookupByLibrary.simpleMessage("Current bound: "),
        "currentVersionIsLatest": MessageLookupByLibrary.simpleMessage(
            "You are using the latest version"),
        "dangerPage": MessageLookupByLibrary.simpleMessage("Hazards"),
        "days_ago": MessageLookupByLibrary.simpleMessage("Days Ago"),
        "defaultValue": MessageLookupByLibrary.simpleMessage("Default"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAddress": MessageLookupByLibrary.simpleMessage(
            "Confirm to delete this address?"),
        "deleteOrder": MessageLookupByLibrary.simpleMessage("Delete order"),
        "deleteRepair": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteRepairSuccess":
            MessageLookupByLibrary.simpleMessage("Delete repair success"),
        "deleteRepairTips": MessageLookupByLibrary.simpleMessage(
            "Confirm to delete this repair order?"),
        "deleteSuccess": m2,
        "deliver": MessageLookupByLibrary.simpleMessage("Deliver"),
        "deliverFailed": MessageLookupByLibrary.simpleMessage("Deliver failed"),
        "deliverFailedTips": MessageLookupByLibrary.simpleMessage(
            "Confirm to cancel the delivery of this order?"),
        "deliverSuccess":
            MessageLookupByLibrary.simpleMessage("Deliver success"),
        "deliverSuccessTips": MessageLookupByLibrary.simpleMessage(
            "Your order has been delivered"),
        "deliverTime": MessageLookupByLibrary.simpleMessage("Deliver time"),
        "delivered": MessageLookupByLibrary.simpleMessage("Delivered"),
        "delivering": MessageLookupByLibrary.simpleMessage("Delivering"),
        "delivery": MessageLookupByLibrary.simpleMessage("Delivery"),
        "deliveryAddress": MessageLookupByLibrary.simpleMessage("Address"),
        "deliveryAuditRejected":
            MessageLookupByLibrary.simpleMessage("Audit Rejected"),
        "deliveryAudited": MessageLookupByLibrary.simpleMessage("Audited"),
        "deliveryBag": MessageLookupByLibrary.simpleMessage("Bag"),
        "deliveryBindAccount":
            MessageLookupByLibrary.simpleMessage("Bind Account"),
        "deliveryBoxedMeal": MessageLookupByLibrary.simpleMessage("Boxed Meal"),
        "deliveryBucket": MessageLookupByLibrary.simpleMessage("Bucket"),
        "deliveryCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "deliveryCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
        "deliveryConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "deliveryCooking": MessageLookupByLibrary.simpleMessage("Cooking"),
        "deliveryDeliver": MessageLookupByLibrary.simpleMessage(
            "Scan QR code with handheld device"),
        "deliveryDeliverOrder":
            MessageLookupByLibrary.simpleMessage("Start Delivery"),
        "deliveryDeliverOrderFail":
            MessageLookupByLibrary.simpleMessage("Start Delivery Failed"),
        "deliveryDelivered": MessageLookupByLibrary.simpleMessage("Delivered"),
        "deliveryDelivering":
            MessageLookupByLibrary.simpleMessage("Delivering"),
        "deliveryDept": MessageLookupByLibrary.simpleMessage("Department"),
        "deliveryDeptName":
            MessageLookupByLibrary.simpleMessage("Department Name"),
        "deliveryEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "deliveryException": MessageLookupByLibrary.simpleMessage("Exception"),
        "deliveryFail":
            MessageLookupByLibrary.simpleMessage("Delivery failed!"),
        "deliveryFee": MessageLookupByLibrary.simpleMessage("Delivery fee"),
        "deliveryGetMealPlace":
            MessageLookupByLibrary.simpleMessage("Getting Meal Place Data..."),
        "deliveryGetMealPlaceFail":
            MessageLookupByLibrary.simpleMessage("Get Meal Place Data Failed"),
        "deliveryGetPersonList":
            MessageLookupByLibrary.simpleMessage("Get Person List"),
        "deliveryGetPersonListFail":
            MessageLookupByLibrary.simpleMessage("Get Person List Failed"),
        "deliveryInfo":
            MessageLookupByLibrary.simpleMessage("View delivery info"),
        "deliveryJobNumber": MessageLookupByLibrary.simpleMessage("Job Number"),
        "deliveryLoading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "deliveryMealBox": MessageLookupByLibrary.simpleMessage("Meal Box"),
        "deliveryName": MessageLookupByLibrary.simpleMessage("Name"),
        "deliveryNotAudited":
            MessageLookupByLibrary.simpleMessage("Not Audited"),
        "deliveryNotStarted":
            MessageLookupByLibrary.simpleMessage("Not Started"),
        "deliveryOrder": MessageLookupByLibrary.simpleMessage("Delivery order"),
        "deliveryOrderAvailable":
            MessageLookupByLibrary.simpleMessage("Today\'s Available Meals"),
        "deliveryOrderCompleted":
            MessageLookupByLibrary.simpleMessage("Order Completed"),
        "deliveryOrderDetail":
            MessageLookupByLibrary.simpleMessage("Delivery order detail"),
        "deliveryOrderList": MessageLookupByLibrary.simpleMessage("Order List"),
        "deliveryOrderNo":
            MessageLookupByLibrary.simpleMessage("Delivery order number"),
        "deliveryOrderNoPermission": MessageLookupByLibrary.simpleMessage(
            "No permission to order meals, contact department staff"),
        "deliveryOrderNotAvailable": MessageLookupByLibrary.simpleMessage(
            "Current time is not available for ordering"),
        "deliveryOrderNotBindAccount": MessageLookupByLibrary.simpleMessage(
            "Not bound to the meal delivery account, please bind the account first"),
        "deliveryOrderPlaced":
            MessageLookupByLibrary.simpleMessage("Order Placed"),
        "deliveryOrderStatus":
            MessageLookupByLibrary.simpleMessage("Order Status"),
        "deliveryOrderSubmit":
            MessageLookupByLibrary.simpleMessage("Submit Order"),
        "deliveryOrderSubmitFail":
            MessageLookupByLibrary.simpleMessage("Order Submit Failed"),
        "deliveryOrderSuccess": MessageLookupByLibrary.simpleMessage(
            "Order submitted successfully!"),
        "deliveryOrderTemporary":
            MessageLookupByLibrary.simpleMessage("Temporary Staff Order"),
        "deliveryOrderTips": MessageLookupByLibrary.simpleMessage(
            "Please select the appropriate meal type according to the meal time, and the order cannot be changed after submission"),
        "deliveryOrderTitle":
            MessageLookupByLibrary.simpleMessage("Today\'s Order"),
        "deliveryOrderType": MessageLookupByLibrary.simpleMessage("Order Type"),
        "deliveryPackOrderFail":
            MessageLookupByLibrary.simpleMessage("Packing Failed"),
        "deliveryPackage": MessageLookupByLibrary.simpleMessage("Package"),
        "deliveryPackageType":
            MessageLookupByLibrary.simpleMessage("Package Type"),
        "deliveryPacked": MessageLookupByLibrary.simpleMessage("Packed"),
        "deliveryPackedMeal":
            MessageLookupByLibrary.simpleMessage("Packed Meal"),
        "deliveryPhone": MessageLookupByLibrary.simpleMessage("Tel"),
        "deliveryPhoto": MessageLookupByLibrary.simpleMessage("Delivery Photo"),
        "deliveryPost": MessageLookupByLibrary.simpleMessage("Post"),
        "deliveryReject": MessageLookupByLibrary.simpleMessage("Reject"),
        "deliveryRejectFail":
            MessageLookupByLibrary.simpleMessage("Reject Failed"),
        "deliveryRejectReason":
            MessageLookupByLibrary.simpleMessage("Reject Reason"),
        "deliveryRejectSuccess":
            MessageLookupByLibrary.simpleMessage("Reject Success"),
        "deliveryReset": MessageLookupByLibrary.simpleMessage("Reset"),
        "deliveryReturnOrder":
            MessageLookupByLibrary.simpleMessage("Return Order"),
        "deliveryReturnOrderConfirm":
            MessageLookupByLibrary.simpleMessage("Confirm Return Order?"),
        "deliveryReturnOrderFail":
            MessageLookupByLibrary.simpleMessage("Return Order Failed"),
        "deliveryReturnOrderSuccess":
            MessageLookupByLibrary.simpleMessage("Return Order Success"),
        "deliverySearchOrder": MessageLookupByLibrary.simpleMessage(
            "Search by delivery location or order number"),
        "deliverySearchPerson":
            MessageLookupByLibrary.simpleMessage("Search by name"),
        "deliverySelectPerson":
            MessageLookupByLibrary.simpleMessage("Select Person"),
        "deliverySelectPlace":
            MessageLookupByLibrary.simpleMessage("Select Place"),
        "deliverySelectTeam":
            MessageLookupByLibrary.simpleMessage("Select Team"),
        "deliverySelectTeamFail":
            MessageLookupByLibrary.simpleMessage("Get Team Failed"),
        "deliverySelectTime":
            MessageLookupByLibrary.simpleMessage("Select Time"),
        "deliverySelectedConditions":
            MessageLookupByLibrary.simpleMessage("Selected Conditions:"),
        "deliveryStartDelivery":
            MessageLookupByLibrary.simpleMessage("Start Delivery"),
        "deliverySubmit": MessageLookupByLibrary.simpleMessage("Submit"),
        "deliverySubmitOrder":
            MessageLookupByLibrary.simpleMessage("Submit Order"),
        "deliverySubmitOrderFail":
            MessageLookupByLibrary.simpleMessage("Submit Failed"),
        "deliverySubmitOrderSuccess":
            MessageLookupByLibrary.simpleMessage("Submit Success"),
        "deliverySubmitStatus":
            MessageLookupByLibrary.simpleMessage("Submit Status"),
        "deliverySuccess":
            MessageLookupByLibrary.simpleMessage("Delivery successful!"),
        "deliveryTel": MessageLookupByLibrary.simpleMessage("Tel"),
        "deliveryTime": MessageLookupByLibrary.simpleMessage("Delivery time"),
        "deliveryTotal": m3,
        "deliveryType": MessageLookupByLibrary.simpleMessage("Delivery Type"),
        "deliveryUploadFailed":
            MessageLookupByLibrary.simpleMessage("Image upload failed!"),
        "deliveryUploading":
            MessageLookupByLibrary.simpleMessage("Uploading..."),
        "deliveryWaterService":
            MessageLookupByLibrary.simpleMessage("Water Service"),
        "deliveryWaterServiceTips": MessageLookupByLibrary.simpleMessage(
            "Select delivery site and quantity, we will provide you with优质的饮用水服务"),
        "delivery_canteen":
            MessageLookupByLibrary.simpleMessage("Delivery Canteen"),
        "delivery_site": MessageLookupByLibrary.simpleMessage("Delivery Site"),
        "delivery_site_search": MessageLookupByLibrary.simpleMessage(
            "Please enter the delivery site name to search"),
        "delivery_site_search_clear_confirm":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to clear the search content?"),
        "delivery_site_search_not_found": MessageLookupByLibrary.simpleMessage(
            "No matching delivery site found"),
        "delivery_site_search_placeholder":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the delivery site name to search"),
        "departmentSubmitted":
            MessageLookupByLibrary.simpleMessage("Department Submitted"),
        "dept": MessageLookupByLibrary.simpleMessage("Department"),
        "description_at_least_10_characters":
            MessageLookupByLibrary.simpleMessage(
                "Description at least 10 characters"),
        "description_content":
            MessageLookupByLibrary.simpleMessage("Description Content"),
        "dessert": MessageLookupByLibrary.simpleMessage("Dessert"),
        "detailed_description":
            MessageLookupByLibrary.simpleMessage("Detailed Description"),
        "diningIn": MessageLookupByLibrary.simpleMessage("Dining In"),
        "diningService": MessageLookupByLibrary.simpleMessage("Dining Service"),
        "diningTime": MessageLookupByLibrary.simpleMessage("Dining time"),
        "dinner": MessageLookupByLibrary.simpleMessage("Dinner"),
        "direction": MessageLookupByLibrary.simpleMessage("Direction"),
        "dishMethod": MessageLookupByLibrary.simpleMessage("Dish method"),
        "dishName": MessageLookupByLibrary.simpleMessage("Dish name"),
        "dishSuggestion":
            MessageLookupByLibrary.simpleMessage("Dish suggestion"),
        "dishes": MessageLookupByLibrary.simpleMessage("Dishes"),
        "dragHereToRemove":
            MessageLookupByLibrary.simpleMessage("Drag here to remove"),
        "dragRemoveImage":
            MessageLookupByLibrary.simpleMessage("Drag to remove image"),
        "duplicateOrderReception":
            MessageLookupByLibrary.simpleMessage("Duplicate Order Reception"),
        "earlyTea": MessageLookupByLibrary.simpleMessage("Early Tea"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editToBeAuditedMessage": MessageLookupByLibrary.simpleMessage(
            "Modified successfully, pending review"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "employeeNumber":
            MessageLookupByLibrary.simpleMessage("Employee number"),
        "en": MessageLookupByLibrary.simpleMessage("English"),
        "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
        "endOfList": MessageLookupByLibrary.simpleMessage("End of list"),
        "endStation": MessageLookupByLibrary.simpleMessage("End Station"),
        "enterNewPasswordAgin": MessageLookupByLibrary.simpleMessage(
            "Please enter the new password again"),
        "evaluate": MessageLookupByLibrary.simpleMessage("Evaluate"),
        "evaluated": MessageLookupByLibrary.simpleMessage("Evaluated"),
        "evaluation": MessageLookupByLibrary.simpleMessage("Evaluation"),
        "exceedStock": MessageLookupByLibrary.simpleMessage("Exceeds stock"),
        "exception": MessageLookupByLibrary.simpleMessage("Exception"),
        "exitManage": MessageLookupByLibrary.simpleMessage("Exit manage"),
        "expenditure": MessageLookupByLibrary.simpleMessage("Expenditure"),
        "faceCollection":
            MessageLookupByLibrary.simpleMessage("Face Collection"),
        "faceCollectionTips": MessageLookupByLibrary.simpleMessage(
            "Facial recognition for consumption cards can be used for face-scan purchases in the park."),
        "faceCollectionTips1": MessageLookupByLibrary.simpleMessage(
            "1. Front-facing photo without hat, eyebrows and eyes clearly visible"),
        "faceCollectionTips2": MessageLookupByLibrary.simpleMessage(
            "2. White background, no backlight, no photoshop, no excessive beauty filters"),
        "faceCollectionTips3": MessageLookupByLibrary.simpleMessage(
            "3. Recommended to use a high-resolution phone camera"),
        "faceCollectionTips4":
            MessageLookupByLibrary.simpleMessage("4. Image size: 40k~200k"),
        "faceCollectionTips5": MessageLookupByLibrary.simpleMessage(
            "5. Users who fail photo verification multiple times can bring their employee ID to the card service counter during working hours"),
        "faceCollectionTipsTitle": MessageLookupByLibrary.simpleMessage(
            "Collection Standards Instructions"),
        "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "feedbackContent": MessageLookupByLibrary.simpleMessage("Content"),
        "feedbackTitle": MessageLookupByLibrary.simpleMessage("Title"),
        "feedback_content":
            MessageLookupByLibrary.simpleMessage("Feedback Content"),
        "feedback_detail":
            MessageLookupByLibrary.simpleMessage("Feedback Detail"),
        "firstLoginTips": MessageLookupByLibrary.simpleMessage(
            "For your financial security, please change your password as soon as you log in for the first time!"),
        "firstTripTime":
            MessageLookupByLibrary.simpleMessage("First Trip Time"),
        "fixed": MessageLookupByLibrary.simpleMessage("Fixed"),
        "foodNameChooseError": MessageLookupByLibrary.simpleMessage(
            "Meal time and food type do not match"),
        "foodRecommend":
            MessageLookupByLibrary.simpleMessage("Food Recommendation"),
        "foodType": MessageLookupByLibrary.simpleMessage("Food Type"),
        "food_menu": MessageLookupByLibrary.simpleMessage("Food Menu"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forget password?"),
        "found": MessageLookupByLibrary.simpleMessage("Found"),
        "foundItem": MessageLookupByLibrary.simpleMessage("Found Item"),
        "foundItemList":
            MessageLookupByLibrary.simpleMessage("Found Item List"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "getSystemDataError":
            MessageLookupByLibrary.simpleMessage("Get data failed"),
        "goodHeartedColleague":
            MessageLookupByLibrary.simpleMessage("Kind Colleague"),
        "good_deeds": MessageLookupByLibrary.simpleMessage("Good Deeds"),
        "good_deeds_detail":
            MessageLookupByLibrary.simpleMessage("Good Deeds Detail"),
        "good_name": MessageLookupByLibrary.simpleMessage("Good Name"),
        "goodsInfo": MessageLookupByLibrary.simpleMessage("Goods info"),
        "goodsTotal": MessageLookupByLibrary.simpleMessage("Goods total"),
        "groupNotSubmitted":
            MessageLookupByLibrary.simpleMessage("Group Not Submitted"),
        "groupSubmitted":
            MessageLookupByLibrary.simpleMessage("Group Submitted"),
        "hazard_description":
            MessageLookupByLibrary.simpleMessage("Hazard Description"),
        "hazard_location":
            MessageLookupByLibrary.simpleMessage("Discover Location"),
        "hazard_name": MessageLookupByLibrary.simpleMessage("Hazard Name"),
        "hazard_photo": MessageLookupByLibrary.simpleMessage("Hazard Photo"),
        "hazard_submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "head": MessageLookupByLibrary.simpleMessage("Head"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "homePage": MessageLookupByLibrary.simpleMessage("Home"),
        "hours_ago": MessageLookupByLibrary.simpleMessage("Hours Ago"),
        "iWantToEat": MessageLookupByLibrary.simpleMessage("I want to eat"),
        "i_want_to_eat": MessageLookupByLibrary.simpleMessage("I Want to Eat"),
        "i_want_to_say": MessageLookupByLibrary.simpleMessage("I Want to Say"),
        "id": MessageLookupByLibrary.simpleMessage("Indonesia"),
        "idCard": MessageLookupByLibrary.simpleMessage("ID Card"),
        "idCardTips": MessageLookupByLibrary.simpleMessage(
            "ID card number can be used to retrieve password, please bind it as soon as possible!"),
        "imageUploading":
            MessageLookupByLibrary.simpleMessage("Image uploading..."),
        "images": MessageLookupByLibrary.simpleMessage("Images"),
        "indonesianFood":
            MessageLookupByLibrary.simpleMessage("Indonesian Food"),
        "information": MessageLookupByLibrary.simpleMessage("Information"),
        "inputConfirmPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter the new password again"),
        "inputDifferentPassword": MessageLookupByLibrary.simpleMessage(
            "The two passwords are different"),
        "inputIdCard": MessageLookupByLibrary.simpleMessage(
            "Please enter your ID card number"),
        "inputMessage": m4,
        "inputNewPassword":
            MessageLookupByLibrary.simpleMessage("Please enter a new password"),
        "inputOldPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter the old password"),
        "inputOrderName":
            MessageLookupByLibrary.simpleMessage("Please enter order name"),
        "inputOrderNo":
            MessageLookupByLibrary.simpleMessage("Please enter order number"),
        "inputPasswordError": MessageLookupByLibrary.simpleMessage(
            "Please enter 6-digit payment password"),
        "inputWorkNumber": MessageLookupByLibrary.simpleMessage(
            "Please enter your employee number"),
        "isDefault": MessageLookupByLibrary.simpleMessage("Is default"),
        "itemName": MessageLookupByLibrary.simpleMessage("Item name"),
        "items": MessageLookupByLibrary.simpleMessage("Items"),
        "just_now": MessageLookupByLibrary.simpleMessage("Just Now"),
        "kTimeDetail": MessageLookupByLibrary.simpleMessage("K Time Detail"),
        "kTimeList": MessageLookupByLibrary.simpleMessage("K Time"),
        "lastTripTime": MessageLookupByLibrary.simpleMessage("Last Trip Time"),
        "library": MessageLookupByLibrary.simpleMessage("Library"),
        "library_book": MessageLookupByLibrary.simpleMessage("Book"),
        "library_book_detail":
            MessageLookupByLibrary.simpleMessage("Book Detail"),
        "library_book_info": MessageLookupByLibrary.simpleMessage("Book Info"),
        "library_book_no": MessageLookupByLibrary.simpleMessage("Book No"),
        "library_book_unknown":
            MessageLookupByLibrary.simpleMessage("Unknown Book"),
        "library_location":
            MessageLookupByLibrary.simpleMessage("Location Selection:"),
        "library_location_0":
            MessageLookupByLibrary.simpleMessage("Outer Campus Loan Room"),
        "library_location_1":
            MessageLookupByLibrary.simpleMessage("Li Bai Loan Room"),
        "library_location_2":
            MessageLookupByLibrary.simpleMessage("H Area Loan Room"),
        "library_location_3": MessageLookupByLibrary.simpleMessage("Loan Room"),
        "library_location_all":
            MessageLookupByLibrary.simpleMessage("All Locations"),
        "library_search":
            MessageLookupByLibrary.simpleMessage("Enter book name to search"),
        "like": MessageLookupByLibrary.simpleMessage("Like"),
        "likeFailed": MessageLookupByLibrary.simpleMessage("Failed to like"),
        "likeSuccess":
            MessageLookupByLibrary.simpleMessage("Liked successfully"),
        "liked": MessageLookupByLibrary.simpleMessage("Liked"),
        "livingAreaDataLoading":
            MessageLookupByLibrary.simpleMessage("Living Area Data Loading..."),
        "loadFailed": MessageLookupByLibrary.simpleMessage("Load failed"),
        "load_failed": MessageLookupByLibrary.simpleMessage("Load failed"),
        "loading": MessageLookupByLibrary.simpleMessage("Data loading..."),
        "loading_food_menu":
            MessageLookupByLibrary.simpleMessage("Loading food menu..."),
        "loginBtn": MessageLookupByLibrary.simpleMessage("Login"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
        "loginSuccess": MessageLookupByLibrary.simpleMessage("Login success"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "logoutFailed": MessageLookupByLibrary.simpleMessage("Logout failed"),
        "logoutSuccess": MessageLookupByLibrary.simpleMessage("Logout success"),
        "logoutTip":
            MessageLookupByLibrary.simpleMessage("Are you sure to logout?"),
        "lost": MessageLookupByLibrary.simpleMessage("Lost"),
        "lostAndFound": MessageLookupByLibrary.simpleMessage("Lost and Found"),
        "lostItem": MessageLookupByLibrary.simpleMessage("Lost Item"),
        "lostItemColleague":
            MessageLookupByLibrary.simpleMessage("Lost Item Owner"),
        "lostItemList": MessageLookupByLibrary.simpleMessage("Lost Item List"),
        "lostPlace": MessageLookupByLibrary.simpleMessage("Lost Place"),
        "lostStatus": MessageLookupByLibrary.simpleMessage("Lost Status"),
        "lostTime": MessageLookupByLibrary.simpleMessage("Lost Time"),
        "lostType": MessageLookupByLibrary.simpleMessage("Lost Type"),
        "lunch": MessageLookupByLibrary.simpleMessage("Lunch"),
        "man": MessageLookupByLibrary.simpleMessage("Male"),
        "manage": MessageLookupByLibrary.simpleMessage("Manage"),
        "mealDelivery": MessageLookupByLibrary.simpleMessage("Meal Delivery"),
        "mealDeliveryAccept": MessageLookupByLibrary.simpleMessage(
            "Scan QR code with handheld device"),
        "mealDeliverySuccess": m5,
        "mealTime": MessageLookupByLibrary.simpleMessage("Meal Time"),
        "mealType": MessageLookupByLibrary.simpleMessage("Meal Type"),
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "mine": MessageLookupByLibrary.simpleMessage("Mine"),
        "minePage": MessageLookupByLibrary.simpleMessage("Mine"),
        "minutes_ago": MessageLookupByLibrary.simpleMessage("Minutes Ago"),
        "modifyAddress": MessageLookupByLibrary.simpleMessage("Modify address"),
        "modifyPerson": MessageLookupByLibrary.simpleMessage("Modify Person"),
        "monthly": MessageLookupByLibrary.simpleMessage("Monthly"),
        "monthlySales": MessageLookupByLibrary.simpleMessage("Monthly Sales"),
        "moreFunction": MessageLookupByLibrary.simpleMessage("More Function"),
        "museum_date": MessageLookupByLibrary.simpleMessage("Museum Date"),
        "myAddress": MessageLookupByLibrary.simpleMessage("My Address"),
        "myFeedback": MessageLookupByLibrary.simpleMessage("My Feedback"),
        "myOrder": MessageLookupByLibrary.simpleMessage("My Order"),
        "myProcess": MessageLookupByLibrary.simpleMessage("My Process"),
        "myRelease": MessageLookupByLibrary.simpleMessage("My Posts"),
        "myReleaseList": MessageLookupByLibrary.simpleMessage("My Post List"),
        "myRepair": MessageLookupByLibrary.simpleMessage("My Repair"),
        "my_good_deeds": MessageLookupByLibrary.simpleMessage("My Publish"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "needCameraPermission": MessageLookupByLibrary.simpleMessage(
            "Need camera permission to scan"),
        "needLogin": MessageLookupByLibrary.simpleMessage(
            "Please log in to your account"),
        "networkError":
            MessageLookupByLibrary.simpleMessage("Network connection error"),
        "networkErrorTips": MessageLookupByLibrary.simpleMessage(
            "Network not strong, click to reload"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
        "newPasswordNotEmpty": MessageLookupByLibrary.simpleMessage(
            "New password cannot be empty"),
        "newProductRecommend":
            MessageLookupByLibrary.simpleMessage("New Product Recommendation"),
        "newVersion":
            MessageLookupByLibrary.simpleMessage("New version available"),
        "news": MessageLookupByLibrary.simpleMessage("Company News"),
        "nightSnack": MessageLookupByLibrary.simpleMessage("Night Snack"),
        "noData": MessageLookupByLibrary.simpleMessage("No data"),
        "noMoreData": MessageLookupByLibrary.simpleMessage("No more data"),
        "noOrder": MessageLookupByLibrary.simpleMessage("No order"),
        "noPersonInfo": MessageLookupByLibrary.simpleMessage("No Person Info"),
        "no_content": MessageLookupByLibrary.simpleMessage("No Content"),
        "no_description":
            MessageLookupByLibrary.simpleMessage("No Description"),
        "no_food_menu_info":
            MessageLookupByLibrary.simpleMessage("No food menu info"),
        "no_food_menu_info_tips":
            MessageLookupByLibrary.simpleMessage("No food menu for this date"),
        "no_more_info": MessageLookupByLibrary.simpleMessage("No more info"),
        "normalOrder": MessageLookupByLibrary.simpleMessage("Normal Order"),
        "not_filled": MessageLookupByLibrary.simpleMessage("Not Filled"),
        "notice": MessageLookupByLibrary.simpleMessage("Notice"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "oldPassword": MessageLookupByLibrary.simpleMessage("Old Password"),
        "oldPasswordNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Old password cannot be empty"),
        "oneMonth": MessageLookupByLibrary.simpleMessage("One Month"),
        "oneWeek": MessageLookupByLibrary.simpleMessage("One Week"),
        "oneYear": MessageLookupByLibrary.simpleMessage("One Year"),
        "onlineApply": MessageLookupByLibrary.simpleMessage("Online apply"),
        "onlineDelivery":
            MessageLookupByLibrary.simpleMessage("Online delivery"),
        "onlineDining": MessageLookupByLibrary.simpleMessage("Online Dining"),
        "operator": MessageLookupByLibrary.simpleMessage("Operator"),
        "optional": MessageLookupByLibrary.simpleMessage("(Optional)"),
        "order": MessageLookupByLibrary.simpleMessage("Order"),
        "orderAllLoaded": MessageLookupByLibrary.simpleMessage(
            "All orders have been loaded into the vehicle"),
        "orderCenterConfirmed":
            MessageLookupByLibrary.simpleMessage("Order Center Confirmed"),
        "orderCompleted":
            MessageLookupByLibrary.simpleMessage("Order Completed"),
        "orderDetail": MessageLookupByLibrary.simpleMessage("Order details"),
        "orderInfo": MessageLookupByLibrary.simpleMessage("Order info"),
        "orderName": MessageLookupByLibrary.simpleMessage("Order Name"),
        "orderNo": MessageLookupByLibrary.simpleMessage("Order No."),
        "orderNotConfirmed": MessageLookupByLibrary.simpleMessage(
            "Not (Order Center Confirmed & Cooking)"),
        "orderNotFound":
            MessageLookupByLibrary.simpleMessage("No order information found"),
        "orderNum": MessageLookupByLibrary.simpleMessage("Order Number"),
        "orderNumUnit": MessageLookupByLibrary.simpleMessage("Order"),
        "orderPlacedBy":
            MessageLookupByLibrary.simpleMessage("Order Placed By"),
        "orderProgress": MessageLookupByLibrary.simpleMessage("Order Progress"),
        "orderRejected": MessageLookupByLibrary.simpleMessage("Order Rejected"),
        "orderStatus": MessageLookupByLibrary.simpleMessage("Order Status"),
        "orderTime": MessageLookupByLibrary.simpleMessage("Order time"),
        "other": MessageLookupByLibrary.simpleMessage("Other"),
        "packOrderSuccess": MessageLookupByLibrary.simpleMessage(
            "Packing Completed Successfully"),
        "packageTypeError": MessageLookupByLibrary.simpleMessage(
            "Boxed meal does not need to be received"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordChangeFailed":
            MessageLookupByLibrary.simpleMessage("Password change failed"),
        "passwordChangeSuccess":
            MessageLookupByLibrary.simpleMessage("Password change success"),
        "passwordLength": MessageLookupByLibrary.simpleMessage(
            "Password length is 6-16 characters"),
        "passwordModifySuccess": MessageLookupByLibrary.simpleMessage(
            "Password modified successfully"),
        "passwordNotEmpty":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty"),
        "passwordNotSame": MessageLookupByLibrary.simpleMessage(
            "Two passwords are not the same"),
        "passwordPlaceholder":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "passwordTips":
            MessageLookupByLibrary.simpleMessage("Password is 6 digits"),
        "payFail": MessageLookupByLibrary.simpleMessage("Payment failed"),
        "paySuccess": MessageLookupByLibrary.simpleMessage("Payment success"),
        "paymentQRCode": MessageLookupByLibrary.simpleMessage("QR Code"),
        "pending": MessageLookupByLibrary.simpleMessage("Pending"),
        "pendingOrder": MessageLookupByLibrary.simpleMessage("Pending"),
        "pendingRepair": MessageLookupByLibrary.simpleMessage("Pending Repair"),
        "permissionDenied": MessageLookupByLibrary.simpleMessage(
            "You do not have permission to pick up meals"),
        "personList": MessageLookupByLibrary.simpleMessage("Person List"),
        "personalInfo": MessageLookupByLibrary.simpleMessage("Personal info"),
        "personal_info": MessageLookupByLibrary.simpleMessage("Personal Info"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone number"),
        "photoAlbum": MessageLookupByLibrary.simpleMessage("Photo album"),
        "pickupCode": MessageLookupByLibrary.simpleMessage("Shelves"),
        "pickupLimitTime":
            MessageLookupByLibrary.simpleMessage("Pickup limit time"),
        "pickupTime": MessageLookupByLibrary.simpleMessage("Pickup time"),
        "pickupType": MessageLookupByLibrary.simpleMessage("Pickup type"),
        "pleaseAcceptOrder": MessageLookupByLibrary.simpleMessage(
            "Please accept the order first"),
        "pleaseCancelOrder": MessageLookupByLibrary.simpleMessage(
            "Please cancel the order first"),
        "pleaseEnterAccount": m6,
        "pleaseEnterPassword": m7,
        "pleaseFillIn": m8,
        "pleaseInput": m9,
        "pleaseScanTheBarcode": MessageLookupByLibrary.simpleMessage(
            "Please scan the barcode into the box, and it will be automatically scanned"),
        "pleaseSelect": m10,
        "please_enter_good_deeds_contact_info":
            MessageLookupByLibrary.simpleMessage("Please enter contact info"),
        "please_enter_good_deeds_description":
            MessageLookupByLibrary.simpleMessage(
                "Please enter detailed description"),
        "please_enter_good_deeds_name":
            MessageLookupByLibrary.simpleMessage("Please enter good name"),
        "please_enter_good_deeds_title": MessageLookupByLibrary.simpleMessage(
            "Please enter good deeds title"),
        "please_enter_hazard_description": MessageLookupByLibrary.simpleMessage(
            "Please describe discover hazard"),
        "please_enter_hazard_location": MessageLookupByLibrary.simpleMessage(
            "Please enter discover location"),
        "please_enter_hazard_name":
            MessageLookupByLibrary.simpleMessage("Please enter hazard name"),
        "please_enter_reporter_name":
            MessageLookupByLibrary.simpleMessage("Please enter reporter name"),
        "please_enter_reporter_tel":
            MessageLookupByLibrary.simpleMessage("Please enter reporter tel"),
        "please_select_hazard_date":
            MessageLookupByLibrary.simpleMessage("Please select discover date"),
        "please_select_hazard_time":
            MessageLookupByLibrary.simpleMessage("Please select discover time"),
        "please_upload_hazard_photo": MessageLookupByLibrary.simpleMessage(
            "Please upload discover photo"),
        "please_upload_hazard_photo_tips": MessageLookupByLibrary.simpleMessage(
            "Please take or select hazard scene photos, up to 6 photos"),
        "please_upload_hazard_video": MessageLookupByLibrary.simpleMessage(
            "Please upload discover video"),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "process": MessageLookupByLibrary.simpleMessage("Process"),
        "processDescription":
            MessageLookupByLibrary.simpleMessage("Process description"),
        "processing": MessageLookupByLibrary.simpleMessage("Processing..."),
        "processingScanResult":
            MessageLookupByLibrary.simpleMessage("Processing scan result"),
        "processingScanResultError":
            MessageLookupByLibrary.simpleMessage("Processing failed"),
        "processing_status":
            MessageLookupByLibrary.simpleMessage("Processing Status"),
        "promo": MessageLookupByLibrary.simpleMessage("Promotional Video"),
        "promoDetail": MessageLookupByLibrary.simpleMessage("Promo Detail"),
        "promoList": MessageLookupByLibrary.simpleMessage("Promo List"),
        "publicAddress":
            MessageLookupByLibrary.simpleMessage("Detailed address"),
        "publicBusinessHours":
            MessageLookupByLibrary.simpleMessage("Business hours"),
        "publication_date":
            MessageLookupByLibrary.simpleMessage("Publication Date"),
        "publish": MessageLookupByLibrary.simpleMessage("Publish"),
        "publishInfo":
            MessageLookupByLibrary.simpleMessage("Publish information"),
        "publish_failed":
            MessageLookupByLibrary.simpleMessage("Publish failed"),
        "publish_good_deeds":
            MessageLookupByLibrary.simpleMessage("Publish Good Deeds"),
        "publish_success_wait_for_audit": MessageLookupByLibrary.simpleMessage(
            "Publish success, wait for audit"),
        "publisher": MessageLookupByLibrary.simpleMessage("Publisher"),
        "pullUpLoadMore":
            MessageLookupByLibrary.simpleMessage("Pull up to load more"),
        "read": MessageLookupByLibrary.simpleMessage("Read"),
        "receive": MessageLookupByLibrary.simpleMessage("Receive"),
        "receivePlace":
            MessageLookupByLibrary.simpleMessage("Receiving Address"),
        "receiveTime": MessageLookupByLibrary.simpleMessage("Found Time"),
        "received": MessageLookupByLibrary.simpleMessage("Received"),
        "recentlyScanned":
            MessageLookupByLibrary.simpleMessage("Recently Scanned"),
        "recommendPerson": MessageLookupByLibrary.simpleMessage("Recommender"),
        "recommendReason":
            MessageLookupByLibrary.simpleMessage("Recommendation Reason"),
        "recommendTime":
            MessageLookupByLibrary.simpleMessage("Recommendation Time"),
        "record_the_warm_moments_around_you":
            MessageLookupByLibrary.simpleMessage(
                "Record the warm moments around you, pass on positive energy"),
        "reduceOrder": MessageLookupByLibrary.simpleMessage("Reduce Order"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "refreshComplete":
            MessageLookupByLibrary.simpleMessage("Refresh complete"),
        "refreshFailed": MessageLookupByLibrary.simpleMessage("Refresh failed"),
        "refresh_food_menu": MessageLookupByLibrary.simpleMessage("Refresh"),
        "refreshing": MessageLookupByLibrary.simpleMessage("Refreshing..."),
        "region": MessageLookupByLibrary.simpleMessage("Region"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registerFailed":
            MessageLookupByLibrary.simpleMessage("Register failed"),
        "registerSuccess":
            MessageLookupByLibrary.simpleMessage("Register success"),
        "registerText":
            MessageLookupByLibrary.simpleMessage("No account? Register now"),
        "related_account":
            MessageLookupByLibrary.simpleMessage("Related Account"),
        "releaseLoadMore":
            MessageLookupByLibrary.simpleMessage("Release to load more"),
        "reload": MessageLookupByLibrary.simpleMessage("Reload"),
        "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
        "remark": MessageLookupByLibrary.simpleMessage("Remark"),
        "remark_info": MessageLookupByLibrary.simpleMessage("Remark Info"),
        "rememberPassword":
            MessageLookupByLibrary.simpleMessage("Remember password"),
        "repairAddress": MessageLookupByLibrary.simpleMessage("Repair Address"),
        "repairAddressNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Repair address cannot be empty"),
        "repairArea": MessageLookupByLibrary.simpleMessage("Repair Area"),
        "repairContent": MessageLookupByLibrary.simpleMessage("Repair Content"),
        "repairContentNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Repair content cannot be empty"),
        "repairDescription": MessageLookupByLibrary.simpleMessage(
            "Please fill in repair description"),
        "repairDetail": MessageLookupByLibrary.simpleMessage("Repair Details"),
        "repairDirection":
            MessageLookupByLibrary.simpleMessage("Repair Description"),
        "repairFeedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "repairFeedbackTip": MessageLookupByLibrary.simpleMessage(
            "Confirm to submit repair feedback?"),
        "repairImage": MessageLookupByLibrary.simpleMessage("Image"),
        "repairImages": MessageLookupByLibrary.simpleMessage("Repair Images"),
        "repairMessage": MessageLookupByLibrary.simpleMessage("Message"),
        "repairNote": MessageLookupByLibrary.simpleMessage("Note"),
        "repairOnline": MessageLookupByLibrary.simpleMessage("Repair Now"),
        "repairOrder": MessageLookupByLibrary.simpleMessage("Repair Order"),
        "repairOrderManagement":
            MessageLookupByLibrary.simpleMessage("Order Management"),
        "repairOrderProcess":
            MessageLookupByLibrary.simpleMessage("Repair order process"),
        "repairOrderProcessed": MessageLookupByLibrary.simpleMessage(
            "Your repair order has been processed"),
        "repairPerson": MessageLookupByLibrary.simpleMessage("Repair Person"),
        "repairPersonNotEmpty": MessageLookupByLibrary.simpleMessage(
            "Repair person cannot be empty"),
        "repairResult": MessageLookupByLibrary.simpleMessage("Repair Result"),
        "repairRoomNo": MessageLookupByLibrary.simpleMessage("Room No"),
        "repairService": MessageLookupByLibrary.simpleMessage("Repair Service"),
        "repairServiceRate": MessageLookupByLibrary.simpleMessage(
            "Please rate the satisfaction of this repair!"),
        "repairStatus": MessageLookupByLibrary.simpleMessage("Status"),
        "repairSubmitFailed":
            MessageLookupByLibrary.simpleMessage("Repair submission failed"),
        "repairSubmitSuccess": MessageLookupByLibrary.simpleMessage(
            "Repair submitted successfully"),
        "repairSubmitTime": MessageLookupByLibrary.simpleMessage("Repair Time"),
        "repairTel": MessageLookupByLibrary.simpleMessage("Tel"),
        "repairTime": MessageLookupByLibrary.simpleMessage("Processing Time"),
        "repairType": MessageLookupByLibrary.simpleMessage("Type"),
        "repaired": MessageLookupByLibrary.simpleMessage("Repaired"),
        "replied": MessageLookupByLibrary.simpleMessage("Replied"),
        "reply_content": MessageLookupByLibrary.simpleMessage("Reply Content"),
        "reply_person": MessageLookupByLibrary.simpleMessage("Reply Person"),
        "reply_status": MessageLookupByLibrary.simpleMessage("Reply Status"),
        "reply_time": MessageLookupByLibrary.simpleMessage("Reply Time"),
        "reply_to_feedback":
            MessageLookupByLibrary.simpleMessage("Reply Feedback"),
        "report_hazard": MessageLookupByLibrary.simpleMessage("Report Hazard"),
        "reporter": MessageLookupByLibrary.simpleMessage("Reporter"),
        "reporter_name": MessageLookupByLibrary.simpleMessage("Name"),
        "reporter_tel": MessageLookupByLibrary.simpleMessage("Tel"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "reset_success": MessageLookupByLibrary.simpleMessage("Reset Success"),
        "restaurant": MessageLookupByLibrary.simpleMessage("Restaurant"),
        "returnPending": MessageLookupByLibrary.simpleMessage("Return Pending"),
        "reward_details":
            MessageLookupByLibrary.simpleMessage("Reward Details"),
        "satisfaction": MessageLookupByLibrary.simpleMessage("Satisfaction"),
        "saveAddress": MessageLookupByLibrary.simpleMessage("Save address"),
        "saveAddressFail":
            MessageLookupByLibrary.simpleMessage("Save address failed"),
        "saveAddressSuccess":
            MessageLookupByLibrary.simpleMessage("Save address success"),
        "scanQRCode": MessageLookupByLibrary.simpleMessage("Scan QR Code"),
        "scanQRCodeTips": MessageLookupByLibrary.simpleMessage(
            "Put the QR code in the box to scan automatically"),
        "scanSettings": MessageLookupByLibrary.simpleMessage("Scan Settings"),
        "scanStatus": MessageLookupByLibrary.simpleMessage("Scan Status"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "searchMessage": MessageLookupByLibrary.simpleMessage("Search message"),
        "searchMyOrder":
            MessageLookupByLibrary.simpleMessage("Search my order"),
        "search_good_deeds":
            MessageLookupByLibrary.simpleMessage("Search Good Deeds..."),
        "secret": MessageLookupByLibrary.simpleMessage("Secret"),
        "selectAddress":
            MessageLookupByLibrary.simpleMessage("Select delivery address"),
        "selectAllOrDeselectAll":
            MessageLookupByLibrary.simpleMessage("Select All/Deselect All"),
        "selectByTime": MessageLookupByLibrary.simpleMessage("Select by Time"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Select date"),
        "selectMealTimeAndFoodType": MessageLookupByLibrary.simpleMessage(
            "Select the corresponding meal time and food type"),
        "selectRepairTime":
            MessageLookupByLibrary.simpleMessage("Please select repair time"),
        "selectRepairType":
            MessageLookupByLibrary.simpleMessage("Please select repair type"),
        "select_date": MessageLookupByLibrary.simpleMessage("Select Date"),
        "select_discover_date":
            MessageLookupByLibrary.simpleMessage("Select Discover Date"),
        "select_discover_description":
            MessageLookupByLibrary.simpleMessage("Describe Discover"),
        "select_discover_location":
            MessageLookupByLibrary.simpleMessage("Select Discover Location"),
        "select_discover_photo":
            MessageLookupByLibrary.simpleMessage("Upload Discover Photo"),
        "select_discover_time":
            MessageLookupByLibrary.simpleMessage("Select Discover Time"),
        "selected": MessageLookupByLibrary.simpleMessage("Selected"),
        "selfPickup": MessageLookupByLibrary.simpleMessage("Self Pickup"),
        "serviceGuide": MessageLookupByLibrary.simpleMessage("Service Guide"),
        "setDefault": MessageLookupByLibrary.simpleMessage(
            "Confirm to set this address as default?"),
        "share_your_good_deeds":
            MessageLookupByLibrary.simpleMessage("Share Your Good Deeds"),
        "shopWorkbench": MessageLookupByLibrary.simpleMessage("Shop Workbench"),
        "size": MessageLookupByLibrary.simpleMessage("Size"),
        "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
        "startLocation": MessageLookupByLibrary.simpleMessage("Start location"),
        "startStation": MessageLookupByLibrary.simpleMessage("Start Station"),
        "stationNumber": MessageLookupByLibrary.simpleMessage("Station Number"),
        "stopList": MessageLookupByLibrary.simpleMessage("Stop List"),
        "stopLocation": MessageLookupByLibrary.simpleMessage("Stop location"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "submitFail": MessageLookupByLibrary.simpleMessage("Submit failed"),
        "submitOrder": MessageLookupByLibrary.simpleMessage("Submit order"),
        "submitSuccess": MessageLookupByLibrary.simpleMessage("Submit success"),
        "submit_failed": MessageLookupByLibrary.simpleMessage("Submit Failed"),
        "submit_hazard_report_content": MessageLookupByLibrary.simpleMessage(
            "Confirm to submit hazard report?"),
        "submit_hazard_report_fail":
            MessageLookupByLibrary.simpleMessage("Submit Failed"),
        "submit_hazard_report_success":
            MessageLookupByLibrary.simpleMessage("Submit Success"),
        "submitting": MessageLookupByLibrary.simpleMessage("Submitting..."),
        "supplementOrder":
            MessageLookupByLibrary.simpleMessage("Supplement Order"),
        "takePhoto": MessageLookupByLibrary.simpleMessage("Take photo"),
        "takeout": MessageLookupByLibrary.simpleMessage("Takeout"),
        "threeMonths": MessageLookupByLibrary.simpleMessage("Three Months"),
        "timetable": MessageLookupByLibrary.simpleMessage("Timetable"),
        "tip": MessageLookupByLibrary.simpleMessage("Tip"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "title_at_least_2_characters":
            MessageLookupByLibrary.simpleMessage("Title at least 2 characters"),
        "to": MessageLookupByLibrary.simpleMessage("To"),
        "toBeAudited": MessageLookupByLibrary.simpleMessage("Pending Review"),
        "toBeAuditedMessage": MessageLookupByLibrary.simpleMessage(
            "Submitted successfully, pending review"),
        "toBeDelivered":
            MessageLookupByLibrary.simpleMessage("To Be Delivered"),
        "toBeFound": MessageLookupByLibrary.simpleMessage("To Be Found"),
        "toBePacked": MessageLookupByLibrary.simpleMessage("To Be Packed"),
        "toBeReceived":
            MessageLookupByLibrary.simpleMessage("Pending Collection"),
        "toBeReceivedSuccess": MessageLookupByLibrary.simpleMessage("Received"),
        "toBeRejected": MessageLookupByLibrary.simpleMessage("Rejected"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "toolPage": MessageLookupByLibrary.simpleMessage("Toolbox"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "tripNumber": MessageLookupByLibrary.simpleMessage("Trip Number"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "type_no": MessageLookupByLibrary.simpleMessage("Type No"),
        "unbind": MessageLookupByLibrary.simpleMessage("Unbind"),
        "unbindFail": MessageLookupByLibrary.simpleMessage("Unbind failed"),
        "unbindSuccess": MessageLookupByLibrary.simpleMessage("Unbind success"),
        "unbound": MessageLookupByLibrary.simpleMessage("Unbound"),
        "unfixed": MessageLookupByLibrary.simpleMessage("Unfixed"),
        "unfixedReason": MessageLookupByLibrary.simpleMessage(
            "Please specify the reason for unfixed"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownName": MessageLookupByLibrary.simpleMessage("Unknown Name"),
        "unknownStatus": MessageLookupByLibrary.simpleMessage("Unknown Status"),
        "unknown_dish": MessageLookupByLibrary.simpleMessage("Unknown Dish"),
        "unknown_error": MessageLookupByLibrary.simpleMessage("Unknown error"),
        "unknown_status":
            MessageLookupByLibrary.simpleMessage("Unknown Status"),
        "unknown_time": MessageLookupByLibrary.simpleMessage("Unknown Time"),
        "unknown_title": MessageLookupByLibrary.simpleMessage("Unknown Title"),
        "unlike": MessageLookupByLibrary.simpleMessage("Unlike"),
        "unread": MessageLookupByLibrary.simpleMessage("Unread"),
        "unreceived": MessageLookupByLibrary.simpleMessage("Unreceived"),
        "unreceivedOrder":
            MessageLookupByLibrary.simpleMessage("Unreceived Order"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateAddressData":
            MessageLookupByLibrary.simpleMessage("Update Address"),
        "updateAppStore": MessageLookupByLibrary.simpleMessage(
            "Please download the latest version from the App Store"),
        "updateNow": MessageLookupByLibrary.simpleMessage("Update Now"),
        "updatePaymentPassword":
            MessageLookupByLibrary.simpleMessage("Update payment password"),
        "updateTime": MessageLookupByLibrary.simpleMessage("Update time"),
        "update_time": MessageLookupByLibrary.simpleMessage("Update Time"),
        "uploadFacePhoto":
            MessageLookupByLibrary.simpleMessage("Please upload a face photo"),
        "uploadImageFailed":
            MessageLookupByLibrary.simpleMessage("Image upload failed"),
        "uploadImages": MessageLookupByLibrary.simpleMessage("Upload Images"),
        "uploadNewFacePhoto":
            MessageLookupByLibrary.simpleMessage("Upload New ID Photo"),
        "upload_images_failed": MessageLookupByLibrary.simpleMessage(
            "Image upload failed, please try again"),
        "usageInstructions":
            MessageLookupByLibrary.simpleMessage("Usage Instructions"),
        "useHandheldScannerToScanBarcode": MessageLookupByLibrary.simpleMessage(
            "Scan barcode with handheld device"),
        "userFeedback": MessageLookupByLibrary.simpleMessage("User Feedback"),
        "userInfo": MessageLookupByLibrary.simpleMessage("User information"),
        "userName": MessageLookupByLibrary.simpleMessage("Account"),
        "userNamePlaceholder":
            MessageLookupByLibrary.simpleMessage("Enter your account"),
        "usernamePlaceholder":
            MessageLookupByLibrary.simpleMessage("Enter your employee number"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "viewOrder": MessageLookupByLibrary.simpleMessage("View order"),
        "viewPerson": MessageLookupByLibrary.simpleMessage("View Person"),
        "viewed": MessageLookupByLibrary.simpleMessage("Viewed"),
        "waitingForScan":
            MessageLookupByLibrary.simpleMessage("Waiting for scan..."),
        "warningPage": MessageLookupByLibrary.simpleMessage("SOS"),
        "waterService": MessageLookupByLibrary.simpleMessage("20L"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to IWIP"),
        "woman": MessageLookupByLibrary.simpleMessage("Female"),
        "workNo": MessageLookupByLibrary.simpleMessage("Work Number"),
        "zh": MessageLookupByLibrary.simpleMessage("中文")
      };
}
