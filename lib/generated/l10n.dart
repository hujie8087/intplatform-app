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

  /// `IWIP后勤综合服务`
  String get appTitle {
    return Intl.message(
      'IWIP后勤综合服务',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `您好`
  String get hello {
    return Intl.message(
      '您好',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `欢迎来到IWIP后勤综合服务APP`
  String get welcome {
    return Intl.message(
      '欢迎来到IWIP后勤综合服务APP',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get loginBtn {
    return Intl.message(
      '登录',
      name: 'loginBtn',
      desc: '',
      args: [],
    );
  }

  /// `账号`
  String get userName {
    return Intl.message(
      '账号',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `消息`
  String get message {
    return Intl.message(
      '消息',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `全部已读`
  String get allRead {
    return Intl.message(
      '全部已读',
      name: 'allRead',
      desc: '',
      args: [],
    );
  }

  /// `搜索消息`
  String get searchMessage {
    return Intl.message(
      '搜索消息',
      name: 'searchMessage',
      desc: '',
      args: [],
    );
  }

  /// `请输入您的工号`
  String get usernamePlaceholder {
    return Intl.message(
      '请输入您的工号',
      name: 'usernamePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `请输入您的密码`
  String get passwordPlaceholder {
    return Intl.message(
      '请输入您的密码',
      name: 'passwordPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `登录失败`
  String get loginFailed {
    return Intl.message(
      '登录失败',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `登录成功`
  String get loginSuccess {
    return Intl.message(
      '登录成功',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `网络连接错误`
  String get networkError {
    return Intl.message(
      '网络连接错误',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `个人信息`
  String get userInfo {
    return Intl.message(
      '个人信息',
      name: 'userInfo',
      desc: '',
      args: [],
    );
  }

  /// `修改密码`
  String get changePassword {
    return Intl.message(
      '修改密码',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `退出登录`
  String get logout {
    return Intl.message(
      '退出登录',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `确定要退出登录吗？`
  String get logoutTip {
    return Intl.message(
      '确定要退出登录吗？',
      name: 'logoutTip',
      desc: '',
      args: [],
    );
  }

  /// `退出登录成功`
  String get logoutSuccess {
    return Intl.message(
      '退出登录成功',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `退出登录失败`
  String get logoutFailed {
    return Intl.message(
      '退出登录失败',
      name: 'logoutFailed',
      desc: '',
      args: [],
    );
  }

  /// `我的`
  String get mine {
    return Intl.message(
      '我的',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `切换语言`
  String get changeLanguage {
    return Intl.message(
      '切换语言',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `切换主题`
  String get changeTheme {
    return Intl.message(
      '切换主题',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `通知公告`
  String get notifications {
    return Intl.message(
      '通知公告',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `联系我们`
  String get contactUs {
    return Intl.message(
      '联系我们',
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

  /// `首页`
  String get homePage {
    return Intl.message(
      '首页',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `工具箱`
  String get toolPage {
    return Intl.message(
      '工具箱',
      name: 'toolPage',
      desc: '',
      args: [],
    );
  }

  /// `我的`
  String get minePage {
    return Intl.message(
      '我的',
      name: 'minePage',
      desc: '',
      args: [],
    );
  }

  /// `在线报修`
  String get repairOnline {
    return Intl.message(
      '在线报修',
      name: 'repairOnline',
      desc: '',
      args: [],
    );
  }

  /// `我的报修`
  String get myRepair {
    return Intl.message(
      '我的报修',
      name: 'myRepair',
      desc: '',
      args: [],
    );
  }

  /// `报修订单`
  String get repairOrder {
    return Intl.message(
      '报修订单',
      name: 'repairOrder',
      desc: '',
      args: [],
    );
  }

  /// `公司新闻`
  String get news {
    return Intl.message(
      '公司新闻',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `公告`
  String get notice {
    return Intl.message(
      '公告',
      name: 'notice',
      desc: '',
      args: [],
    );
  }

  /// `暂无数据`
  String get noData {
    return Intl.message(
      '暂无数据',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `已读`
  String get read {
    return Intl.message(
      '已读',
      name: 'read',
      desc: '',
      args: [],
    );
  }

  /// `未读`
  String get unread {
    return Intl.message(
      '未读',
      name: 'unread',
      desc: '',
      args: [],
    );
  }

  /// `资讯类`
  String get information {
    return Intl.message(
      '资讯类',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `报修服务`
  String get repairService {
    return Intl.message(
      '报修服务',
      name: 'repairService',
      desc: '',
      args: [],
    );
  }

  /// `旧密码`
  String get oldPassword {
    return Intl.message(
      '旧密码',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `新密码`
  String get newPassword {
    return Intl.message(
      '新密码',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get password {
    return Intl.message(
      '密码',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `旧密码不能为空`
  String get oldPasswordNotEmpty {
    return Intl.message(
      '旧密码不能为空',
      name: 'oldPasswordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `新密码不能为空`
  String get newPasswordNotEmpty {
    return Intl.message(
      '新密码不能为空',
      name: 'newPasswordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `密码不能为空`
  String get passwordNotEmpty {
    return Intl.message(
      '密码不能为空',
      name: 'passwordNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `两次密码不一致`
  String get passwordNotSame {
    return Intl.message(
      '两次密码不一致',
      name: 'passwordNotSame',
      desc: '',
      args: [],
    );
  }

  /// `密码修改成功`
  String get passwordChangeSuccess {
    return Intl.message(
      '密码修改成功',
      name: 'passwordChangeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `密码修改失败`
  String get passwordChangeFailed {
    return Intl.message(
      '密码修改失败',
      name: 'passwordChangeFailed',
      desc: '',
      args: [],
    );
  }

  /// `请输入{title}`
  String inputMessage(Object title) {
    return Intl.message(
      '请输入$title',
      name: 'inputMessage',
      desc: '',
      args: [title],
    );
  }

  /// `请再次输入新密码`
  String get enterNewPasswordAgin {
    return Intl.message(
      '请再次输入新密码',
      name: 'enterNewPasswordAgin',
      desc: '',
      args: [],
    );
  }

  /// `密码长度为6-16位`
  String get passwordLength {
    return Intl.message(
      '密码长度为6-16位',
      name: 'passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `提交`
  String get submit {
    return Intl.message(
      '提交',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `男`
  String get man {
    return Intl.message(
      '男',
      name: 'man',
      desc: '',
      args: [],
    );
  }

  /// `女`
  String get woman {
    return Intl.message(
      '女',
      name: 'woman',
      desc: '',
      args: [],
    );
  }

  /// `保密`
  String get secret {
    return Intl.message(
      '保密',
      name: 'secret',
      desc: '',
      args: [],
    );
  }

  /// `修改成功`
  String get changeSuccess {
    return Intl.message(
      '修改成功',
      name: 'changeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `点击更换头像`
  String get changeAvatar {
    return Intl.message(
      '点击更换头像',
      name: 'changeAvatar',
      desc: '',
      args: [],
    );
  }

  /// `姓名`
  String get name {
    return Intl.message(
      '姓名',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `工号`
  String get workNo {
    return Intl.message(
      '工号',
      name: 'workNo',
      desc: '',
      args: [],
    );
  }

  /// `身份证号`
  String get idCard {
    return Intl.message(
      '身份证号',
      name: 'idCard',
      desc: '',
      args: [],
    );
  }

  /// `电话`
  String get phone {
    return Intl.message(
      '电话',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `邮箱`
  String get email {
    return Intl.message(
      '邮箱',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `性别`
  String get gender {
    return Intl.message(
      '性别',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `生日`
  String get birthday {
    return Intl.message(
      '生日',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `地址`
  String get address {
    return Intl.message(
      '地址',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `更新`
  String get update {
    return Intl.message(
      '更新',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `部门`
  String get dept {
    return Intl.message(
      '部门',
      name: 'dept',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `确认`
  String get confirm {
    return Intl.message(
      '确认',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `请选择{title}`
  String pleaseSelect(Object title) {
    return Intl.message(
      '请选择$title',
      name: 'pleaseSelect',
      desc: '',
      args: [title],
    );
  }

  /// `报修地址`
  String get repairAddress {
    return Intl.message(
      '报修地址',
      name: 'repairAddress',
      desc: '',
      args: [],
    );
  }

  /// `报修地址不能为空`
  String get repairAddressNotEmpty {
    return Intl.message(
      '报修地址不能为空',
      name: 'repairAddressNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `报修区域`
  String get repairArea {
    return Intl.message(
      '报修区域',
      name: 'repairArea',
      desc: '',
      args: [],
    );
  }

  /// `报修图片`
  String get repairImages {
    return Intl.message(
      '报修图片',
      name: 'repairImages',
      desc: '',
      args: [],
    );
  }

  /// `报修内容`
  String get repairContent {
    return Intl.message(
      '报修内容',
      name: 'repairContent',
      desc: '',
      args: [],
    );
  }

  /// `报修内容不能为空`
  String get repairContentNotEmpty {
    return Intl.message(
      '报修内容不能为空',
      name: 'repairContentNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `报修人`
  String get repairPerson {
    return Intl.message(
      '报修人',
      name: 'repairPerson',
      desc: '',
      args: [],
    );
  }

  /// `报修人不能为空`
  String get repairPersonNotEmpty {
    return Intl.message(
      '报修人不能为空',
      name: 'repairPersonNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `联系电话`
  String get contactPhone {
    return Intl.message(
      '联系电话',
      name: 'contactPhone',
      desc: '',
      args: [],
    );
  }

  /// `联系电话不能为空`
  String get contactPhoneNotEmpty {
    return Intl.message(
      '联系电话不能为空',
      name: 'contactPhoneNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `上传图片`
  String get uploadImages {
    return Intl.message(
      '上传图片',
      name: 'uploadImages',
      desc: '',
      args: [],
    );
  }

  /// `拖动删除图片`
  String get dragRemoveImage {
    return Intl.message(
      '拖动删除图片',
      name: 'dragRemoveImage',
      desc: '',
      args: [],
    );
  }

  /// `图片上传中...`
  String get imageUploading {
    return Intl.message(
      '图片上传中...',
      name: 'imageUploading',
      desc: '',
      args: [],
    );
  }

  /// `报修提交成功`
  String get repairSubmitSuccess {
    return Intl.message(
      '报修提交成功',
      name: 'repairSubmitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `报修提交失败`
  String get repairSubmitFailed {
    return Intl.message(
      '报修提交失败',
      name: 'repairSubmitFailed',
      desc: '',
      args: [],
    );
  }

  /// `拖动此处删除`
  String get dragHereToRemove {
    return Intl.message(
      '拖动此处删除',
      name: 'dragHereToRemove',
      desc: '',
      args: [],
    );
  }

  /// `请给对本次维修的满意度打一个综合评分吧！`
  String get repairServiceRate {
    return Intl.message(
      '请给对本次维修的满意度打一个综合评分吧！',
      name: 'repairServiceRate',
      desc: '',
      args: [],
    );
  }

  /// `提示`
  String get tip {
    return Intl.message(
      '提示',
      name: 'tip',
      desc: '',
      args: [],
    );
  }

  /// `确认提交维修反馈吗？`
  String get repairFeedbackTip {
    return Intl.message(
      '确认提交维修反馈吗？',
      name: 'repairFeedbackTip',
      desc: '',
      args: [],
    );
  }

  /// `报修时间`
  String get repairSubmitTime {
    return Intl.message(
      '报修时间',
      name: 'repairSubmitTime',
      desc: '',
      args: [],
    );
  }

  /// `维修时间`
  String get repairTime {
    return Intl.message(
      '维修时间',
      name: 'repairTime',
      desc: '',
      args: [],
    );
  }

  /// `维修说明`
  String get repairDirection {
    return Intl.message(
      '维修说明',
      name: 'repairDirection',
      desc: '',
      args: [],
    );
  }

  /// `维修结果`
  String get repairResult {
    return Intl.message(
      '维修结果',
      name: 'repairResult',
      desc: '',
      args: [],
    );
  }

  /// `已修复`
  String get fixed {
    return Intl.message(
      '已修复',
      name: 'fixed',
      desc: '',
      args: [],
    );
  }

  /// `未修复`
  String get unfixed {
    return Intl.message(
      '未修复',
      name: 'unfixed',
      desc: '',
      args: [],
    );
  }

  /// `满意度`
  String get satisfaction {
    return Intl.message(
      '满意度',
      name: 'satisfaction',
      desc: '',
      args: [],
    );
  }

  /// `用户反馈`
  String get userFeedback {
    return Intl.message(
      '用户反馈',
      name: 'userFeedback',
      desc: '',
      args: [],
    );
  }

  /// `请填写未修复原因`
  String get unfixedReason {
    return Intl.message(
      '请填写未修复原因',
      name: 'unfixedReason',
      desc: '',
      args: [],
    );
  }

  /// `请登录您的帐号`
  String get needLogin {
    return Intl.message(
      '请登录您的帐号',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get all {
    return Intl.message(
      '全部',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `待维修`
  String get pending {
    return Intl.message(
      '待维修',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `已维修`
  String get repaired {
    return Intl.message(
      '已维修',
      name: 'repaired',
      desc: '',
      args: [],
    );
  }

  /// `已完结`
  String get completed {
    return Intl.message(
      '已完结',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `待返修`
  String get returnPending {
    return Intl.message(
      '待返修',
      name: 'returnPending',
      desc: '',
      args: [],
    );
  }

  /// `报修详情`
  String get repairDetail {
    return Intl.message(
      '报修详情',
      name: 'repairDetail',
      desc: '',
      args: [],
    );
  }

  /// `未知状态`
  String get unknownStatus {
    return Intl.message(
      '未知状态',
      name: 'unknownStatus',
      desc: '',
      args: [],
    );
  }

  /// `删除`
  String get deleteRepair {
    return Intl.message(
      '删除',
      name: 'deleteRepair',
      desc: '',
      args: [],
    );
  }

  /// `评价`
  String get evaluate {
    return Intl.message(
      '评价',
      name: 'evaluate',
      desc: '',
      args: [],
    );
  }

  /// `删除报修单成功`
  String get deleteRepairSuccess {
    return Intl.message(
      '删除报修单成功',
      name: 'deleteRepairSuccess',
      desc: '',
      args: [],
    );
  }

  /// `确认删除该报修单吗?`
  String get deleteRepairTips {
    return Intl.message(
      '确认删除该报修单吗?',
      name: 'deleteRepairTips',
      desc: '',
      args: [],
    );
  }

  /// `生活区数据加载中...`
  String get livingAreaDataLoading {
    return Intl.message(
      '生活区数据加载中...',
      name: 'livingAreaDataLoading',
      desc: '',
      args: [],
    );
  }

  /// `检查更新`
  String get checkUpdate {
    return Intl.message(
      '检查更新',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `当前版本号`
  String get appVersion {
    return Intl.message(
      '当前版本号',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }

  /// `更新区域数据`
  String get updateAddressData {
    return Intl.message(
      '更新区域数据',
      name: 'updateAddressData',
      desc: '',
      args: [],
    );
  }

  /// `地址管理`
  String get addressManagement {
    return Intl.message(
      '地址管理',
      name: 'addressManagement',
      desc: '',
      args: [],
    );
  }

  /// `服务指南`
  String get serviceGuide {
    return Intl.message(
      '服务指南',
      name: 'serviceGuide',
      desc: '',
      args: [],
    );
  }

  /// `公司动态`
  String get companyNews {
    return Intl.message(
      '公司动态',
      name: 'companyNews',
      desc: '',
      args: [],
    );
  }

  /// `网络不给力，点击重新加载`
  String get networkErrorTips {
    return Intl.message(
      '网络不给力，点击重新加载',
      name: 'networkErrorTips',
      desc: '',
      args: [],
    );
  }

  /// `点击重试`
  String get clickRetry {
    return Intl.message(
      '点击重试',
      name: 'clickRetry',
      desc: '',
      args: [],
    );
  }

  /// `更多功能`
  String get moreFunction {
    return Intl.message(
      '更多功能',
      name: 'moreFunction',
      desc: '',
      args: [],
    );
  }

  /// `我的地址`
  String get myAddress {
    return Intl.message(
      '我的地址',
      name: 'myAddress',
      desc: '',
      args: [],
    );
  }

  /// `我的反馈`
  String get myFeedback {
    return Intl.message(
      '我的反馈',
      name: 'myFeedback',
      desc: '',
      args: [],
    );
  }

  /// `立即更新`
  String get updateNow {
    return Intl.message(
      '立即更新',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `检测有新版本，请前往APPStore下载最新版`
  String get updateAppStore {
    return Intl.message(
      '检测有新版本，请前往APPStore下载最新版',
      name: 'updateAppStore',
      desc: '',
      args: [],
    );
  }

  /// `在线订餐`
  String get onlineDining {
    return Intl.message(
      '在线订餐',
      name: 'onlineDining',
      desc: '',
      args: [],
    );
  }

  /// `我的订单`
  String get myOrder {
    return Intl.message(
      '我的订单',
      name: 'myOrder',
      desc: '',
      args: [],
    );
  }

  /// `月销`
  String get monthlySales {
    return Intl.message(
      '月销',
      name: 'monthlySales',
      desc: '',
      args: [],
    );
  }

  /// `消费记录`
  String get cardBill {
    return Intl.message(
      '消费记录',
      name: 'cardBill',
      desc: '',
      args: [],
    );
  }

  /// `开始日期`
  String get startDate {
    return Intl.message(
      '开始日期',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `结束日期`
  String get endDate {
    return Intl.message(
      '结束日期',
      name: 'endDate',
      desc: '',
      args: [],
    );
  }

  /// `至`
  String get to {
    return Intl.message(
      '至',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `查询`
  String get search {
    return Intl.message(
      '查询',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `支出`
  String get expenditure {
    return Intl.message(
      '支出',
      name: 'expenditure',
      desc: '',
      args: [],
    );
  }

  /// `卡状态`
  String get cardStatus {
    return Intl.message(
      '卡状态',
      name: 'cardStatus',
      desc: '',
      args: [],
    );
  }

  /// `卡类型`
  String get cardType {
    return Intl.message(
      '卡类型',
      name: 'cardType',
      desc: '',
      args: [],
    );
  }

  /// `卡号`
  String get cardNumber {
    return Intl.message(
      '卡号',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `卡余额`
  String get cardBalance {
    return Intl.message(
      '卡余额',
      name: 'cardBalance',
      desc: '',
      args: [],
    );
  }

  /// `卡密码`
  String get cardPassword {
    return Intl.message(
      '卡密码',
      name: 'cardPassword',
      desc: '',
      args: [],
    );
  }

  /// `卡信息`
  String get cardInfo {
    return Intl.message(
      '卡信息',
      name: 'cardInfo',
      desc: '',
      args: [],
    );
  }

  /// `销卡`
  String get cardDelete {
    return Intl.message(
      '销卡',
      name: 'cardDelete',
      desc: '',
      args: [],
    );
  }

  /// `解挂`
  String get cardLock {
    return Intl.message(
      '解挂',
      name: 'cardLock',
      desc: '',
      args: [],
    );
  }

  /// `挂失`
  String get cardLoss {
    return Intl.message(
      '挂失',
      name: 'cardLoss',
      desc: '',
      args: [],
    );
  }

  /// `有效`
  String get cardValid {
    return Intl.message(
      '有效',
      name: 'cardValid',
      desc: '',
      args: [],
    );
  }

  /// `预销卡`
  String get cardPreDelete {
    return Intl.message(
      '预销卡',
      name: 'cardPreDelete',
      desc: '',
      args: [],
    );
  }

  /// `冻结`
  String get cardFreeze {
    return Intl.message(
      '冻结',
      name: 'cardFreeze',
      desc: '',
      args: [],
    );
  }

  /// `姓名`
  String get cardName {
    return Intl.message(
      '姓名',
      name: 'cardName',
      desc: '',
      args: [],
    );
  }

  /// `部门`
  String get cardDep {
    return Intl.message(
      '部门',
      name: 'cardDep',
      desc: '',
      args: [],
    );
  }

  /// `请输入6位支付密码`
  String get inputPasswordError {
    return Intl.message(
      '请输入6位支付密码',
      name: 'inputPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `挂失成功`
  String get cardLossSuccess {
    return Intl.message(
      '挂失成功',
      name: 'cardLossSuccess',
      desc: '',
      args: [],
    );
  }

  /// `解锁成功`
  String get cardLockSuccess {
    return Intl.message(
      '解锁成功',
      name: 'cardLockSuccess',
      desc: '',
      args: [],
    );
  }

  /// `重置密码`
  String get resetPassword {
    return Intl.message(
      '重置密码',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `请输入您的工号`
  String get inputWorkNumber {
    return Intl.message(
      '请输入您的工号',
      name: 'inputWorkNumber',
      desc: '',
      args: [],
    );
  }

  /// `请输入您的身份证号`
  String get inputIdCard {
    return Intl.message(
      '请输入您的身份证号',
      name: 'inputIdCard',
      desc: '',
      args: [],
    );
  }

  /// `请输入新密码`
  String get inputNewPassword {
    return Intl.message(
      '请输入新密码',
      name: 'inputNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `请输入旧密码`
  String get inputOldPassword {
    return Intl.message(
      '请输入旧密码',
      name: 'inputOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `请再次输入新密码`
  String get inputConfirmPassword {
    return Intl.message(
      '请再次输入新密码',
      name: 'inputConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `支付二维码`
  String get paymentQRCode {
    return Intl.message(
      '支付二维码',
      name: 'paymentQRCode',
      desc: '',
      args: [],
    );
  }

  /// `合计`
  String get total {
    return Intl.message(
      '合计',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `去结算`
  String get checkout {
    return Intl.message(
      '去结算',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `堂食`
  String get diningIn {
    return Intl.message(
      '堂食',
      name: 'diningIn',
      desc: '',
      args: [],
    );
  }

  /// `配送`
  String get delivery {
    return Intl.message(
      '配送',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `打包`
  String get takeout {
    return Intl.message(
      '打包',
      name: 'takeout',
      desc: '',
      args: [],
    );
  }

  /// `点餐`
  String get order {
    return Intl.message(
      '点餐',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `评价`
  String get evaluation {
    return Intl.message(
      '评价',
      name: 'evaluation',
      desc: '',
      args: [],
    );
  }

  /// `餐厅`
  String get restaurant {
    return Intl.message(
      '餐厅',
      name: 'restaurant',
      desc: '',
      args: [],
    );
  }

  /// `数据加载中...`
  String get loading {
    return Intl.message(
      '数据加载中...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `已经到底啦`
  String get endOfList {
    return Intl.message(
      '已经到底啦',
      name: 'endOfList',
      desc: '',
      args: [],
    );
  }

  /// `剩余`
  String get remaining {
    return Intl.message(
      '剩余',
      name: 'remaining',
      desc: '',
      args: [],
    );
  }

  /// `购物车`
  String get cart {
    return Intl.message(
      '购物车',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `清空购物车`
  String get clearCart {
    return Intl.message(
      '清空购物车',
      name: 'clearCart',
      desc: '',
      args: [],
    );
  }

  /// `确定要清空购物车吗？`
  String get clearCartTips {
    return Intl.message(
      '确定要清空购物车吗？',
      name: 'clearCartTips',
      desc: '',
      args: [],
    );
  }

  /// `清空`
  String get clear {
    return Intl.message(
      '清空',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `购物车是空的`
  String get cartEmpty {
    return Intl.message(
      '购物车是空的',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `点餐时间`
  String get diningTime {
    return Intl.message(
      '点餐时间',
      name: 'diningTime',
      desc: '',
      args: [],
    );
  }

  /// `扫描二维码`
  String get scanQRCode {
    return Intl.message(
      '扫描二维码',
      name: 'scanQRCode',
      desc: '',
      args: [],
    );
  }

  /// `餐饮服务`
  String get diningService {
    return Intl.message(
      '餐饮服务',
      name: 'diningService',
      desc: '',
      args: [],
    );
  }

  /// `将二维码放入框内，即可自动扫描`
  String get scanQRCodeTips {
    return Intl.message(
      '将二维码放入框内，即可自动扫描',
      name: 'scanQRCodeTips',
      desc: '',
      args: [],
    );
  }

  /// `需要相机权限才能扫码`
  String get needCameraPermission {
    return Intl.message(
      '需要相机权限才能扫码',
      name: 'needCameraPermission',
      desc: '',
      args: [],
    );
  }

  /// `支付成功`
  String get paySuccess {
    return Intl.message(
      '支付成功',
      name: 'paySuccess',
      desc: '',
      args: [],
    );
  }

  /// `支付失败`
  String get payFail {
    return Intl.message(
      '支付失败',
      name: 'payFail',
      desc: '',
      args: [],
    );
  }

  /// `密码修改成功`
  String get passwordModifySuccess {
    return Intl.message(
      '密码修改成功',
      name: 'passwordModifySuccess',
      desc: '',
      args: [],
    );
  }

  /// `修改支付密码`
  String get updatePaymentPassword {
    return Intl.message(
      '修改支付密码',
      name: 'updatePaymentPassword',
      desc: '',
      args: [],
    );
  }

  /// `确认修改`
  String get confirmModify {
    return Intl.message(
      '确认修改',
      name: 'confirmModify',
      desc: '',
      args: [],
    );
  }

  /// `密码由6位数字组成`
  String get passwordTips {
    return Intl.message(
      '密码由6位数字组成',
      name: 'passwordTips',
      desc: '',
      args: [],
    );
  }

  /// `提交订单`
  String get submitOrder {
    return Intl.message(
      '提交订单',
      name: 'submitOrder',
      desc: '',
      args: [],
    );
  }

  /// `营业时间`
  String get businessHours {
    return Intl.message(
      '营业时间',
      name: 'businessHours',
      desc: '',
      args: [],
    );
  }

  /// `商品信息`
  String get goodsInfo {
    return Intl.message(
      '商品信息',
      name: 'goodsInfo',
      desc: '',
      args: [],
    );
  }

  /// `取餐方式`
  String get pickupType {
    return Intl.message(
      '取餐方式',
      name: 'pickupType',
      desc: '',
      args: [],
    );
  }

  /// `地址信息`
  String get addressInfo {
    return Intl.message(
      '地址信息',
      name: 'addressInfo',
      desc: '',
      args: [],
    );
  }

  /// `不在配送范围，请重新选择地址`
  String get addressOutOfRange {
    return Intl.message(
      '不在配送范围，请重新选择地址',
      name: 'addressOutOfRange',
      desc: '',
      args: [],
    );
  }

  /// `选择收货地址`
  String get selectAddress {
    return Intl.message(
      '选择收货地址',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `配送时间`
  String get deliveryTime {
    return Intl.message(
      '配送时间',
      name: 'deliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `配送费`
  String get deliveryFee {
    return Intl.message(
      '配送费',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `个人信息`
  String get personalInfo {
    return Intl.message(
      '个人信息',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `工号`
  String get employeeNumber {
    return Intl.message(
      '工号',
      name: 'employeeNumber',
      desc: '',
      args: [],
    );
  }

  /// `请填写{title}`
  String pleaseFillIn(Object title) {
    return Intl.message(
      '请填写$title',
      name: 'pleaseFillIn',
      desc: '',
      args: [title],
    );
  }

  /// `取餐限定时间`
  String get pickupLimitTime {
    return Intl.message(
      '取餐限定时间',
      name: 'pickupLimitTime',
      desc: '',
      args: [],
    );
  }

  /// `备注`
  String get remark {
    return Intl.message(
      '备注',
      name: 'remark',
      desc: '',
      args: [],
    );
  }

  /// `确认提交`
  String get confirmSubmit {
    return Intl.message(
      '确认提交',
      name: 'confirmSubmit',
      desc: '',
      args: [],
    );
  }

  /// `确定要提交订单吗？`
  String get confirmSubmitContent {
    return Intl.message(
      '确定要提交订单吗？',
      name: 'confirmSubmitContent',
      desc: '',
      args: [],
    );
  }

  /// `提交成功`
  String get submitSuccess {
    return Intl.message(
      '提交成功',
      name: 'submitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `搜索我的订单`
  String get searchMyOrder {
    return Intl.message(
      '搜索我的订单',
      name: 'searchMyOrder',
      desc: '',
      args: [],
    );
  }

  /// `件`
  String get items {
    return Intl.message(
      '件',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `删除订单`
  String get deleteOrder {
    return Intl.message(
      '删除订单',
      name: 'deleteOrder',
      desc: '',
      args: [],
    );
  }

  /// `删除{title}成功！`
  String deleteSuccess(Object title) {
    return Intl.message(
      '删除$title成功！',
      name: 'deleteSuccess',
      desc: '',
      args: [title],
    );
  }

  /// `订单详情`
  String get orderDetail {
    return Intl.message(
      '订单详情',
      name: 'orderDetail',
      desc: '',
      args: [],
    );
  }

  /// `订单号`
  String get orderNo {
    return Intl.message(
      '订单号',
      name: 'orderNo',
      desc: '',
      args: [],
    );
  }

  /// `订单信息`
  String get orderInfo {
    return Intl.message(
      '订单信息',
      name: 'orderInfo',
      desc: '',
      args: [],
    );
  }

  /// `取餐时间`
  String get pickupTime {
    return Intl.message(
      '取餐时间',
      name: 'pickupTime',
      desc: '',
      args: [],
    );
  }

  /// `下单时间`
  String get orderTime {
    return Intl.message(
      '下单时间',
      name: 'orderTime',
      desc: '',
      args: [],
    );
  }

  /// `商品总额`
  String get goodsTotal {
    return Intl.message(
      '商品总额',
      name: 'goodsTotal',
      desc: '',
      args: [],
    );
  }

  /// `实付金额`
  String get actualPayment {
    return Intl.message(
      '实付金额',
      name: 'actualPayment',
      desc: '',
      args: [],
    );
  }

  /// `我想吃`
  String get iWantToEat {
    return Intl.message(
      '我想吃',
      name: 'iWantToEat',
      desc: '',
      args: [],
    );
  }

  /// `菜品建议`
  String get dishSuggestion {
    return Intl.message(
      '菜品建议',
      name: 'dishSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `菜名`
  String get dishName {
    return Intl.message(
      '菜名',
      name: 'dishName',
      desc: '',
      args: [],
    );
  }

  /// `菜的做法`
  String get dishMethod {
    return Intl.message(
      '菜的做法',
      name: 'dishMethod',
      desc: '',
      args: [],
    );
  }

  /// `留言反馈`
  String get feedback {
    return Intl.message(
      '留言反馈',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `留言标题`
  String get feedbackTitle {
    return Intl.message(
      '留言标题',
      name: 'feedbackTitle',
      desc: '',
      args: [],
    );
  }

  /// `留言内容`
  String get feedbackContent {
    return Intl.message(
      '留言内容',
      name: 'feedbackContent',
      desc: '',
      args: [],
    );
  }

  /// `新增地址`
  String get addAddress {
    return Intl.message(
      '新增地址',
      name: 'addAddress',
      desc: '',
      args: [],
    );
  }

  /// `修改地址`
  String get modifyAddress {
    return Intl.message(
      '修改地址',
      name: 'modifyAddress',
      desc: '',
      args: [],
    );
  }

  /// `联系人`
  String get contactPerson {
    return Intl.message(
      '联系人',
      name: 'contactPerson',
      desc: '',
      args: [],
    );
  }

  /// `是否默认`
  String get isDefault {
    return Intl.message(
      '是否默认',
      name: 'isDefault',
      desc: '',
      args: [],
    );
  }

  /// `默认`
  String get defaultValue {
    return Intl.message(
      '默认',
      name: 'defaultValue',
      desc: '',
      args: [],
    );
  }

  /// `保存地址成功`
  String get saveAddressSuccess {
    return Intl.message(
      '保存地址成功',
      name: 'saveAddressSuccess',
      desc: '',
      args: [],
    );
  }

  /// `保存地址失败`
  String get saveAddressFail {
    return Intl.message(
      '保存地址失败',
      name: 'saveAddressFail',
      desc: '',
      args: [],
    );
  }

  /// `保存地址`
  String get saveAddress {
    return Intl.message(
      '保存地址',
      name: 'saveAddress',
      desc: '',
      args: [],
    );
  }

  /// `管理`
  String get manage {
    return Intl.message(
      '管理',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `退出管理`
  String get exitManage {
    return Intl.message(
      '退出管理',
      name: 'exitManage',
      desc: '',
      args: [],
    );
  }

  /// `确定把该地址设置为默认吗？`
  String get setDefault {
    return Intl.message(
      '确定把该地址设置为默认吗？',
      name: 'setDefault',
      desc: '',
      args: [],
    );
  }

  /// `确定把该地址取消默认吗？`
  String get cancelDefault {
    return Intl.message(
      '确定把该地址取消默认吗？',
      name: 'cancelDefault',
      desc: '',
      args: [],
    );
  }

  /// `确定删除地址吗？`
  String get deleteAddress {
    return Intl.message(
      '确定删除地址吗？',
      name: 'deleteAddress',
      desc: '',
      args: [],
    );
  }

  /// `删除`
  String get delete {
    return Intl.message(
      '删除',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `拍摄`
  String get takePhoto {
    return Intl.message(
      '拍摄',
      name: 'takePhoto',
      desc: '',
      args: [],
    );
  }

  /// `相册`
  String get photoAlbum {
    return Intl.message(
      '相册',
      name: 'photoAlbum',
      desc: '',
      args: [],
    );
  }

  /// `宣传片`
  String get promo {
    return Intl.message(
      '宣传片',
      name: 'promo',
      desc: '',
      args: [],
    );
  }

  /// `宣传片列表`
  String get promoList {
    return Intl.message(
      '宣传片列表',
      name: 'promoList',
      desc: '',
      args: [],
    );
  }

  /// `宣传片详情`
  String get promoDetail {
    return Intl.message(
      '宣传片详情',
      name: 'promoDetail',
      desc: '',
      args: [],
    );
  }

  /// `小K拾光`
  String get kTimeList {
    return Intl.message(
      '小K拾光',
      name: 'kTimeList',
      desc: '',
      args: [],
    );
  }

  /// `小K拾光详情`
  String get kTimeDetail {
    return Intl.message(
      '小K拾光详情',
      name: 'kTimeDetail',
      desc: '',
      args: [],
    );
  }

  /// `纬达贝月刊`
  String get monthly {
    return Intl.message(
      '纬达贝月刊',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'zh'),
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
