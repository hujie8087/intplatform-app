// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `IWIP Integrated Platform`
  String get appTitle {
    return Intl.message(
      'IWIP Integrated Platform',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to IWIP`
  String get welcome {
    return Intl.message(
      'Welcome to IWIP',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginBtn {
    return Intl.message(
      'Login',
      name: 'loginBtn',
      desc: '',
      args: [],
    );
  }

  /// `Enter your employee number`
  String get usernamePlaceholder {
    return Intl.message(
      'Enter your employee number',
      name: 'usernamePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get passwordPlaceholder {
    return Intl.message(
      'Enter your password',
      name: 'passwordPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Login success`
  String get loginSuccess {
    return Intl.message(
      'Login success',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Network connection error`
  String get networkError {
    return Intl.message(
      'Network connection error',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `User information`
  String get userInfo {
    return Intl.message(
      'User information',
      name: 'userInfo',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to logout?`
  String get logoutTip {
    return Intl.message(
      'Are you sure to logout?',
      name: 'logoutTip',
      desc: '',
      args: [],
    );
  }

  /// `Logout success`
  String get logoutSuccess {
    return Intl.message(
      'Logout success',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Logout failed`
  String get logoutFailed {
    return Intl.message(
      'Logout failed',
      name: 'logoutFailed',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get changeLanguage {
    return Intl.message(
      'Change language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Change theme`
  String get changeTheme {
    return Intl.message(
      'Change theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactUs {
    return Intl.message(
      'Contact us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `中文`
  String get zh {
    return Intl.message(
      '中文',
      name: 'zh',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get en {
    return Intl.message(
      'English',
      name: 'en',
      desc: '',
      args: [],
    );
  }

  /// `Indonesia`
  String get id {
    return Intl.message(
      'Indonesia',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homePage {
    return Intl.message(
      'Home',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `Toolbox`
  String get toolPage {
    return Intl.message(
      'Toolbox',
      name: 'toolPage',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get minePage {
    return Intl.message(
      'Mine',
      name: 'minePage',
      desc: '',
      args: [],
    );
  }

  /// `Repair Now`
  String get repairOnline {
    return Intl.message(
      'Repair Now',
      name: 'repairOnline',
      desc: '',
      args: [],
    );
  }

  /// `My Repair`
  String get myRepair {
    return Intl.message(
      'My Repair',
      name: 'myRepair',
      desc: '',
      args: [],
    );
  }

  /// `Company News`
  String get news {
    return Intl.message(
      'Company News',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message(
      'Notice',
      name: 'notice',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message(
      'No data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get read {
    return Intl.message(
      'Read',
      name: 'read',
      desc: '',
      args: [],
    );
  }

  /// `Unread`
  String get unread {
    return Intl.message(
      'Unread',
      name: 'unread',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Repair Service`
  String get repairService {
    return Intl.message(
      'Repair Service',
      name: 'repairService',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Old password cannot be empty`
  String get oldPasswordNotEmpty {
    return Intl.message(
      'Old password cannot be empty',
      name: 'oldPasswordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `New password cannot be empty`
  String get newPasswordNotEmpty {
    return Intl.message(
      'New password cannot be empty',
      name: 'newPasswordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordNotEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Two passwords are not the same`
  String get passwordNotSame {
    return Intl.message(
      'Two passwords are not the same',
      name: 'passwordNotSame',
      desc: '',
      args: [],
    );
  }

  /// `Password change success`
  String get passwordChangeSuccess {
    return Intl.message(
      'Password change success',
      name: 'passwordChangeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Password change failed`
  String get passwordChangeFailed {
    return Intl.message(
      'Password change failed',
      name: 'passwordChangeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Enter {title}`
  String inputMessage(Object title) {
    return Intl.message(
      'Enter $title',
      name: 'inputMessage',
      desc: '',
      args: [title],
    );
  }

  /// `Please enter the new password again`
  String get enterNewPasswordAgin {
    return Intl.message(
      'Please enter the new password again',
      name: 'enterNewPasswordAgin',
      desc: '',
      args: [],
    );
  }

  /// `Password length is 6-16 characters`
  String get passwordLength {
    return Intl.message(
      'Password length is 6-16 characters',
      name: 'passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get man {
    return Intl.message(
      'Male',
      name: 'man',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get woman {
    return Intl.message(
      'Female',
      name: 'woman',
      desc: '',
      args: [],
    );
  }

  /// `Secret`
  String get secret {
    return Intl.message(
      'Secret',
      name: 'secret',
      desc: '',
      args: [],
    );
  }

  /// `Change Successful`
  String get changeSuccess {
    return Intl.message(
      'Change Successful',
      name: 'changeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Click to Change Avatar`
  String get changeAvatar {
    return Intl.message(
      'Click to Change Avatar',
      name: 'changeAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Work Number`
  String get workNo {
    return Intl.message(
      'Work Number',
      name: 'workNo',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Department`
  String get dept {
    return Intl.message(
      'Department',
      name: 'dept',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Please select`
  String get pleaseSelect {
    return Intl.message(
      'Please select',
      name: 'pleaseSelect',
      desc: '',
      args: [],
    );
  }

  /// `Repair Address`
  String get repairAddress {
    return Intl.message(
      'Repair Address',
      name: 'repairAddress',
      desc: '',
      args: [],
    );
  }

  /// `Repair address cannot be empty`
  String get repairAddressNotEmpty {
    return Intl.message(
      'Repair address cannot be empty',
      name: 'repairAddressNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Repair Area`
  String get repairArea {
    return Intl.message(
      'Repair Area',
      name: 'repairArea',
      desc: '',
      args: [],
    );
  }

  /// `Repair Images`
  String get repairImages {
    return Intl.message(
      'Repair Images',
      name: 'repairImages',
      desc: '',
      args: [],
    );
  }

  /// `Repair Content`
  String get repairContent {
    return Intl.message(
      'Repair Content',
      name: 'repairContent',
      desc: '',
      args: [],
    );
  }

  /// `Repair content cannot be empty`
  String get repairContentNotEmpty {
    return Intl.message(
      'Repair content cannot be empty',
      name: 'repairContentNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Repair Person`
  String get repairPerson {
    return Intl.message(
      'Repair Person',
      name: 'repairPerson',
      desc: '',
      args: [],
    );
  }

  /// `Repair person cannot be empty`
  String get repairPersonNotEmpty {
    return Intl.message(
      'Repair person cannot be empty',
      name: 'repairPersonNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Contact Phone`
  String get contactPhone {
    return Intl.message(
      'Contact Phone',
      name: 'contactPhone',
      desc: '',
      args: [],
    );
  }

  /// `Contact phone cannot be empty`
  String get contactPhoneNotEmpty {
    return Intl.message(
      'Contact phone cannot be empty',
      name: 'contactPhoneNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Upload Images`
  String get uploadImages {
    return Intl.message(
      'Upload Images',
      name: 'uploadImages',
      desc: '',
      args: [],
    );
  }

  /// `Drag to remove image`
  String get dragRemoveImage {
    return Intl.message(
      'Drag to remove image',
      name: 'dragRemoveImage',
      desc: '',
      args: [],
    );
  }

  /// `Image uploading...`
  String get imageUploading {
    return Intl.message(
      'Image uploading...',
      name: 'imageUploading',
      desc: '',
      args: [],
    );
  }

  /// `Repair submitted successfully`
  String get repairSubmitSuccess {
    return Intl.message(
      'Repair submitted successfully',
      name: 'repairSubmitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Repair submission failed`
  String get repairSubmitFailed {
    return Intl.message(
      'Repair submission failed',
      name: 'repairSubmitFailed',
      desc: '',
      args: [],
    );
  }

  /// `Drag here to remove`
  String get dragHereToRemove {
    return Intl.message(
      'Drag here to remove',
      name: 'dragHereToRemove',
      desc: '',
      args: [],
    );
  }

  /// `Please rate the satisfaction of this repair!`
  String get repairServiceRate {
    return Intl.message(
      'Please rate the satisfaction of this repair!',
      name: 'repairServiceRate',
      desc: '',
      args: [],
    );
  }

  /// `Tip`
  String get tip {
    return Intl.message(
      'Tip',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to submit repair feedback?`
  String get repairFeedbackTip {
    return Intl.message(
      'Confirm to submit repair feedback?',
      name: 'repairFeedbackTip',
      desc: '',
      args: [],
    );
  }

  /// `Processing Time`
  String get repairTime {
    return Intl.message(
      'Processing Time',
      name: 'repairTime',
      desc: '',
      args: [],
    );
  }

  /// `Repair Time`
  String get repairSubmitTime {
    return Intl.message(
      'Repair Time',
      name: 'repairSubmitTime',
      desc: '',
      args: [],
    );
  }

  /// `Repair Description`
  String get repairDirection {
    return Intl.message(
      'Repair Description',
      name: 'repairDirection',
      desc: '',
      args: [],
    );
  }

  /// `Repair Result`
  String get repairResult {
    return Intl.message(
      'Repair Result',
      name: 'repairResult',
      desc: '',
      args: [],
    );
  }

  /// `Fixed`
  String get fixed {
    return Intl.message(
      'Fixed',
      name: 'fixed',
      desc: '',
      args: [],
    );
  }

  /// `Unfixed`
  String get unfixed {
    return Intl.message(
      'Unfixed',
      name: 'unfixed',
      desc: '',
      args: [],
    );
  }

  /// `Satisfaction`
  String get satisfaction {
    return Intl.message(
      'Satisfaction',
      name: 'satisfaction',
      desc: '',
      args: [],
    );
  }

  /// `User Feedback`
  String get userFeedback {
    return Intl.message(
      'User Feedback',
      name: 'userFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Please specify the reason for unfixed`
  String get unfixedReason {
    return Intl.message(
      'Please specify the reason for unfixed',
      name: 'unfixedReason',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to your account`
  String get needLogin {
    return Intl.message(
      'Please log in to your account',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Repaired`
  String get repaired {
    return Intl.message(
      'Repaired',
      name: 'repaired',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Return Pending`
  String get returnPending {
    return Intl.message(
      'Return Pending',
      name: 'returnPending',
      desc: '',
      args: [],
    );
  }

  /// `Repair Details`
  String get repairDetail {
    return Intl.message(
      'Repair Details',
      name: 'repairDetail',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Status`
  String get unknownStatus {
    return Intl.message(
      'Unknown Status',
      name: 'unknownStatus',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteRepair {
    return Intl.message(
      'Delete',
      name: 'deleteRepair',
      desc: '',
      args: [],
    );
  }

  /// `Evaluate`
  String get evaluate {
    return Intl.message(
      'Evaluate',
      name: 'evaluate',
      desc: '',
      args: [],
    );
  }

  /// `Delete repair success`
  String get deleteRepairSuccess {
    return Intl.message(
      'Delete repair success',
      name: 'deleteRepairSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Confirm to delete this repair order?`
  String get deleteRepairTips {
    return Intl.message(
      'Confirm to delete this repair order?',
      name: 'deleteRepairTips',
      desc: '',
      args: [],
    );
  }

  /// `Living Area Data Loading...`
  String get livingAreaDataLoading {
    return Intl.message(
      'Living Area Data Loading...',
      name: 'livingAreaDataLoading',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get checkUpdate {
    return Intl.message(
      'Check Update',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `App Version`
  String get appVersion {
    return Intl.message(
      'App Version',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
