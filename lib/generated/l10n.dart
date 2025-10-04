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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `IWIP后勤综合服务`
  String get appTitle {
    return Intl.message('IWIP后勤综合服务', name: 'appTitle', desc: '', args: []);
  }

  /// `您好`
  String get hello {
    return Intl.message('您好', name: 'hello', desc: '', args: []);
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
    return Intl.message('登录', name: 'loginBtn', desc: '', args: []);
  }

  /// `账号`
  String get userName {
    return Intl.message('账号', name: 'userName', desc: '', args: []);
  }

  /// `消息`
  String get message {
    return Intl.message('消息', name: 'message', desc: '', args: []);
  }

  /// `全部已读`
  String get allRead {
    return Intl.message('全部已读', name: 'allRead', desc: '', args: []);
  }

  /// `搜索消息`
  String get searchMessage {
    return Intl.message('搜索消息', name: 'searchMessage', desc: '', args: []);
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
    return Intl.message('登录失败', name: 'loginFailed', desc: '', args: []);
  }

  /// `登录成功`
  String get loginSuccess {
    return Intl.message('登录成功', name: 'loginSuccess', desc: '', args: []);
  }

  /// `网络连接错误`
  String get networkError {
    return Intl.message('网络连接错误', name: 'networkError', desc: '', args: []);
  }

  /// `注册成功`
  String get registerSuccess {
    return Intl.message('注册成功', name: 'registerSuccess', desc: '', args: []);
  }

  /// `注册失败`
  String get registerFailed {
    return Intl.message('注册失败', name: 'registerFailed', desc: '', args: []);
  }

  /// `请再次输入密码`
  String get confirmPassword {
    return Intl.message('请再次输入密码', name: 'confirmPassword', desc: '', args: []);
  }

  /// `注册`
  String get register {
    return Intl.message('注册', name: 'register', desc: '', args: []);
  }

  /// `没有账号？立即注册`
  String get registerText {
    return Intl.message('没有账号？立即注册', name: 'registerText', desc: '', args: []);
  }

  /// `请输入您的账号`
  String get userNamePlaceholder {
    return Intl.message(
      '请输入您的账号',
      name: 'userNamePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `个人信息`
  String get userInfo {
    return Intl.message('个人信息', name: 'userInfo', desc: '', args: []);
  }

  /// `修改密码`
  String get changePassword {
    return Intl.message('修改密码', name: 'changePassword', desc: '', args: []);
  }

  /// `退出登录`
  String get logout {
    return Intl.message('退出登录', name: 'logout', desc: '', args: []);
  }

  /// `确定要退出登录吗？`
  String get logoutTip {
    return Intl.message('确定要退出登录吗？', name: 'logoutTip', desc: '', args: []);
  }

  /// `退出登录成功`
  String get logoutSuccess {
    return Intl.message('退出登录成功', name: 'logoutSuccess', desc: '', args: []);
  }

  /// `退出登录失败`
  String get logoutFailed {
    return Intl.message('退出登录失败', name: 'logoutFailed', desc: '', args: []);
  }

  /// `我的`
  String get mine {
    return Intl.message('我的', name: 'mine', desc: '', args: []);
  }

  /// `切换语言`
  String get changeLanguage {
    return Intl.message('切换语言', name: 'changeLanguage', desc: '', args: []);
  }

  /// `切换主题`
  String get changeTheme {
    return Intl.message('切换主题', name: 'changeTheme', desc: '', args: []);
  }

  /// `通知公告`
  String get notifications {
    return Intl.message('通知公告', name: 'notifications', desc: '', args: []);
  }

  /// `联系我们`
  String get contactUs {
    return Intl.message('联系我们', name: 'contactUs', desc: '', args: []);
  }

  /// `中文`
  String get zh {
    return Intl.message('中文', name: 'zh', desc: '', args: []);
  }

  /// `English`
  String get en {
    return Intl.message('English', name: 'en', desc: '', args: []);
  }

  /// `Indonesia`
  String get id {
    return Intl.message('Indonesia', name: 'id', desc: '', args: []);
  }

  /// `首页`
  String get homePage {
    return Intl.message('首页', name: 'homePage', desc: '', args: []);
  }

  /// `发现隐患`
  String get dangerPage {
    return Intl.message('发现隐患', name: 'dangerPage', desc: '', args: []);
  }

  /// `工具箱`
  String get toolPage {
    return Intl.message('工具箱', name: 'toolPage', desc: '', args: []);
  }

  /// `我的`
  String get minePage {
    return Intl.message('我的', name: 'minePage', desc: '', args: []);
  }

  /// `在线报修`
  String get repairOnline {
    return Intl.message('在线报修', name: 'repairOnline', desc: '', args: []);
  }

  /// `我的报修`
  String get myRepair {
    return Intl.message('我的报修', name: 'myRepair', desc: '', args: []);
  }

  /// `报修订单`
  String get repairOrder {
    return Intl.message('报修订单', name: 'repairOrder', desc: '', args: []);
  }

  /// `公司新闻`
  String get news {
    return Intl.message('公司新闻', name: 'news', desc: '', args: []);
  }

  /// `公告`
  String get notice {
    return Intl.message('公告', name: 'notice', desc: '', args: []);
  }

  /// `暂无数据`
  String get noData {
    return Intl.message('暂无数据', name: 'noData', desc: '', args: []);
  }

  /// `已读`
  String get read {
    return Intl.message('已读', name: 'read', desc: '', args: []);
  }

  /// `未读`
  String get unread {
    return Intl.message('未读', name: 'unread', desc: '', args: []);
  }

  /// `资讯类`
  String get information {
    return Intl.message('资讯类', name: 'information', desc: '', args: []);
  }

  /// `报修服务`
  String get repairService {
    return Intl.message('报修服务', name: 'repairService', desc: '', args: []);
  }

  /// `旧密码`
  String get oldPassword {
    return Intl.message('旧密码', name: 'oldPassword', desc: '', args: []);
  }

  /// `新密码`
  String get newPassword {
    return Intl.message('新密码', name: 'newPassword', desc: '', args: []);
  }

  /// `密码`
  String get password {
    return Intl.message('密码', name: 'password', desc: '', args: []);
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
    return Intl.message('密码不能为空', name: 'passwordNotEmpty', desc: '', args: []);
  }

  /// `两次密码不一致`
  String get passwordNotSame {
    return Intl.message('两次密码不一致', name: 'passwordNotSame', desc: '', args: []);
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
    return Intl.message('提交', name: 'submit', desc: '', args: []);
  }

  /// `男`
  String get man {
    return Intl.message('男', name: 'man', desc: '', args: []);
  }

  /// `女`
  String get woman {
    return Intl.message('女', name: 'woman', desc: '', args: []);
  }

  /// `保密`
  String get secret {
    return Intl.message('保密', name: 'secret', desc: '', args: []);
  }

  /// `修改成功`
  String get changeSuccess {
    return Intl.message('修改成功', name: 'changeSuccess', desc: '', args: []);
  }

  /// `点击更换头像`
  String get changeAvatar {
    return Intl.message('点击更换头像', name: 'changeAvatar', desc: '', args: []);
  }

  /// `姓名`
  String get name {
    return Intl.message('姓名', name: 'name', desc: '', args: []);
  }

  /// `工号`
  String get workNo {
    return Intl.message('工号', name: 'workNo', desc: '', args: []);
  }

  /// `身份证号`
  String get idCard {
    return Intl.message('身份证号', name: 'idCard', desc: '', args: []);
  }

  /// `手机号`
  String get phone {
    return Intl.message('手机号', name: 'phone', desc: '', args: []);
  }

  /// `邮箱`
  String get email {
    return Intl.message('邮箱', name: 'email', desc: '', args: []);
  }

  /// `性别`
  String get gender {
    return Intl.message('性别', name: 'gender', desc: '', args: []);
  }

  /// `生日`
  String get birthday {
    return Intl.message('生日', name: 'birthday', desc: '', args: []);
  }

  /// `地址`
  String get address {
    return Intl.message('地址', name: 'address', desc: '', args: []);
  }

  /// `更新`
  String get update {
    return Intl.message('更新', name: 'update', desc: '', args: []);
  }

  /// `部门`
  String get dept {
    return Intl.message('部门', name: 'dept', desc: '', args: []);
  }

  /// `取消`
  String get cancel {
    return Intl.message('取消', name: 'cancel', desc: '', args: []);
  }

  /// `确认`
  String get confirm {
    return Intl.message('确认', name: 'confirm', desc: '', args: []);
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
    return Intl.message('报修地址', name: 'repairAddress', desc: '', args: []);
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
    return Intl.message('报修区域', name: 'repairArea', desc: '', args: []);
  }

  /// `报修图片`
  String get repairImages {
    return Intl.message('报修图片', name: 'repairImages', desc: '', args: []);
  }

  /// `报修内容`
  String get repairContent {
    return Intl.message('报修内容', name: 'repairContent', desc: '', args: []);
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
    return Intl.message('报修人', name: 'repairPerson', desc: '', args: []);
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
    return Intl.message('联系电话', name: 'contactPhone', desc: '', args: []);
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
    return Intl.message('上传图片', name: 'uploadImages', desc: '', args: []);
  }

  /// `拖动删除图片`
  String get dragRemoveImage {
    return Intl.message('拖动删除图片', name: 'dragRemoveImage', desc: '', args: []);
  }

  /// `图片上传中...`
  String get imageUploading {
    return Intl.message('图片上传中...', name: 'imageUploading', desc: '', args: []);
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
    return Intl.message('拖动此处删除', name: 'dragHereToRemove', desc: '', args: []);
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
    return Intl.message('提示', name: 'tip', desc: '', args: []);
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
    return Intl.message('报修时间', name: 'repairSubmitTime', desc: '', args: []);
  }

  /// `维修时间`
  String get repairTime {
    return Intl.message('维修时间', name: 'repairTime', desc: '', args: []);
  }

  /// `维修说明`
  String get repairDirection {
    return Intl.message('维修说明', name: 'repairDirection', desc: '', args: []);
  }

  /// `维修结果`
  String get repairResult {
    return Intl.message('维修结果', name: 'repairResult', desc: '', args: []);
  }

  /// `已修复`
  String get fixed {
    return Intl.message('已修复', name: 'fixed', desc: '', args: []);
  }

  /// `未修复`
  String get unfixed {
    return Intl.message('未修复', name: 'unfixed', desc: '', args: []);
  }

  /// `满意度`
  String get satisfaction {
    return Intl.message('满意度', name: 'satisfaction', desc: '', args: []);
  }

  /// `用户反馈`
  String get userFeedback {
    return Intl.message('用户反馈', name: 'userFeedback', desc: '', args: []);
  }

  /// `请填写未修复原因`
  String get unfixedReason {
    return Intl.message('请填写未修复原因', name: 'unfixedReason', desc: '', args: []);
  }

  /// `请登录您的帐号`
  String get needLogin {
    return Intl.message('请登录您的帐号', name: 'needLogin', desc: '', args: []);
  }

  /// `全部`
  String get all {
    return Intl.message('全部', name: 'all', desc: '', args: []);
  }

  /// `待维修`
  String get pending {
    return Intl.message('待维修', name: 'pending', desc: '', args: []);
  }

  /// `已维修`
  String get repaired {
    return Intl.message('已维修', name: 'repaired', desc: '', args: []);
  }

  /// `待返修`
  String get pendingRepair {
    return Intl.message('待返修', name: 'pendingRepair', desc: '', args: []);
  }

  /// `已完结`
  String get completed {
    return Intl.message('已完结', name: 'completed', desc: '', args: []);
  }

  /// `待返修`
  String get returnPending {
    return Intl.message('待返修', name: 'returnPending', desc: '', args: []);
  }

  /// `报修详情`
  String get repairDetail {
    return Intl.message('报修详情', name: 'repairDetail', desc: '', args: []);
  }

  /// `未知状态`
  String get unknownStatus {
    return Intl.message('未知状态', name: 'unknownStatus', desc: '', args: []);
  }

  /// `删除`
  String get deleteRepair {
    return Intl.message('删除', name: 'deleteRepair', desc: '', args: []);
  }

  /// `评价`
  String get evaluate {
    return Intl.message('评价', name: 'evaluate', desc: '', args: []);
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

  /// `您的维修单已处理`
  String get repairOrderProcessed {
    return Intl.message(
      '您的维修单已处理',
      name: 'repairOrderProcessed',
      desc: '',
      args: [],
    );
  }

  /// `维修单处理`
  String get repairOrderProcess {
    return Intl.message(
      '维修单处理',
      name: 'repairOrderProcess',
      desc: '',
      args: [],
    );
  }

  /// `请选择维修类型`
  String get selectRepairType {
    return Intl.message(
      '请选择维修类型',
      name: 'selectRepairType',
      desc: '',
      args: [],
    );
  }

  /// `请选择维修时间`
  String get selectRepairTime {
    return Intl.message(
      '请选择维修时间',
      name: 'selectRepairTime',
      desc: '',
      args: [],
    );
  }

  /// `请填写维修说明`
  String get repairDescription {
    return Intl.message(
      '请填写维修说明',
      name: 'repairDescription',
      desc: '',
      args: [],
    );
  }

  /// `报修房间号`
  String get repairRoomNo {
    return Intl.message('报修房间号', name: 'repairRoomNo', desc: '', args: []);
  }

  /// `联系电话`
  String get repairTel {
    return Intl.message('联系电话', name: 'repairTel', desc: '', args: []);
  }

  /// `报修信息`
  String get repairMessage {
    return Intl.message('报修信息', name: 'repairMessage', desc: '', args: []);
  }

  /// `返修信息`
  String get repairFeedback {
    return Intl.message('返修信息', name: 'repairFeedback', desc: '', args: []);
  }

  /// `报修图片`
  String get repairImage {
    return Intl.message('报修图片', name: 'repairImage', desc: '', args: []);
  }

  /// `维修类型`
  String get repairType {
    return Intl.message('维修类型', name: 'repairType', desc: '', args: []);
  }

  /// `维修状态`
  String get repairStatus {
    return Intl.message('维修状态', name: 'repairStatus', desc: '', args: []);
  }

  /// `维修订单管理`
  String get repairOrderManagement {
    return Intl.message(
      '维修订单管理',
      name: 'repairOrderManagement',
      desc: '',
      args: [],
    );
  }

  /// `处理时间`
  String get updateTime {
    return Intl.message('处理时间', name: 'updateTime', desc: '', args: []);
  }

  /// `处理结果`
  String get repairNote {
    return Intl.message('处理结果', name: 'repairNote', desc: '', args: []);
  }

  /// `处理`
  String get process {
    return Intl.message('处理', name: 'process', desc: '', args: []);
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
    return Intl.message('检查更新', name: 'checkUpdate', desc: '', args: []);
  }

  /// `当前版本号`
  String get appVersion {
    return Intl.message('当前版本号', name: 'appVersion', desc: '', args: []);
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
    return Intl.message('地址管理', name: 'addressManagement', desc: '', args: []);
  }

  /// `服务指南`
  String get serviceGuide {
    return Intl.message('服务指南', name: 'serviceGuide', desc: '', args: []);
  }

  /// `公司动态`
  String get companyNews {
    return Intl.message('公司动态', name: 'companyNews', desc: '', args: []);
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
    return Intl.message('点击重试', name: 'clickRetry', desc: '', args: []);
  }

  /// `更多功能`
  String get moreFunction {
    return Intl.message('更多功能', name: 'moreFunction', desc: '', args: []);
  }

  /// `我的地址`
  String get myAddress {
    return Intl.message('我的地址', name: 'myAddress', desc: '', args: []);
  }

  /// `我的反馈`
  String get myFeedback {
    return Intl.message('我的反馈', name: 'myFeedback', desc: '', args: []);
  }

  /// `立即更新`
  String get updateNow {
    return Intl.message('立即更新', name: 'updateNow', desc: '', args: []);
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
    return Intl.message('在线订餐', name: 'onlineDining', desc: '', args: []);
  }

  /// `我的订单`
  String get myOrder {
    return Intl.message('我的订单', name: 'myOrder', desc: '', args: []);
  }

  /// `月销`
  String get monthlySales {
    return Intl.message('月销', name: 'monthlySales', desc: '', args: []);
  }

  /// `消费记录`
  String get cardBill {
    return Intl.message('消费记录', name: 'cardBill', desc: '', args: []);
  }

  /// `开始日期`
  String get startDate {
    return Intl.message('开始日期', name: 'startDate', desc: '', args: []);
  }

  /// `结束日期`
  String get endDate {
    return Intl.message('结束日期', name: 'endDate', desc: '', args: []);
  }

  /// `至`
  String get to {
    return Intl.message('至', name: 'to', desc: '', args: []);
  }

  /// `查询`
  String get search {
    return Intl.message('查询', name: 'search', desc: '', args: []);
  }

  /// `支出`
  String get expenditure {
    return Intl.message('支出', name: 'expenditure', desc: '', args: []);
  }

  /// `卡状态`
  String get cardStatus {
    return Intl.message('卡状态', name: 'cardStatus', desc: '', args: []);
  }

  /// `卡类型`
  String get cardType {
    return Intl.message('卡类型', name: 'cardType', desc: '', args: []);
  }

  /// `卡号`
  String get cardNumber {
    return Intl.message('卡号', name: 'cardNumber', desc: '', args: []);
  }

  /// `卡余额`
  String get cardBalance {
    return Intl.message('卡余额', name: 'cardBalance', desc: '', args: []);
  }

  /// `卡密码`
  String get cardPassword {
    return Intl.message('卡密码', name: 'cardPassword', desc: '', args: []);
  }

  /// `卡信息`
  String get cardInfo {
    return Intl.message('卡信息', name: 'cardInfo', desc: '', args: []);
  }

  /// `销卡`
  String get cardDelete {
    return Intl.message('销卡', name: 'cardDelete', desc: '', args: []);
  }

  /// `解挂`
  String get cardLock {
    return Intl.message('解挂', name: 'cardLock', desc: '', args: []);
  }

  /// `挂失`
  String get cardLoss {
    return Intl.message('挂失', name: 'cardLoss', desc: '', args: []);
  }

  /// `有效`
  String get cardValid {
    return Intl.message('有效', name: 'cardValid', desc: '', args: []);
  }

  /// `预销卡`
  String get cardPreDelete {
    return Intl.message('预销卡', name: 'cardPreDelete', desc: '', args: []);
  }

  /// `冻结`
  String get cardFreeze {
    return Intl.message('冻结', name: 'cardFreeze', desc: '', args: []);
  }

  /// `姓名`
  String get cardName {
    return Intl.message('姓名', name: 'cardName', desc: '', args: []);
  }

  /// `部门`
  String get cardDep {
    return Intl.message('部门', name: 'cardDep', desc: '', args: []);
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
    return Intl.message('挂失成功', name: 'cardLossSuccess', desc: '', args: []);
  }

  /// `解锁成功`
  String get cardLockSuccess {
    return Intl.message('解锁成功', name: 'cardLockSuccess', desc: '', args: []);
  }

  /// `重置密码`
  String get resetPassword {
    return Intl.message('重置密码', name: 'resetPassword', desc: '', args: []);
  }

  /// `请输入您的工号`
  String get inputWorkNumber {
    return Intl.message('请输入您的工号', name: 'inputWorkNumber', desc: '', args: []);
  }

  /// `请输入您的身份证号`
  String get inputIdCard {
    return Intl.message('请输入您的身份证号', name: 'inputIdCard', desc: '', args: []);
  }

  /// `请输入新密码`
  String get inputNewPassword {
    return Intl.message('请输入新密码', name: 'inputNewPassword', desc: '', args: []);
  }

  /// `请输入旧密码`
  String get inputOldPassword {
    return Intl.message('请输入旧密码', name: 'inputOldPassword', desc: '', args: []);
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
    return Intl.message('支付二维码', name: 'paymentQRCode', desc: '', args: []);
  }

  /// `合计`
  String get total {
    return Intl.message('合计', name: 'total', desc: '', args: []);
  }

  /// `去结算`
  String get checkout {
    return Intl.message('去结算', name: 'checkout', desc: '', args: []);
  }

  /// `堂食`
  String get diningIn {
    return Intl.message('堂食', name: 'diningIn', desc: '', args: []);
  }

  /// `配送`
  String get delivery {
    return Intl.message('配送', name: 'delivery', desc: '', args: []);
  }

  /// `打包`
  String get takeout {
    return Intl.message('打包', name: 'takeout', desc: '', args: []);
  }

  /// `点餐`
  String get order {
    return Intl.message('点餐', name: 'order', desc: '', args: []);
  }

  /// `评价`
  String get evaluation {
    return Intl.message('评价', name: 'evaluation', desc: '', args: []);
  }

  /// `餐厅`
  String get restaurant {
    return Intl.message('餐厅', name: 'restaurant', desc: '', args: []);
  }

  /// `数据加载中...`
  String get loading {
    return Intl.message('数据加载中...', name: 'loading', desc: '', args: []);
  }

  /// `已经到底啦`
  String get endOfList {
    return Intl.message('已经到底啦', name: 'endOfList', desc: '', args: []);
  }

  /// `剩余`
  String get remaining {
    return Intl.message('剩余', name: 'remaining', desc: '', args: []);
  }

  /// `购物车`
  String get cart {
    return Intl.message('购物车', name: 'cart', desc: '', args: []);
  }

  /// `清空购物车`
  String get clearCart {
    return Intl.message('清空购物车', name: 'clearCart', desc: '', args: []);
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
    return Intl.message('清空', name: 'clear', desc: '', args: []);
  }

  /// `购物车是空的`
  String get cartEmpty {
    return Intl.message('购物车是空的', name: 'cartEmpty', desc: '', args: []);
  }

  /// `点餐时间`
  String get diningTime {
    return Intl.message('点餐时间', name: 'diningTime', desc: '', args: []);
  }

  /// `扫描二维码`
  String get scanQRCode {
    return Intl.message('扫描二维码', name: 'scanQRCode', desc: '', args: []);
  }

  /// `餐饮服务`
  String get diningService {
    return Intl.message('餐饮服务', name: 'diningService', desc: '', args: []);
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
    return Intl.message('支付成功', name: 'paySuccess', desc: '', args: []);
  }

  /// `支付失败`
  String get payFail {
    return Intl.message('支付失败', name: 'payFail', desc: '', args: []);
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
    return Intl.message('确认修改', name: 'confirmModify', desc: '', args: []);
  }

  /// `密码由6位数字组成`
  String get passwordTips {
    return Intl.message('密码由6位数字组成', name: 'passwordTips', desc: '', args: []);
  }

  /// `提交订单`
  String get submitOrder {
    return Intl.message('提交订单', name: 'submitOrder', desc: '', args: []);
  }

  /// `营业时间`
  String get businessHours {
    return Intl.message('营业时间', name: 'businessHours', desc: '', args: []);
  }

  /// `商品信息`
  String get goodsInfo {
    return Intl.message('商品信息', name: 'goodsInfo', desc: '', args: []);
  }

  /// `取餐方式`
  String get pickupType {
    return Intl.message('取餐方式', name: 'pickupType', desc: '', args: []);
  }

  /// `地址信息`
  String get addressInfo {
    return Intl.message('地址信息', name: 'addressInfo', desc: '', args: []);
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
    return Intl.message('选择收货地址', name: 'selectAddress', desc: '', args: []);
  }

  /// `配送时间`
  String get deliveryTime {
    return Intl.message('配送时间', name: 'deliveryTime', desc: '', args: []);
  }

  /// `配送费`
  String get deliveryFee {
    return Intl.message('配送费', name: 'deliveryFee', desc: '', args: []);
  }

  /// `个人信息`
  String get personalInfo {
    return Intl.message('个人信息', name: 'personalInfo', desc: '', args: []);
  }

  /// `工号`
  String get employeeNumber {
    return Intl.message('工号', name: 'employeeNumber', desc: '', args: []);
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
    return Intl.message('取餐限定时间', name: 'pickupLimitTime', desc: '', args: []);
  }

  /// `备注`
  String get remark {
    return Intl.message('备注', name: 'remark', desc: '', args: []);
  }

  /// `确认提交`
  String get confirmSubmit {
    return Intl.message('确认提交', name: 'confirmSubmit', desc: '', args: []);
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
    return Intl.message('提交成功', name: 'submitSuccess', desc: '', args: []);
  }

  /// `提交失败`
  String get submitFail {
    return Intl.message('提交失败', name: 'submitFail', desc: '', args: []);
  }

  /// `搜索我的订单`
  String get searchMyOrder {
    return Intl.message('搜索我的订单', name: 'searchMyOrder', desc: '', args: []);
  }

  /// `件`
  String get items {
    return Intl.message('件', name: 'items', desc: '', args: []);
  }

  /// `删除订单`
  String get deleteOrder {
    return Intl.message('删除订单', name: 'deleteOrder', desc: '', args: []);
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
    return Intl.message('订单详情', name: 'orderDetail', desc: '', args: []);
  }

  /// `订单号`
  String get orderNo {
    return Intl.message('订单号', name: 'orderNo', desc: '', args: []);
  }

  /// `订单信息`
  String get orderInfo {
    return Intl.message('订单信息', name: 'orderInfo', desc: '', args: []);
  }

  /// `取餐时间`
  String get pickupTime {
    return Intl.message('取餐时间', name: 'pickupTime', desc: '', args: []);
  }

  /// `下单时间`
  String get orderTime {
    return Intl.message('下单时间', name: 'orderTime', desc: '', args: []);
  }

  /// `商品总额`
  String get goodsTotal {
    return Intl.message('商品总额', name: 'goodsTotal', desc: '', args: []);
  }

  /// `实付金额`
  String get actualPayment {
    return Intl.message('实付金额', name: 'actualPayment', desc: '', args: []);
  }

  /// `我想吃`
  String get iWantToEat {
    return Intl.message('我想吃', name: 'iWantToEat', desc: '', args: []);
  }

  /// `菜品建议`
  String get dishSuggestion {
    return Intl.message('菜品建议', name: 'dishSuggestion', desc: '', args: []);
  }

  /// `菜名`
  String get dishName {
    return Intl.message('菜名', name: 'dishName', desc: '', args: []);
  }

  /// `菜的做法`
  String get dishMethod {
    return Intl.message('菜的做法', name: 'dishMethod', desc: '', args: []);
  }

  /// `留言反馈`
  String get feedback {
    return Intl.message('留言反馈', name: 'feedback', desc: '', args: []);
  }

  /// `留言标题`
  String get feedbackTitle {
    return Intl.message('留言标题', name: 'feedbackTitle', desc: '', args: []);
  }

  /// `留言内容`
  String get feedbackContent {
    return Intl.message('留言内容', name: 'feedbackContent', desc: '', args: []);
  }

  /// `新增地址`
  String get addAddress {
    return Intl.message('新增地址', name: 'addAddress', desc: '', args: []);
  }

  /// `修改地址`
  String get modifyAddress {
    return Intl.message('修改地址', name: 'modifyAddress', desc: '', args: []);
  }

  /// `联系人`
  String get contactPerson {
    return Intl.message('联系人', name: 'contactPerson', desc: '', args: []);
  }

  /// `是否默认`
  String get isDefault {
    return Intl.message('是否默认', name: 'isDefault', desc: '', args: []);
  }

  /// `默认`
  String get defaultValue {
    return Intl.message('默认', name: 'defaultValue', desc: '', args: []);
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
    return Intl.message('保存地址失败', name: 'saveAddressFail', desc: '', args: []);
  }

  /// `保存地址`
  String get saveAddress {
    return Intl.message('保存地址', name: 'saveAddress', desc: '', args: []);
  }

  /// `管理`
  String get manage {
    return Intl.message('管理', name: 'manage', desc: '', args: []);
  }

  /// `退出管理`
  String get exitManage {
    return Intl.message('退出管理', name: 'exitManage', desc: '', args: []);
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
    return Intl.message('确定删除地址吗？', name: 'deleteAddress', desc: '', args: []);
  }

  /// `删除`
  String get delete {
    return Intl.message('删除', name: 'delete', desc: '', args: []);
  }

  /// `拍摄`
  String get takePhoto {
    return Intl.message('拍摄', name: 'takePhoto', desc: '', args: []);
  }

  /// `相册`
  String get photoAlbum {
    return Intl.message('相册', name: 'photoAlbum', desc: '', args: []);
  }

  /// `宣传片`
  String get promo {
    return Intl.message('宣传片', name: 'promo', desc: '', args: []);
  }

  /// `宣传片列表`
  String get promoList {
    return Intl.message('宣传片列表', name: 'promoList', desc: '', args: []);
  }

  /// `宣传片详情`
  String get promoDetail {
    return Intl.message('宣传片详情', name: 'promoDetail', desc: '', args: []);
  }

  /// `小K拾光`
  String get kTimeList {
    return Intl.message('小K拾光', name: 'kTimeList', desc: '', args: []);
  }

  /// `小K拾光详情`
  String get kTimeDetail {
    return Intl.message('小K拾光详情', name: 'kTimeDetail', desc: '', args: []);
  }

  /// `纬达贝月刊`
  String get monthly {
    return Intl.message('纬达贝月刊', name: 'monthly', desc: '', args: []);
  }

  /// `我的流程`
  String get myProcess {
    return Intl.message('我的流程', name: 'myProcess', desc: '', args: []);
  }

  /// `查看配送信息`
  String get deliveryInfo {
    return Intl.message('查看配送信息', name: 'deliveryInfo', desc: '', args: []);
  }

  /// `配送中`
  String get delivering {
    return Intl.message('配送中', name: 'delivering', desc: '', args: []);
  }

  /// `已送达`
  String get delivered {
    return Intl.message('已送达', name: 'delivered', desc: '', args: []);
  }

  /// `已收货`
  String get received {
    return Intl.message('已收货', name: 'received', desc: '', args: []);
  }

  /// `配送异常`
  String get exception {
    return Intl.message('配送异常', name: 'exception', desc: '', args: []);
  }

  /// `订单状态`
  String get orderStatus {
    return Intl.message('订单状态', name: 'orderStatus', desc: '', args: []);
  }

  /// `配送地址`
  String get deliveryAddress {
    return Intl.message('配送地址', name: 'deliveryAddress', desc: '', args: []);
  }

  /// `配送电话`
  String get deliveryPhone {
    return Intl.message('配送电话', name: 'deliveryPhone', desc: '', args: []);
  }

  /// `配送员`
  String get deliveryName {
    return Intl.message('配送员', name: 'deliveryName', desc: '', args: []);
  }

  /// `接单成功`
  String get acceptOrderSuccess {
    return Intl.message('接单成功', name: 'acceptOrderSuccess', desc: '', args: []);
  }

  /// `接单失败`
  String get acceptOrderFailed {
    return Intl.message('接单失败', name: 'acceptOrderFailed', desc: '', args: []);
  }

  /// `接单`
  String get acceptOrder {
    return Intl.message('接单', name: 'acceptOrder', desc: '', args: []);
  }

  /// `接单时间`
  String get acceptTime {
    return Intl.message('接单时间', name: 'acceptTime', desc: '', args: []);
  }

  /// `相机权限被永久拒绝，打开设置页面`
  String get cameraPermissionDenied {
    return Intl.message(
      '相机权限被永久拒绝，打开设置页面',
      name: 'cameraPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `请先接单`
  String get pleaseAcceptOrder {
    return Intl.message('请先接单', name: 'pleaseAcceptOrder', desc: '', args: []);
  }

  /// `请先取消订单`
  String get pleaseCancelOrder {
    return Intl.message(
      '请先取消订单',
      name: 'pleaseCancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `送达成功`
  String get deliverSuccess {
    return Intl.message('送达成功', name: 'deliverSuccess', desc: '', args: []);
  }

  /// `送达失败`
  String get deliverFailed {
    return Intl.message('送达失败', name: 'deliverFailed', desc: '', args: []);
  }

  /// `送达`
  String get deliver {
    return Intl.message('送达', name: 'deliver', desc: '', args: []);
  }

  /// `送达时间`
  String get deliverTime {
    return Intl.message('送达时间', name: 'deliverTime', desc: '', args: []);
  }

  /// `您的订单已送达`
  String get deliverSuccessTips {
    return Intl.message(
      '您的订单已送达',
      name: 'deliverSuccessTips',
      desc: '',
      args: [],
    );
  }

  /// `确认取消送达该订单吗？`
  String get deliverFailedTips {
    return Intl.message(
      '确认取消送达该订单吗？',
      name: 'deliverFailedTips',
      desc: '',
      args: [],
    );
  }

  /// `在线接单`
  String get onlineDelivery {
    return Intl.message('在线接单', name: 'onlineDelivery', desc: '', args: []);
  }

  /// `停止定位`
  String get stopLocation {
    return Intl.message('停止定位', name: 'stopLocation', desc: '', args: []);
  }

  /// `开始定位`
  String get startLocation {
    return Intl.message('开始定位', name: 'startLocation', desc: '', args: []);
  }

  /// `暂无订单`
  String get noOrder {
    return Intl.message('暂无订单', name: 'noOrder', desc: '', args: []);
  }

  /// `取消订单`
  String get cancelOrder {
    return Intl.message('取消订单', name: 'cancelOrder', desc: '', args: []);
  }

  /// `取消订单成功`
  String get cancelOrderSuccess {
    return Intl.message(
      '取消订单成功',
      name: 'cancelOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `取消订单失败`
  String get cancelOrderFailed {
    return Intl.message(
      '取消订单失败',
      name: 'cancelOrderFailed',
      desc: '',
      args: [],
    );
  }

  /// `查看订单`
  String get viewOrder {
    return Intl.message('查看订单', name: 'viewOrder', desc: '', args: []);
  }

  /// `配送订单详情`
  String get deliveryOrderDetail {
    return Intl.message(
      '配送订单详情',
      name: 'deliveryOrderDetail',
      desc: '',
      args: [],
    );
  }

  /// `联系Ta`
  String get contact {
    return Intl.message('联系Ta', name: 'contact', desc: '', args: []);
  }

  /// `配送订单`
  String get deliveryOrder {
    return Intl.message('配送订单', name: 'deliveryOrder', desc: '', args: []);
  }

  /// `配送单号`
  String get deliveryOrderNo {
    return Intl.message('配送单号', name: 'deliveryOrderNo', desc: '', args: []);
  }

  /// `操作人`
  String get operator {
    return Intl.message('操作人', name: 'operator', desc: '', args: []);
  }

  /// `待接单`
  String get pendingOrder {
    return Intl.message('待接单', name: 'pendingOrder', desc: '', args: []);
  }

  /// `下单时间`
  String get createTime {
    return Intl.message('下单时间', name: 'createTime', desc: '', args: []);
  }

  /// `确认收货`
  String get confirmDelivery {
    return Intl.message('确认收货', name: 'confirmDelivery', desc: '', args: []);
  }

  /// `确认收货后，订单将无法修改，请确认是否收货？`
  String get confirmDeliveryContent {
    return Intl.message(
      '确认收货后，订单将无法修改，请确认是否收货？',
      name: 'confirmDeliveryContent',
      desc: '',
      args: [],
    );
  }

  /// `已评价`
  String get evaluated {
    return Intl.message('已评价', name: 'evaluated', desc: '', args: []);
  }

  /// `在线申请`
  String get onlineApply {
    return Intl.message('在线申请', name: 'onlineApply', desc: '', args: []);
  }

  /// `流程说明`
  String get processDescription {
    return Intl.message('流程说明', name: 'processDescription', desc: '', args: []);
  }

  /// `注意事项`
  String get attention {
    return Intl.message('注意事项', name: 'attention', desc: '', args: []);
  }

  /// `住宿流程`
  String get accommodationProcess {
    return Intl.message(
      '住宿流程',
      name: 'accommodationProcess',
      desc: '',
      args: [],
    );
  }

  /// `输入的两次密码不同`
  String get inputDifferentPassword {
    return Intl.message(
      '输入的两次密码不同',
      name: 'inputDifferentPassword',
      desc: '',
      args: [],
    );
  }

  /// `忘记密码？`
  String get forgetPassword {
    return Intl.message('忘记密码？', name: 'forgetPassword', desc: '', args: []);
  }

  /// `记住密码`
  String get rememberPassword {
    return Intl.message('记住密码', name: 'rememberPassword', desc: '', args: []);
  }

  /// `内容待更新，敬请期待...`
  String get contentUpdating {
    return Intl.message(
      '内容待更新，敬请期待...',
      name: 'contentUpdating',
      desc: '',
      args: [],
    );
  }

  /// `附件`
  String get attachment {
    return Intl.message('附件', name: 'attachment', desc: '', args: []);
  }

  /// `身份证号可用于找回密码，请尽快绑定！`
  String get idCardTips {
    return Intl.message(
      '身份证号可用于找回密码，请尽快绑定！',
      name: 'idCardTips',
      desc: '',
      args: [],
    );
  }

  /// `为了您的资金安全，首次登录请您尽快修改密码！`
  String get firstLoginTips {
    return Intl.message(
      '为了您的资金安全，首次登录请您尽快修改密码！',
      name: 'firstLoginTips',
      desc: '',
      args: [],
    );
  }

  /// `已查看`
  String get viewed {
    return Intl.message('已查看', name: 'viewed', desc: '', args: []);
  }

  /// `异常原因`
  String get deliveryException {
    return Intl.message('异常原因', name: 'deliveryException', desc: '', args: []);
  }

  /// `没有更多数据`
  String get noMoreData {
    return Intl.message('没有更多数据', name: 'noMoreData', desc: '', args: []);
  }

  /// `上拉加载更多`
  String get pullUpLoadMore {
    return Intl.message('上拉加载更多', name: 'pullUpLoadMore', desc: '', args: []);
  }

  /// `加载失败`
  String get loadFailed {
    return Intl.message('加载失败', name: 'loadFailed', desc: '', args: []);
  }

  /// `释放加载更多`
  String get releaseLoadMore {
    return Intl.message('释放加载更多', name: 'releaseLoadMore', desc: '', args: []);
  }

  /// `刷新`
  String get refresh {
    return Intl.message('刷新', name: 'refresh', desc: '', args: []);
  }

  /// `刷新完成`
  String get refreshComplete {
    return Intl.message('刷新完成', name: 'refreshComplete', desc: '', args: []);
  }

  /// `刷新失败`
  String get refreshFailed {
    return Intl.message('刷新失败', name: 'refreshFailed', desc: '', args: []);
  }

  /// `刷新中...`
  String get refreshing {
    return Intl.message('刷新中...', name: 'refreshing', desc: '', args: []);
  }

  /// `点赞成功`
  String get likeSuccess {
    return Intl.message('点赞成功', name: 'likeSuccess', desc: '', args: []);
  }

  /// `点赞失败`
  String get likeFailed {
    return Intl.message('点赞失败', name: 'likeFailed', desc: '', args: []);
  }

  /// `点赞`
  String get like {
    return Intl.message('点赞', name: 'like', desc: '', args: []);
  }

  /// `取消点赞`
  String get unlike {
    return Intl.message('取消点赞', name: 'unlike', desc: '', args: []);
  }

  /// `超出库存`
  String get exceedStock {
    return Intl.message('超出库存', name: 'exceedStock', desc: '', args: []);
  }

  /// `人脸采集`
  String get faceCollection {
    return Intl.message('人脸采集', name: 'faceCollection', desc: '', args: []);
  }

  /// `请上传人脸照片`
  String get uploadFacePhoto {
    return Intl.message('请上传人脸照片', name: 'uploadFacePhoto', desc: '', args: []);
  }

  /// `消费卡人脸识别可用于园区内刷脸消费。`
  String get faceCollectionTips {
    return Intl.message(
      '消费卡人脸识别可用于园区内刷脸消费。',
      name: 'faceCollectionTips',
      desc: '',
      args: [],
    );
  }

  /// `采集标准要求说明`
  String get faceCollectionTipsTitle {
    return Intl.message(
      '采集标准要求说明',
      name: 'faceCollectionTipsTitle',
      desc: '',
      args: [],
    );
  }

  /// `1. 人脸正面免冠照，露出眉毛和眼睛`
  String get faceCollectionTips1 {
    return Intl.message(
      '1. 人脸正面免冠照，露出眉毛和眼睛',
      name: 'faceCollectionTips1',
      desc: '',
      args: [],
    );
  }

  /// `2. 照片白底、无逆光、无ps、无过渡美颜处理`
  String get faceCollectionTips2 {
    return Intl.message(
      '2. 照片白底、无逆光、无ps、无过渡美颜处理',
      name: 'faceCollectionTips2',
      desc: '',
      args: [],
    );
  }

  /// `3. 建议用高清像素手机拍摄`
  String get faceCollectionTips3 {
    return Intl.message(
      '3. 建议用高清像素手机拍摄',
      name: 'faceCollectionTips3',
      desc: '',
      args: [],
    );
  }

  /// `4. 图片大小:40k~200k`
  String get faceCollectionTips4 {
    return Intl.message(
      '4. 图片大小:40k~200k',
      name: 'faceCollectionTips4',
      desc: '',
      args: [],
    );
  }

  /// `5. 多次上传未能通过照片审核的用户，可持工卡在工作时间到卡务柜台办理`
  String get faceCollectionTips5 {
    return Intl.message(
      '5. 多次上传未能通过照片审核的用户，可持工卡在工作时间到卡务柜台办理',
      name: 'faceCollectionTips5',
      desc: '',
      args: [],
    );
  }

  /// `上传新证件照`
  String get uploadNewFacePhoto {
    return Intl.message(
      '上传新证件照',
      name: 'uploadNewFacePhoto',
      desc: '',
      args: [],
    );
  }

  /// `美食推荐`
  String get foodRecommend {
    return Intl.message('美食推荐', name: 'foodRecommend', desc: '', args: []);
  }

  /// `推荐时间`
  String get recommendTime {
    return Intl.message('推荐时间', name: 'recommendTime', desc: '', args: []);
  }

  /// `推荐理由`
  String get recommendReason {
    return Intl.message('推荐理由', name: 'recommendReason', desc: '', args: []);
  }

  /// `推荐人`
  String get recommendPerson {
    return Intl.message('推荐人', name: 'recommendPerson', desc: '', args: []);
  }

  /// `新品推荐`
  String get newProductRecommend {
    return Intl.message(
      '新品推荐',
      name: 'newProductRecommend',
      desc: '',
      args: [],
    );
  }

  /// `当前版本已是最新版本`
  String get currentVersionIsLatest {
    return Intl.message(
      '当前版本已是最新版本',
      name: 'currentVersionIsLatest',
      desc: '',
      args: [],
    );
  }

  /// `发现新版本`
  String get newVersion {
    return Intl.message('发现新版本', name: 'newVersion', desc: '', args: []);
  }

  /// `待打包`
  String get toBePacked {
    return Intl.message('待打包', name: 'toBePacked', desc: '', args: []);
  }

  /// `待配送`
  String get toBeDelivered {
    return Intl.message('待配送', name: 'toBeDelivered', desc: '', args: []);
  }

  /// `今天`
  String get today {
    return Intl.message('今天', name: 'today', desc: '', args: []);
  }

  /// `一周`
  String get oneWeek {
    return Intl.message('一周', name: 'oneWeek', desc: '', args: []);
  }

  /// `一个月`
  String get oneMonth {
    return Intl.message('一个月', name: 'oneMonth', desc: '', args: []);
  }

  /// `三个月`
  String get threeMonths {
    return Intl.message('三个月', name: 'threeMonths', desc: '', args: []);
  }

  /// `一年`
  String get oneYear {
    return Intl.message('一年', name: 'oneYear', desc: '', args: []);
  }

  /// `订单已完成`
  String get orderCompleted {
    return Intl.message('订单已完成', name: 'orderCompleted', desc: '', args: []);
  }

  /// `打包处理成功`
  String get packOrderSuccess {
    return Intl.message('打包处理成功', name: 'packOrderSuccess', desc: '', args: []);
  }

  /// `按时间选择`
  String get selectByTime {
    return Intl.message('按时间选择', name: 'selectByTime', desc: '', args: []);
  }

  /// `请输入订单编号`
  String get inputOrderNo {
    return Intl.message('请输入订单编号', name: 'inputOrderNo', desc: '', args: []);
  }

  /// `请输入订单姓名`
  String get inputOrderName {
    return Intl.message('请输入订单姓名', name: 'inputOrderName', desc: '', args: []);
  }

  /// `订单姓名`
  String get orderName {
    return Intl.message('订单姓名', name: 'orderName', desc: '', args: []);
  }

  /// `店铺工作台`
  String get shopWorkbench {
    return Intl.message('店铺工作台', name: 'shopWorkbench', desc: '', args: []);
  }

  /// `公交时刻表`
  String get busTimetable {
    return Intl.message('公交时刻表', name: 'busTimetable', desc: '', args: []);
  }

  /// `选择路线`
  String get chooseRoute {
    return Intl.message('选择路线', name: 'chooseRoute', desc: '', args: []);
  }

  /// `起点站`
  String get startStation {
    return Intl.message('起点站', name: 'startStation', desc: '', args: []);
  }

  /// `终点站`
  String get endStation {
    return Intl.message('终点站', name: 'endStation', desc: '', args: []);
  }

  /// `站点数`
  String get stationNumber {
    return Intl.message('站点数', name: 'stationNumber', desc: '', args: []);
  }

  /// `班次数`
  String get tripNumber {
    return Intl.message('班次数', name: 'tripNumber', desc: '', args: []);
  }

  /// `首班车`
  String get firstTripTime {
    return Intl.message('首班车', name: 'firstTripTime', desc: '', args: []);
  }

  /// `末班车`
  String get lastTripTime {
    return Intl.message('末班车', name: 'lastTripTime', desc: '', args: []);
  }

  /// `发车时间表`
  String get timetable {
    return Intl.message('发车时间表', name: 'timetable', desc: '', args: []);
  }

  /// `今日`
  String get busToday {
    return Intl.message('今日', name: 'busToday', desc: '', args: []);
  }

  /// `站点列表`
  String get stopList {
    return Intl.message('站点列表', name: 'stopList', desc: '', args: []);
  }

  /// `方向`
  String get direction {
    return Intl.message('方向', name: 'direction', desc: '', args: []);
  }

  /// `送达照片`
  String get deliveryPhoto {
    return Intl.message('送达照片', name: 'deliveryPhoto', desc: '', args: []);
  }

  /// `失物`
  String get lost {
    return Intl.message('失物', name: 'lost', desc: '', args: []);
  }

  /// `招领`
  String get found {
    return Intl.message('招领', name: 'found', desc: '', args: []);
  }

  /// `我的发布`
  String get myRelease {
    return Intl.message('我的发布', name: 'myRelease', desc: '', args: []);
  }

  /// `失物招领`
  String get lostAndFound {
    return Intl.message('失物招领', name: 'lostAndFound', desc: '', args: []);
  }

  /// `发布`
  String get publish {
    return Intl.message('发布', name: 'publish', desc: '', args: []);
  }

  /// `失物`
  String get lostItem {
    return Intl.message('失物', name: 'lostItem', desc: '', args: []);
  }

  /// `招领`
  String get foundItem {
    return Intl.message('招领', name: 'foundItem', desc: '', args: []);
  }

  /// `失物列表`
  String get lostItemList {
    return Intl.message('失物列表', name: 'lostItemList', desc: '', args: []);
  }

  /// `招领列表`
  String get foundItemList {
    return Intl.message('招领列表', name: 'foundItemList', desc: '', args: []);
  }

  /// `我的发布列表`
  String get myReleaseList {
    return Intl.message('我的发布列表', name: 'myReleaseList', desc: '', args: []);
  }

  /// `领取地址`
  String get receivePlace {
    return Intl.message('领取地址', name: 'receivePlace', desc: '', args: []);
  }

  /// `拾取时间`
  String get receiveTime {
    return Intl.message('拾取时间', name: 'receiveTime', desc: '', args: []);
  }

  /// `丢失时间`
  String get lostTime {
    return Intl.message('丢失时间', name: 'lostTime', desc: '', args: []);
  }

  /// `丢失地点`
  String get lostPlace {
    return Intl.message('丢失地点', name: 'lostPlace', desc: '', args: []);
  }

  /// `丢失类型`
  String get lostType {
    return Intl.message('丢失类型', name: 'lostType', desc: '', args: []);
  }

  /// `丢失状态`
  String get lostStatus {
    return Intl.message('丢失状态', name: 'lostStatus', desc: '', args: []);
  }

  /// `好心同事`
  String get goodHeartedColleague {
    return Intl.message(
      '好心同事',
      name: 'goodHeartedColleague',
      desc: '',
      args: [],
    );
  }

  /// `失物同事`
  String get lostItemColleague {
    return Intl.message('失物同事', name: 'lostItemColleague', desc: '', args: []);
  }

  /// `联系电话`
  String get contactNumber {
    return Intl.message('联系电话', name: 'contactNumber', desc: '', args: []);
  }

  /// `审核驳回`
  String get auditRejected {
    return Intl.message('审核驳回', name: 'auditRejected', desc: '', args: []);
  }

  /// `确认领取`
  String get confirmReceive {
    return Intl.message('确认领取', name: 'confirmReceive', desc: '', args: []);
  }

  /// `确定领取该物品吗？`
  String get confirmReceiveContent {
    return Intl.message(
      '确定领取该物品吗？',
      name: 'confirmReceiveContent',
      desc: '',
      args: [],
    );
  }

  /// `领取`
  String get receive {
    return Intl.message('领取', name: 'receive', desc: '', args: []);
  }

  /// `编辑`
  String get edit {
    return Intl.message('编辑', name: 'edit', desc: '', args: []);
  }

  /// `确认删除`
  String get confirmDelete {
    return Intl.message('确认删除', name: 'confirmDelete', desc: '', args: []);
  }

  /// `确定删除该条信息吗？删除后无法恢复！`
  String get confirmDeleteContent {
    return Intl.message(
      '确定删除该条信息吗？删除后无法恢复！',
      name: 'confirmDeleteContent',
      desc: '',
      args: [],
    );
  }

  /// `待审核`
  String get toBeAudited {
    return Intl.message('待审核', name: 'toBeAudited', desc: '', args: []);
  }

  /// `待领取`
  String get toBeReceived {
    return Intl.message('待领取', name: 'toBeReceived', desc: '', args: []);
  }

  /// `已领取`
  String get toBeReceivedSuccess {
    return Intl.message('已领取', name: 'toBeReceivedSuccess', desc: '', args: []);
  }

  /// `待找回`
  String get toBeFound {
    return Intl.message('待找回', name: 'toBeFound', desc: '', args: []);
  }

  /// `已驳回`
  String get toBeRejected {
    return Intl.message('已驳回', name: 'toBeRejected', desc: '', args: []);
  }

  /// `提交成功，等待审核`
  String get toBeAuditedMessage {
    return Intl.message(
      '提交成功，等待审核',
      name: 'toBeAuditedMessage',
      desc: '',
      args: [],
    );
  }

  /// `修改成功，等待审核`
  String get editToBeAuditedMessage {
    return Intl.message(
      '修改成功，等待审核',
      name: 'editToBeAuditedMessage',
      desc: '',
      args: [],
    );
  }

  /// `图片上传失败`
  String get uploadImageFailed {
    return Intl.message(
      '图片上传失败',
      name: 'uploadImageFailed',
      desc: '',
      args: [],
    );
  }

  /// `发布信息`
  String get publishInfo {
    return Intl.message('发布信息', name: 'publishInfo', desc: '', args: []);
  }

  /// `类型`
  String get type {
    return Intl.message('类型', name: 'type', desc: '', args: []);
  }

  /// `物品名称`
  String get itemName {
    return Intl.message('物品名称', name: 'itemName', desc: '', args: []);
  }

  /// `选择日期`
  String get selectDate {
    return Intl.message('选择日期', name: 'selectDate', desc: '', args: []);
  }

  /// `确认发布`
  String get confirmPublish {
    return Intl.message('确认发布', name: 'confirmPublish', desc: '', args: []);
  }

  /// `请输入{label}`
  String pleaseInput(Object label) {
    return Intl.message(
      '请输入$label',
      name: 'pleaseInput',
      desc: '',
      args: [label],
    );
  }

  /// `所在区域`
  String get region {
    return Intl.message('所在区域', name: 'region', desc: '', args: []);
  }

  /// `负责人`
  String get head {
    return Intl.message('负责人', name: 'head', desc: '', args: []);
  }

  /// `联系电话`
  String get phoneNumber {
    return Intl.message('联系电话', name: 'phoneNumber', desc: '', args: []);
  }

  /// `营业时间`
  String get publicBusinessHours {
    return Intl.message(
      '营业时间',
      name: 'publicBusinessHours',
      desc: '',
      args: [],
    );
  }

  /// `详细地址`
  String get publicAddress {
    return Intl.message('详细地址', name: 'publicAddress', desc: '', args: []);
  }

  /// `货架`
  String get pickupCode {
    return Intl.message('货架', name: 'pickupCode', desc: '', args: []);
  }

  /// `客房`
  String get coupleRoom {
    return Intl.message('客房', name: 'coupleRoom', desc: '', args: []);
  }

  /// `客房反馈`
  String get coupleRoom_feedback {
    return Intl.message(
      '客房反馈',
      name: 'coupleRoom_feedback',
      desc: '',
      args: [],
    );
  }

  /// `房间问题`
  String get coupleRoom_feedback_room {
    return Intl.message(
      '房间问题',
      name: 'coupleRoom_feedback_room',
      desc: '',
      args: [],
    );
  }

  /// `系统问题`
  String get coupleRoom_feedback_system {
    return Intl.message(
      '系统问题',
      name: 'coupleRoom_feedback_system',
      desc: '',
      args: [],
    );
  }

  /// `其他`
  String get coupleRoom_feedback_other {
    return Intl.message(
      '其他',
      name: 'coupleRoom_feedback_other',
      desc: '',
      args: [],
    );
  }

  /// `提交`
  String get coupleRoom_feedback_submit {
    return Intl.message(
      '提交',
      name: 'coupleRoom_feedback_submit',
      desc: '',
      args: [],
    );
  }

  /// `提交成功`
  String get coupleRoom_feedback_submit_success {
    return Intl.message(
      '提交成功',
      name: 'coupleRoom_feedback_submit_success',
      desc: '',
      args: [],
    );
  }

  /// `提交失败`
  String get coupleRoom_feedback_submit_fail {
    return Intl.message(
      '提交失败',
      name: 'coupleRoom_feedback_submit_fail',
      desc: '',
      args: [],
    );
  }

  /// `反馈类型`
  String get coupleRoom_feedback_type {
    return Intl.message(
      '反馈类型',
      name: 'coupleRoom_feedback_type',
      desc: '',
      args: [],
    );
  }

  /// `反馈内容`
  String get coupleRoom_feedback_content {
    return Intl.message(
      '反馈内容',
      name: 'coupleRoom_feedback_content',
      desc: '',
      args: [],
    );
  }

  /// `客房预订`
  String get coupleRoom_room_booking {
    return Intl.message(
      '客房预订',
      name: 'coupleRoom_room_booking',
      desc: '',
      args: [],
    );
  }

  /// `请输入房间号查询`
  String get coupleRoom_room_booking_search {
    return Intl.message(
      '请输入房间号查询',
      name: 'coupleRoom_room_booking_search',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get coupleRoom_room_search {
    return Intl.message(
      '搜索',
      name: 'coupleRoom_room_search',
      desc: '',
      args: [],
    );
  }

  /// `房间编号`
  String get coupleRoom_room_number {
    return Intl.message(
      '房间编号',
      name: 'coupleRoom_room_number',
      desc: '',
      args: [],
    );
  }

  /// `可预订`
  String get coupleRoom_room_available {
    return Intl.message(
      '可预订',
      name: 'coupleRoom_room_available',
      desc: '',
      args: [],
    );
  }

  /// `退房时间`
  String get coupleRoom_room_check_out_time {
    return Intl.message(
      '退房时间',
      name: 'coupleRoom_room_check_out_time',
      desc: '',
      args: [],
    );
  }

  /// `可入住时间`
  String get coupleRoom_room_check_in_time {
    return Intl.message(
      '可入住时间',
      name: 'coupleRoom_room_check_in_time',
      desc: '',
      args: [],
    );
  }

  /// `可预订天数`
  String get coupleRoom_room_available_days {
    return Intl.message(
      '可预订天数',
      name: 'coupleRoom_room_available_days',
      desc: '',
      args: [],
    );
  }

  /// `天`
  String get coupleRoom_room_days {
    return Intl.message('天', name: 'coupleRoom_room_days', desc: '', args: []);
  }

  /// `单价`
  String get coupleRoom_room_price {
    return Intl.message(
      '单价',
      name: 'coupleRoom_room_price',
      desc: '',
      args: [],
    );
  }

  /// `KRP/天`
  String get coupleRoom_room_price_unit {
    return Intl.message(
      'KRP/天',
      name: 'coupleRoom_room_price_unit',
      desc: '',
      args: [],
    );
  }

  /// `备注`
  String get coupleRoom_room_booking_remark {
    return Intl.message(
      '备注',
      name: 'coupleRoom_room_booking_remark',
      desc: '',
      args: [],
    );
  }

  /// `预订`
  String get coupleRoom_room_booking_book {
    return Intl.message(
      '预订',
      name: 'coupleRoom_room_booking_book',
      desc: '',
      args: [],
    );
  }

  /// `预订成功`
  String get coupleRoom_room_booking_book_success {
    return Intl.message(
      '预订成功',
      name: 'coupleRoom_room_booking_book_success',
      desc: '',
      args: [],
    );
  }

  /// `预订失败`
  String get coupleRoom_room_booking_book_fail {
    return Intl.message(
      '预订失败',
      name: 'coupleRoom_room_booking_book_fail',
      desc: '',
      args: [],
    );
  }

  /// `请选择入住日期（可多选，必须连续）`
  String get coupleRoom_room_booking_select_date {
    return Intl.message(
      '请选择入住日期（可多选，必须连续）',
      name: 'coupleRoom_room_booking_select_date',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get coupleRoom_room_booking_confirm {
    return Intl.message(
      '确定',
      name: 'coupleRoom_room_booking_confirm',
      desc: '',
      args: [],
    );
  }

  /// `提交`
  String get coupleRoom_room_booking_submit {
    return Intl.message(
      '提交',
      name: 'coupleRoom_room_booking_submit',
      desc: '',
      args: [],
    );
  }

  /// `提交成功`
  String get coupleRoom_room_booking_submit_success {
    return Intl.message(
      '提交成功',
      name: 'coupleRoom_room_booking_submit_success',
      desc: '',
      args: [],
    );
  }

  /// `提交失败`
  String get coupleRoom_room_booking_submit_fail {
    return Intl.message(
      '提交失败',
      name: 'coupleRoom_room_booking_submit_fail',
      desc: '',
      args: [],
    );
  }

  /// `您有新的客房预订，请及时确认订单`
  String get coupleRoom_room_booking_body {
    return Intl.message(
      '您有新的客房预订，请及时确认订单',
      name: 'coupleRoom_room_booking_body',
      desc: '',
      args: [],
    );
  }

  /// `请选择入住日期`
  String get coupleRoom_room_check_in_date {
    return Intl.message(
      '请选择入住日期',
      name: 'coupleRoom_room_check_in_date',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get coupleRoom_room_all {
    return Intl.message('全部', name: 'coupleRoom_room_all', desc: '', args: []);
  }

  /// `待审核`
  String get coupleRoom_room_pending {
    return Intl.message(
      '待审核',
      name: 'coupleRoom_room_pending',
      desc: '',
      args: [],
    );
  }

  /// `已通过`
  String get coupleRoom_room_approved {
    return Intl.message(
      '已通过',
      name: 'coupleRoom_room_approved',
      desc: '',
      args: [],
    );
  }

  /// `已拒绝`
  String get coupleRoom_room_rejected {
    return Intl.message(
      '已拒绝',
      name: 'coupleRoom_room_rejected',
      desc: '',
      args: [],
    );
  }

  /// `已取消`
  String get coupleRoom_room_canceled {
    return Intl.message(
      '已取消',
      name: 'coupleRoom_room_canceled',
      desc: '',
      args: [],
    );
  }

  /// `客房订单`
  String get coupleRoom_room_order {
    return Intl.message(
      '客房订单',
      name: 'coupleRoom_room_order',
      desc: '',
      args: [],
    );
  }

  /// `请输入房间号查询`
  String get coupleRoom_room_order_search {
    return Intl.message(
      '请输入房间号查询',
      name: 'coupleRoom_room_order_search',
      desc: '',
      args: [],
    );
  }

  /// `下单时间`
  String get coupleRoom_room_order_create_time {
    return Intl.message(
      '下单时间',
      name: 'coupleRoom_room_order_create_time',
      desc: '',
      args: [],
    );
  }

  /// `入住时间`
  String get coupleRoom_room_order_start_time {
    return Intl.message(
      '入住时间',
      name: 'coupleRoom_room_order_start_time',
      desc: '',
      args: [],
    );
  }

  /// `退房时间`
  String get coupleRoom_room_order_end_time {
    return Intl.message(
      '退房时间',
      name: 'coupleRoom_room_order_end_time',
      desc: '',
      args: [],
    );
  }

  /// `总费用`
  String get coupleRoom_room_order_price {
    return Intl.message(
      '总费用',
      name: 'coupleRoom_room_order_price',
      desc: '',
      args: [],
    );
  }

  /// `取消预约`
  String get coupleRoom_room_cancel_order {
    return Intl.message(
      '取消预约',
      name: 'coupleRoom_room_cancel_order',
      desc: '',
      args: [],
    );
  }

  /// `确定取消预约吗？`
  String get coupleRoom_room_cancel_order_confirm {
    return Intl.message(
      '确定取消预约吗？',
      name: 'coupleRoom_room_cancel_order_confirm',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get coupleRoom_room_cancel {
    return Intl.message(
      '取消',
      name: 'coupleRoom_room_cancel',
      desc: '',
      args: [],
    );
  }

  /// `取消预约成功`
  String get coupleRoom_room_cancel_order_success {
    return Intl.message(
      '取消预约成功',
      name: 'coupleRoom_room_cancel_order_success',
      desc: '',
      args: [],
    );
  }

  /// `您的客房预订已取消，请重新预订`
  String get coupleRoom_room_order_cancel_success {
    return Intl.message(
      '您的客房预订已取消，请重新预订',
      name: 'coupleRoom_room_order_cancel_success',
      desc: '',
      args: [],
    );
  }

  /// `取消预约失败`
  String get coupleRoom_room_order_cancel_fail {
    return Intl.message(
      '取消预约失败',
      name: 'coupleRoom_room_order_cancel_fail',
      desc: '',
      args: [],
    );
  }

  /// `确认订单`
  String get coupleRoom_room_confirm_order {
    return Intl.message(
      '确认订单',
      name: 'coupleRoom_room_confirm_order',
      desc: '',
      args: [],
    );
  }

  /// `确定确认订单吗？`
  String get coupleRoom_room_confirm_content {
    return Intl.message(
      '确定确认订单吗？',
      name: 'coupleRoom_room_confirm_content',
      desc: '',
      args: [],
    );
  }

  /// `确认订单成功`
  String get coupleRoom_room_confirm_success {
    return Intl.message(
      '确认订单成功',
      name: 'coupleRoom_room_confirm_success',
      desc: '',
      args: [],
    );
  }

  /// `确认订单失败`
  String get coupleRoom_room_confirm_fail {
    return Intl.message(
      '确认订单失败',
      name: 'coupleRoom_room_confirm_fail',
      desc: '',
      args: [],
    );
  }

  /// `查看`
  String get coupleRoom_room_view {
    return Intl.message('查看', name: 'coupleRoom_room_view', desc: '', args: []);
  }

  /// `订单详情`
  String get coupleRoom_room_order_detail {
    return Intl.message(
      '订单详情',
      name: 'coupleRoom_room_order_detail',
      desc: '',
      args: [],
    );
  }

  /// `客房信息`
  String get coupleRoom_room_info {
    return Intl.message(
      '客房信息',
      name: 'coupleRoom_room_info',
      desc: '',
      args: [],
    );
  }

  /// `员工信息`
  String get coupleRoom_room_staff_info {
    return Intl.message(
      '员工信息',
      name: 'coupleRoom_room_staff_info',
      desc: '',
      args: [],
    );
  }

  /// `岗位/服务`
  String get coupleRoom_room_staff_job {
    return Intl.message(
      '岗位/服务',
      name: 'coupleRoom_room_staff_job',
      desc: '',
      args: [],
    );
  }

  /// `电话`
  String get coupleRoom_room_staff_tel {
    return Intl.message(
      '电话',
      name: 'coupleRoom_room_staff_tel',
      desc: '',
      args: [],
    );
  }

  /// `部门`
  String get coupleRoom_room_staff_dept {
    return Intl.message(
      '部门',
      name: 'coupleRoom_room_staff_dept',
      desc: '',
      args: [],
    );
  }

  /// `工号`
  String get coupleRoom_room_staff_username {
    return Intl.message(
      '工号',
      name: 'coupleRoom_room_staff_username',
      desc: '',
      args: [],
    );
  }

  /// `姓名`
  String get coupleRoom_room_staff_name {
    return Intl.message(
      '姓名',
      name: 'coupleRoom_room_staff_name',
      desc: '',
      args: [],
    );
  }

  /// `性别`
  String get coupleRoom_room_staff_sex {
    return Intl.message(
      '性别',
      name: 'coupleRoom_room_staff_sex',
      desc: '',
      args: [],
    );
  }

  /// `审核信息`
  String get coupleRoom_room_audit_info {
    return Intl.message(
      '审核信息',
      name: 'coupleRoom_room_audit_info',
      desc: '',
      args: [],
    );
  }

  /// `审核人员`
  String get coupleRoom_room_audit_staff {
    return Intl.message(
      '审核人员',
      name: 'coupleRoom_room_audit_staff',
      desc: '',
      args: [],
    );
  }

  /// `审核时间`
  String get coupleRoom_room_audit_time {
    return Intl.message(
      '审核时间',
      name: 'coupleRoom_room_audit_time',
      desc: '',
      args: [],
    );
  }

  /// `审核状态`
  String get coupleRoom_room_audit_status {
    return Intl.message(
      '审核状态',
      name: 'coupleRoom_room_audit_status',
      desc: '',
      args: [],
    );
  }

  /// `通过`
  String get coupleRoom_room_audit_status_pass {
    return Intl.message(
      '通过',
      name: 'coupleRoom_room_audit_status_pass',
      desc: '',
      args: [],
    );
  }

  /// `拒绝`
  String get coupleRoom_room_audit_status_reject {
    return Intl.message(
      '拒绝',
      name: 'coupleRoom_room_audit_status_reject',
      desc: '',
      args: [],
    );
  }

  /// `审核说明`
  String get coupleRoom_room_audit_remark {
    return Intl.message(
      '审核说明',
      name: 'coupleRoom_room_audit_remark',
      desc: '',
      args: [],
    );
  }

  /// `提交清洁服务`
  String get cleaning_submit {
    return Intl.message('提交清洁服务', name: 'cleaning_submit', desc: '', args: []);
  }

  /// `清洁订单`
  String get cleaning_order {
    return Intl.message('清洁订单', name: 'cleaning_order', desc: '', args: []);
  }

  /// `请输入订单号或房间号查询`
  String get cleaning_order_search {
    return Intl.message(
      '请输入订单号或房间号查询',
      name: 'cleaning_order_search',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get cleaning_search {
    return Intl.message('搜索', name: 'cleaning_search', desc: '', args: []);
  }

  /// `订单号`
  String get cleaning_order_number {
    return Intl.message(
      '订单号',
      name: 'cleaning_order_number',
      desc: '',
      args: [],
    );
  }

  /// `联系人`
  String get cleaning_contacts {
    return Intl.message('联系人', name: 'cleaning_contacts', desc: '', args: []);
  }

  /// `联系电话`
  String get cleaning_tel {
    return Intl.message('联系电话', name: 'cleaning_tel', desc: '', args: []);
  }

  /// `房间号`
  String get cleaning_room_number {
    return Intl.message(
      '房间号',
      name: 'cleaning_room_number',
      desc: '',
      args: [],
    );
  }

  /// `价格`
  String get cleaning_price {
    return Intl.message('价格', name: 'cleaning_price', desc: '', args: []);
  }

  /// `下单`
  String get cleaning_order_create {
    return Intl.message(
      '下单',
      name: 'cleaning_order_create',
      desc: '',
      args: [],
    );
  }

  /// `处理`
  String get cleaning_order_handle {
    return Intl.message(
      '处理',
      name: 'cleaning_order_handle',
      desc: '',
      args: [],
    );
  }

  /// `评价`
  String get cleaning_evaluate {
    return Intl.message('评价', name: 'cleaning_evaluate', desc: '', args: []);
  }

  /// `查看`
  String get cleaning_order_view {
    return Intl.message('查看', name: 'cleaning_order_view', desc: '', args: []);
  }

  /// `状态`
  String get cleaning_order_status {
    return Intl.message(
      '状态',
      name: 'cleaning_order_status',
      desc: '',
      args: [],
    );
  }

  /// `未知状态`
  String get unknown_status {
    return Intl.message('未知状态', name: 'unknown_status', desc: '', args: []);
  }

  /// `暂无详细信息`
  String get no_more_info {
    return Intl.message('暂无详细信息', name: 'no_more_info', desc: '', args: []);
  }

  /// `待处理`
  String get cleaning_order_pending {
    return Intl.message(
      '待处理',
      name: 'cleaning_order_pending',
      desc: '',
      args: [],
    );
  }

  /// `评价订单`
  String get cleaning_order_evaluate {
    return Intl.message(
      '评价订单',
      name: 'cleaning_order_evaluate',
      desc: '',
      args: [],
    );
  }

  /// `服务评分`
  String get cleaning_order_evaluate_title {
    return Intl.message(
      '服务评分',
      name: 'cleaning_order_evaluate_title',
      desc: '',
      args: [],
    );
  }

  /// `评价内容`
  String get cleaning_order_evaluate_content {
    return Intl.message(
      '评价内容',
      name: 'cleaning_order_evaluate_content',
      desc: '',
      args: [],
    );
  }

  /// `提交评价`
  String get cleaning_order_evaluate_submit {
    return Intl.message(
      '提交评价',
      name: 'cleaning_order_evaluate_submit',
      desc: '',
      args: [],
    );
  }

  /// `评价成功`
  String get cleaning_order_evaluate_success {
    return Intl.message(
      '评价成功',
      name: 'cleaning_order_evaluate_success',
      desc: '',
      args: [],
    );
  }

  /// `评价失败`
  String get cleaning_order_evaluate_fail {
    return Intl.message(
      '评价失败',
      name: 'cleaning_order_evaluate_fail',
      desc: '',
      args: [],
    );
  }

  /// `请输入您的评价内容（可选）`
  String get cleaning_order_evaluate_content_hint {
    return Intl.message(
      '请输入您的评价内容（可选）',
      name: 'cleaning_order_evaluate_content_hint',
      desc: '',
      args: [],
    );
  }

  /// `请选择评分`
  String get cleaning_order_evaluate_select_rating {
    return Intl.message(
      '请选择评分',
      name: 'cleaning_order_evaluate_select_rating',
      desc: '',
      args: [],
    );
  }

  /// `非常不满意`
  String get cleaning_order_evaluate_very_dissatisfied {
    return Intl.message(
      '非常不满意',
      name: 'cleaning_order_evaluate_very_dissatisfied',
      desc: '',
      args: [],
    );
  }

  /// `不满意`
  String get cleaning_order_evaluate_dissatisfied {
    return Intl.message(
      '不满意',
      name: 'cleaning_order_evaluate_dissatisfied',
      desc: '',
      args: [],
    );
  }

  /// `一般`
  String get cleaning_order_evaluate_average {
    return Intl.message(
      '一般',
      name: 'cleaning_order_evaluate_average',
      desc: '',
      args: [],
    );
  }

  /// `满意`
  String get cleaning_order_evaluate_satisfied {
    return Intl.message(
      '满意',
      name: 'cleaning_order_evaluate_satisfied',
      desc: '',
      args: [],
    );
  }

  /// `非常满意`
  String get cleaning_order_evaluate_very_satisfied {
    return Intl.message(
      '非常满意',
      name: 'cleaning_order_evaluate_very_satisfied',
      desc: '',
      args: [],
    );
  }

  /// `选择清洁项目`
  String get cleaning_select_cleaning_project {
    return Intl.message(
      '选择清洁项目',
      name: 'cleaning_select_cleaning_project',
      desc: '',
      args: [],
    );
  }

  /// `深度清洁`
  String get cleaning_deep_cleaning {
    return Intl.message(
      '深度清洁',
      name: 'cleaning_deep_cleaning',
      desc: '',
      args: [],
    );
  }

  /// `专项清洁`
  String get cleaning_special_cleaning {
    return Intl.message(
      '专项清洁',
      name: 'cleaning_special_cleaning',
      desc: '',
      args: [],
    );
  }

  /// `请选择清洁地址`
  String get cleaning_select_address {
    return Intl.message(
      '请选择清洁地址',
      name: 'cleaning_select_address',
      desc: '',
      args: [],
    );
  }

  /// `请选择预约日期`
  String get cleaning_select_date {
    return Intl.message(
      '请选择预约日期',
      name: 'cleaning_select_date',
      desc: '',
      args: [],
    );
  }

  /// `预约日期`
  String get cleaning_date {
    return Intl.message('预约日期', name: 'cleaning_date', desc: '', args: []);
  }

  /// `清洁地址不在清洁项目对应的区域，请重新选择！`
  String get cleaning_select_address_error {
    return Intl.message(
      '清洁地址不在清洁项目对应的区域，请重新选择！',
      name: 'cleaning_select_address_error',
      desc: '',
      args: [],
    );
  }

  /// `提交订单`
  String get cleaning_order_submit {
    return Intl.message(
      '提交订单',
      name: 'cleaning_order_submit',
      desc: '',
      args: [],
    );
  }

  /// `加载中...`
  String get cleaning_loading {
    return Intl.message('加载中...', name: 'cleaning_loading', desc: '', args: []);
  }

  /// `清洁订单详情`
  String get cleaning_order_detail {
    return Intl.message(
      '清洁订单详情',
      name: 'cleaning_order_detail',
      desc: '',
      args: [],
    );
  }

  /// `基本信息`
  String get cleaning_basic_info {
    return Intl.message(
      '基本信息',
      name: 'cleaning_basic_info',
      desc: '',
      args: [],
    );
  }

  /// `清洁区域`
  String get cleaning_area {
    return Intl.message('清洁区域', name: 'cleaning_area', desc: '', args: []);
  }

  /// `服务详情`
  String get cleaning_service_detail {
    return Intl.message(
      '服务详情',
      name: 'cleaning_service_detail',
      desc: '',
      args: [],
    );
  }

  /// `清洁项目`
  String get cleaning_project {
    return Intl.message('清洁项目', name: 'cleaning_project', desc: '', args: []);
  }

  /// `订单进度`
  String get cleaning_order_progress {
    return Intl.message(
      '订单进度',
      name: 'cleaning_order_progress',
      desc: '',
      args: [],
    );
  }

  /// `其他信息`
  String get cleaning_other_info {
    return Intl.message(
      '其他信息',
      name: 'cleaning_other_info',
      desc: '',
      args: [],
    );
  }

  /// `备注`
  String get cleaning_remark {
    return Intl.message('备注', name: 'cleaning_remark', desc: '', args: []);
  }

  /// `请输入特殊要求或备注信息（可选）`
  String get cleaning_remark_hint {
    return Intl.message(
      '请输入特殊要求或备注信息（可选）',
      name: 'cleaning_remark_hint',
      desc: '',
      args: [],
    );
  }

  /// `早餐`
  String get breakfast {
    return Intl.message('早餐', name: 'breakfast', desc: '', args: []);
  }

  /// `午餐`
  String get lunch {
    return Intl.message('午餐', name: 'lunch', desc: '', args: []);
  }

  /// `晚餐`
  String get dinner {
    return Intl.message('晚餐', name: 'dinner', desc: '', args: []);
  }

  /// `其他`
  String get other {
    return Intl.message('其他', name: 'other', desc: '', args: []);
  }

  /// `未知菜品`
  String get unknown_dish {
    return Intl.message('未知菜品', name: 'unknown_dish', desc: '', args: []);
  }

  /// `道菜`
  String get dishes {
    return Intl.message('道菜', name: 'dishes', desc: '', args: []);
  }

  /// `选择日期`
  String get select_date {
    return Intl.message('选择日期', name: 'select_date', desc: '', args: []);
  }

  /// `正在加载今日菜谱...`
  String get loading_food_menu {
    return Intl.message(
      '正在加载今日菜谱...',
      name: 'loading_food_menu',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get load_failed {
    return Intl.message('加载失败', name: 'load_failed', desc: '', args: []);
  }

  /// `未知错误`
  String get unknown_error {
    return Intl.message('未知错误', name: 'unknown_error', desc: '', args: []);
  }

  /// `重新加载`
  String get reload {
    return Intl.message('重新加载', name: 'reload', desc: '', args: []);
  }

  /// `暂无菜谱信息`
  String get no_food_menu_info {
    return Intl.message(
      '暂无菜谱信息',
      name: 'no_food_menu_info',
      desc: '',
      args: [],
    );
  }

  /// `该日期暂无菜谱安排`
  String get no_food_menu_info_tips {
    return Intl.message(
      '该日期暂无菜谱安排',
      name: 'no_food_menu_info_tips',
      desc: '',
      args: [],
    );
  }

  /// `今日菜谱`
  String get food_menu {
    return Intl.message('今日菜谱', name: 'food_menu', desc: '', args: []);
  }

  /// `刷新菜谱`
  String get refresh_food_menu {
    return Intl.message('刷新菜谱', name: 'refresh_food_menu', desc: '', args: []);
  }

  /// `发现隐患`
  String get report_hazard {
    return Intl.message('发现隐患', name: 'report_hazard', desc: '', args: []);
  }

  /// `请选择发现日期`
  String get select_discover_date {
    return Intl.message(
      '请选择发现日期',
      name: 'select_discover_date',
      desc: '',
      args: [],
    );
  }

  /// `请选择发现时间`
  String get select_discover_time {
    return Intl.message(
      '请选择发现时间',
      name: 'select_discover_time',
      desc: '',
      args: [],
    );
  }

  /// `请选择发现地点`
  String get select_discover_location {
    return Intl.message(
      '请选择发现地点',
      name: 'select_discover_location',
      desc: '',
      args: [],
    );
  }

  /// `请描述发现情况`
  String get select_discover_description {
    return Intl.message(
      '请描述发现情况',
      name: 'select_discover_description',
      desc: '',
      args: [],
    );
  }

  /// `请上传发现照片`
  String get select_discover_photo {
    return Intl.message(
      '请上传发现照片',
      name: 'select_discover_photo',
      desc: '',
      args: [],
    );
  }

  /// `图片上传失败，请重试`
  String get upload_images_failed {
    return Intl.message(
      '图片上传失败，请重试',
      name: 'upload_images_failed',
      desc: '',
      args: [],
    );
  }

  /// `提交成功`
  String get submit_hazard_report_success {
    return Intl.message(
      '提交成功',
      name: 'submit_hazard_report_success',
      desc: '',
      args: [],
    );
  }

  /// `提交失败`
  String get submit_hazard_report_fail {
    return Intl.message(
      '提交失败',
      name: 'submit_hazard_report_fail',
      desc: '',
      args: [],
    );
  }

  /// `确定提交隐患报告吗？`
  String get submit_hazard_report_content {
    return Intl.message(
      '确定提交隐患报告吗？',
      name: 'submit_hazard_report_content',
      desc: '',
      args: [],
    );
  }

  /// `隐患名称`
  String get hazard_name {
    return Intl.message('隐患名称', name: 'hazard_name', desc: '', args: []);
  }

  /// `发现地点`
  String get hazard_location {
    return Intl.message('发现地点', name: 'hazard_location', desc: '', args: []);
  }

  /// `隐患描述`
  String get hazard_description {
    return Intl.message('隐患描述', name: 'hazard_description', desc: '', args: []);
  }

  /// `隐患照片`
  String get hazard_photo {
    return Intl.message('隐患照片', name: 'hazard_photo', desc: '', args: []);
  }

  /// `提交`
  String get hazard_submit {
    return Intl.message('提交', name: 'hazard_submit', desc: '', args: []);
  }

  /// `请输入隐患名称`
  String get please_enter_hazard_name {
    return Intl.message(
      '请输入隐患名称',
      name: 'please_enter_hazard_name',
      desc: '',
      args: [],
    );
  }

  /// `请输入发现地点`
  String get please_enter_hazard_location {
    return Intl.message(
      '请输入发现地点',
      name: 'please_enter_hazard_location',
      desc: '',
      args: [],
    );
  }

  /// `请描述发现隐患`
  String get please_enter_hazard_description {
    return Intl.message(
      '请描述发现隐患',
      name: 'please_enter_hazard_description',
      desc: '',
      args: [],
    );
  }

  /// `请上传发现照片`
  String get please_upload_hazard_photo {
    return Intl.message(
      '请上传发现照片',
      name: 'please_upload_hazard_photo',
      desc: '',
      args: [],
    );
  }

  /// `请上传发现视频`
  String get please_upload_hazard_video {
    return Intl.message(
      '请上传发现视频',
      name: 'please_upload_hazard_video',
      desc: '',
      args: [],
    );
  }

  /// `请选择发现日期`
  String get please_select_hazard_date {
    return Intl.message(
      '请选择发现日期',
      name: 'please_select_hazard_date',
      desc: '',
      args: [],
    );
  }

  /// `请选择发现时间`
  String get please_select_hazard_time {
    return Intl.message(
      '请选择发现时间',
      name: 'please_select_hazard_time',
      desc: '',
      args: [],
    );
  }

  /// `上报人`
  String get reporter {
    return Intl.message('上报人', name: 'reporter', desc: '', args: []);
  }

  /// `姓名`
  String get reporter_name {
    return Intl.message('姓名', name: 'reporter_name', desc: '', args: []);
  }

  /// `联系电话`
  String get reporter_tel {
    return Intl.message('联系电话', name: 'reporter_tel', desc: '', args: []);
  }

  /// `请输入上报人姓名`
  String get please_enter_reporter_name {
    return Intl.message(
      '请输入上报人姓名',
      name: 'please_enter_reporter_name',
      desc: '',
      args: [],
    );
  }

  /// `请输入联系电话`
  String get please_enter_reporter_tel {
    return Intl.message(
      '请输入联系电话',
      name: 'please_enter_reporter_tel',
      desc: '',
      args: [],
    );
  }

  /// `（可选）`
  String get optional {
    return Intl.message('（可选）', name: 'optional', desc: '', args: []);
  }

  /// `请拍摄或选择隐患现场照片，最多选择6张`
  String get please_upload_hazard_photo_tips {
    return Intl.message(
      '请拍摄或选择隐患现场照片，最多选择6张',
      name: 'please_upload_hazard_photo_tips',
      desc: '',
      args: [],
    );
  }

  /// `已选择`
  String get selected {
    return Intl.message('已选择', name: 'selected', desc: '', args: []);
  }

  /// `张图片`
  String get images {
    return Intl.message('张图片', name: 'images', desc: '', args: []);
  }

  /// `配送站点`
  String get delivery_site {
    return Intl.message('配送站点', name: 'delivery_site', desc: '', args: []);
  }

  /// `请输入配送站点名称查询`
  String get delivery_site_search {
    return Intl.message(
      '请输入配送站点名称查询',
      name: 'delivery_site_search',
      desc: '',
      args: [],
    );
  }

  /// `请输入配送站点名称查询`
  String get delivery_site_search_placeholder {
    return Intl.message(
      '请输入配送站点名称查询',
      name: 'delivery_site_search_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `确定清除搜索内容吗？`
  String get delivery_site_search_clear_confirm {
    return Intl.message(
      '确定清除搜索内容吗？',
      name: 'delivery_site_search_clear_confirm',
      desc: '',
      args: [],
    );
  }

  /// `未找到匹配的配送站点`
  String get delivery_site_search_not_found {
    return Intl.message(
      '未找到匹配的配送站点',
      name: 'delivery_site_search_not_found',
      desc: '',
      args: [],
    );
  }

  /// `中国餐`
  String get chineseFood {
    return Intl.message('中国餐', name: 'chineseFood', desc: '', args: []);
  }

  /// `印尼餐`
  String get indonesianFood {
    return Intl.message('印尼餐', name: 'indonesianFood', desc: '', args: []);
  }

  /// `瓶装水`
  String get bottleWater {
    return Intl.message('瓶装水', name: 'bottleWater', desc: '', args: []);
  }

  /// `点心`
  String get dessert {
    return Intl.message('点心', name: 'dessert', desc: '', args: []);
  }

  /// `早茶`
  String get earlyTea {
    return Intl.message('早茶', name: 'earlyTea', desc: '', args: []);
  }

  /// `夜宵`
  String get nightSnack {
    return Intl.message('夜宵', name: 'nightSnack', desc: '', args: []);
  }

  /// `20L`
  String get waterService {
    return Intl.message('20L', name: 'waterService', desc: '', args: []);
  }

  /// `餐次`
  String get mealTime {
    return Intl.message('餐次', name: 'mealTime', desc: '', args: []);
  }

  /// `配送食堂`
  String get delivery_canteen {
    return Intl.message('配送食堂', name: 'delivery_canteen', desc: '', args: []);
  }

  /// `餐种`
  String get foodType {
    return Intl.message('餐种', name: 'foodType', desc: '', args: []);
  }

  /// `餐别`
  String get mealType {
    return Intl.message('餐别', name: 'mealType', desc: '', args: []);
  }

  /// `配送方式`
  String get deliveryType {
    return Intl.message('配送方式', name: 'deliveryType', desc: '', args: []);
  }

  /// `订餐份数`
  String get orderNum {
    return Intl.message('订餐份数', name: 'orderNum', desc: '', args: []);
  }

  /// `自取`
  String get selfPickup {
    return Intl.message('自取', name: 'selfPickup', desc: '', args: []);
  }

  /// `已下单`
  String get deliveryOrderPlaced {
    return Intl.message('已下单', name: 'deliveryOrderPlaced', desc: '', args: []);
  }

  /// `配餐中`
  String get deliveryCooking {
    return Intl.message('配餐中', name: 'deliveryCooking', desc: '', args: []);
  }

  /// `已打包`
  String get deliveryPacked {
    return Intl.message('已打包', name: 'deliveryPacked', desc: '', args: []);
  }

  /// `送餐中`
  String get deliveryDelivering {
    return Intl.message('送餐中', name: 'deliveryDelivering', desc: '', args: []);
  }

  /// `已送达`
  String get deliveryDelivered {
    return Intl.message('已送达', name: 'deliveryDelivered', desc: '', args: []);
  }

  /// `已退单`
  String get deliveryCancelled {
    return Intl.message('已退单', name: 'deliveryCancelled', desc: '', args: []);
  }

  /// `订单进度`
  String get orderProgress {
    return Intl.message('订单进度', name: 'orderProgress', desc: '', args: []);
  }

  /// `下单人`
  String get orderPlacedBy {
    return Intl.message('下单人', name: 'orderPlacedBy', desc: '', args: []);
  }

  /// `班组未提交`
  String get groupNotSubmitted {
    return Intl.message('班组未提交', name: 'groupNotSubmitted', desc: '', args: []);
  }

  /// `班组已提交`
  String get groupSubmitted {
    return Intl.message('班组已提交', name: 'groupSubmitted', desc: '', args: []);
  }

  /// `部门已提交`
  String get departmentSubmitted {
    return Intl.message(
      '部门已提交',
      name: 'departmentSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `订单中心已确认`
  String get orderCenterConfirmed {
    return Intl.message(
      '订单中心已确认',
      name: 'orderCenterConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `正常订单`
  String get normalOrder {
    return Intl.message('正常订单', name: 'normalOrder', desc: '', args: []);
  }

  /// `补餐`
  String get supplementOrder {
    return Intl.message('补餐', name: 'supplementOrder', desc: '', args: []);
  }

  /// `减餐`
  String get reduceOrder {
    return Intl.message('减餐', name: 'reduceOrder', desc: '', args: []);
  }

  /// `未审核`
  String get deliveryNotAudited {
    return Intl.message('未审核', name: 'deliveryNotAudited', desc: '', args: []);
  }

  /// `审核通过`
  String get deliveryAudited {
    return Intl.message('审核通过', name: 'deliveryAudited', desc: '', args: []);
  }

  /// `审核驳回`
  String get deliveryAuditRejected {
    return Intl.message(
      '审核驳回',
      name: 'deliveryAuditRejected',
      desc: '',
      args: [],
    );
  }

  /// `未开始配送`
  String get deliveryNotStarted {
    return Intl.message(
      '未开始配送',
      name: 'deliveryNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `复制成功`
  String get copySuccess {
    return Intl.message('复制成功', name: 'copySuccess', desc: '', args: []);
  }

  /// `餐盒`
  String get deliveryMealBox {
    return Intl.message('餐盒', name: 'deliveryMealBox', desc: '', args: []);
  }

  /// `桶装`
  String get deliveryBucket {
    return Intl.message('桶装', name: 'deliveryBucket', desc: '', args: []);
  }

  /// `打包袋`
  String get deliveryBag {
    return Intl.message('打包袋', name: 'deliveryBag', desc: '', args: []);
  }

  /// `驳回原因`
  String get deliveryRejectReason {
    return Intl.message(
      '驳回原因',
      name: 'deliveryRejectReason',
      desc: '',
      args: [],
    );
  }

  /// `份`
  String get orderNumUnit {
    return Intl.message('份', name: 'orderNumUnit', desc: '', args: []);
  }

  /// `开始配送`
  String get deliveryStartDelivery {
    return Intl.message(
      '开始配送',
      name: 'deliveryStartDelivery',
      desc: '',
      args: [],
    );
  }

  /// `打包`
  String get deliveryPackage {
    return Intl.message('打包', name: 'deliveryPackage', desc: '', args: []);
  }

  /// `退单`
  String get deliveryReturnOrder {
    return Intl.message('退单', name: 'deliveryReturnOrder', desc: '', args: []);
  }

  /// `提交`
  String get deliverySubmit {
    return Intl.message('提交', name: 'deliverySubmit', desc: '', args: []);
  }

  /// `驳回`
  String get deliveryReject {
    return Intl.message('驳回', name: 'deliveryReject', desc: '', args: []);
  }

  /// `驳回成功`
  String get deliveryRejectSuccess {
    return Intl.message(
      '驳回成功',
      name: 'deliveryRejectSuccess',
      desc: '',
      args: [],
    );
  }

  /// `驳回失败`
  String get deliveryRejectFail {
    return Intl.message('驳回失败', name: 'deliveryRejectFail', desc: '', args: []);
  }

  /// `确定退单吗？`
  String get deliveryReturnOrderConfirm {
    return Intl.message(
      '确定退单吗？',
      name: 'deliveryReturnOrderConfirm',
      desc: '',
      args: [],
    );
  }

  /// `退单成功`
  String get deliveryReturnOrderSuccess {
    return Intl.message(
      '退单成功',
      name: 'deliveryReturnOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `退单失败`
  String get deliveryReturnOrderFail {
    return Intl.message(
      '退单失败',
      name: 'deliveryReturnOrderFail',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get deliveryCancel {
    return Intl.message('取消', name: 'deliveryCancel', desc: '', args: []);
  }

  /// `确定`
  String get deliveryConfirm {
    return Intl.message('确定', name: 'deliveryConfirm', desc: '', args: []);
  }

  /// `选择车队`
  String get deliverySelectTeam {
    return Intl.message('选择车队', name: 'deliverySelectTeam', desc: '', args: []);
  }

  /// `获取车队失败`
  String get deliverySelectTeamFail {
    return Intl.message(
      '获取车队失败',
      name: 'deliverySelectTeamFail',
      desc: '',
      args: [],
    );
  }

  /// `订单种类`
  String get deliveryOrderType {
    return Intl.message('订单种类', name: 'deliveryOrderType', desc: '', args: []);
  }

  /// `提交状态`
  String get deliverySubmitStatus {
    return Intl.message(
      '提交状态',
      name: 'deliverySubmitStatus',
      desc: '',
      args: [],
    );
  }

  /// `订单状态`
  String get deliveryOrderStatus {
    return Intl.message(
      '订单状态',
      name: 'deliveryOrderStatus',
      desc: '',
      args: [],
    );
  }

  /// `已选条件:`
  String get deliverySelectedConditions {
    return Intl.message(
      '已选条件:',
      name: 'deliverySelectedConditions',
      desc: '',
      args: [],
    );
  }

  /// `重置`
  String get deliveryReset {
    return Intl.message('重置', name: 'deliveryReset', desc: '', args: []);
  }

  /// `订单提交成功！`
  String get deliveryOrderSuccess {
    return Intl.message(
      '订单提交成功！',
      name: 'deliveryOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `当前时间不可预订`
  String get deliveryOrderNotAvailable {
    return Intl.message(
      '当前时间不可预订',
      name: 'deliveryOrderNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `今日订餐`
  String get deliveryOrderTitle {
    return Intl.message('今日订餐', name: 'deliveryOrderTitle', desc: '', args: []);
  }

  /// `未绑定报餐送餐帐号，请先绑定帐号`
  String get deliveryOrderNotBindAccount {
    return Intl.message(
      '未绑定报餐送餐帐号，请先绑定帐号',
      name: 'deliveryOrderNotBindAccount',
      desc: '',
      args: [],
    );
  }

  /// `绑定帐号`
  String get deliveryBindAccount {
    return Intl.message(
      '绑定帐号',
      name: 'deliveryBindAccount',
      desc: '',
      args: [],
    );
  }

  /// `今日可选餐次`
  String get deliveryOrderAvailable {
    return Intl.message(
      '今日可选餐次',
      name: 'deliveryOrderAvailable',
      desc: '',
      args: [],
    );
  }

  /// `临时人员订餐`
  String get deliveryOrderTemporary {
    return Intl.message(
      '临时人员订餐',
      name: 'deliveryOrderTemporary',
      desc: '',
      args: [],
    );
  }

  /// `点击预订`
  String get deliveryOrderSubmit {
    return Intl.message(
      '点击预订',
      name: 'deliveryOrderSubmit',
      desc: '',
      args: [],
    );
  }

  /// `温馨提示：请根据用餐时间选择合适的餐食类型，订单提交后不可更改`
  String get deliveryOrderTips {
    return Intl.message(
      '温馨提示：请根据用餐时间选择合适的餐食类型，订单提交后不可更改',
      name: 'deliveryOrderTips',
      desc: '',
      args: [],
    );
  }

  /// `暂无订餐权限，联系部门文员`
  String get deliveryOrderNoPermission {
    return Intl.message(
      '暂无订餐权限，联系部门文员',
      name: 'deliveryOrderNoPermission',
      desc: '',
      args: [],
    );
  }

  /// `获取人员列表`
  String get deliveryGetPersonList {
    return Intl.message(
      '获取人员列表',
      name: 'deliveryGetPersonList',
      desc: '',
      args: [],
    );
  }

  /// `获取人员列表失败`
  String get deliveryGetPersonListFail {
    return Intl.message(
      '获取人员列表失败',
      name: 'deliveryGetPersonListFail',
      desc: '',
      args: [],
    );
  }

  /// `获取送餐地点数据中...`
  String get deliveryGetMealPlace {
    return Intl.message(
      '获取送餐地点数据中...',
      name: 'deliveryGetMealPlace',
      desc: '',
      args: [],
    );
  }

  /// `获取送餐地点数据失败`
  String get deliveryGetMealPlaceFail {
    return Intl.message(
      '获取送餐地点数据失败',
      name: 'deliveryGetMealPlaceFail',
      desc: '',
      args: [],
    );
  }

  /// `打包失败`
  String get deliveryPackOrderFail {
    return Intl.message(
      '打包失败',
      name: 'deliveryPackOrderFail',
      desc: '',
      args: [],
    );
  }

  /// `开始配送`
  String get deliveryDeliverOrder {
    return Intl.message(
      '开始配送',
      name: 'deliveryDeliverOrder',
      desc: '',
      args: [],
    );
  }

  /// `开始配送失败`
  String get deliveryDeliverOrderFail {
    return Intl.message(
      '开始配送失败',
      name: 'deliveryDeliverOrderFail',
      desc: '',
      args: [],
    );
  }

  /// `提交成功`
  String get deliverySubmitOrderSuccess {
    return Intl.message(
      '提交成功',
      name: 'deliverySubmitOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `提交失败`
  String get deliverySubmitOrderFail {
    return Intl.message(
      '提交失败',
      name: 'deliverySubmitOrderFail',
      desc: '',
      args: [],
    );
  }

  /// `请选择人员`
  String get deliverySelectPerson {
    return Intl.message(
      '请选择人员',
      name: 'deliverySelectPerson',
      desc: '',
      args: [],
    );
  }

  /// `请选择送餐地点`
  String get deliverySelectPlace {
    return Intl.message(
      '请选择送餐地点',
      name: 'deliverySelectPlace',
      desc: '',
      args: [],
    );
  }

  /// `请选择送餐时间`
  String get deliverySelectTime {
    return Intl.message(
      '请选择送餐时间',
      name: 'deliverySelectTime',
      desc: '',
      args: [],
    );
  }

  /// `订餐配送`
  String get deliverySubmitOrder {
    return Intl.message(
      '订餐配送',
      name: 'deliverySubmitOrder',
      desc: '',
      args: [],
    );
  }

  /// `打包饭`
  String get deliveryPackedMeal {
    return Intl.message('打包饭', name: 'deliveryPackedMeal', desc: '', args: []);
  }

  /// `盒装饭`
  String get deliveryBoxedMeal {
    return Intl.message('盒装饭', name: 'deliveryBoxedMeal', desc: '', args: []);
  }

  /// `份数`
  String get deliveryQuantity {
    return Intl.message('份数', name: 'deliveryQuantity', desc: '', args: []);
  }

  /// `请选择餐种`
  String get deliverySelectMealType {
    return Intl.message(
      '请选择餐种',
      name: 'deliverySelectMealType',
      desc: '',
      args: [],
    );
  }

  /// `已选择人员`
  String get deliverySelectedPeople {
    return Intl.message(
      '已选择人员',
      name: 'deliverySelectedPeople',
      desc: '',
      args: [],
    );
  }

  /// `创建订单`
  String get deliveryCreateOrder {
    return Intl.message(
      '创建订单',
      name: 'deliveryCreateOrder',
      desc: '',
      args: [],
    );
  }

  /// `订水服务`
  String get deliveryWaterService {
    return Intl.message(
      '订水服务',
      name: 'deliveryWaterService',
      desc: '',
      args: [],
    );
  }

  /// `选择配送站点和数量，我们将为您提供优质的饮用水服务`
  String get deliveryWaterServiceTips {
    return Intl.message(
      '选择配送站点和数量，我们将为您提供优质的饮用水服务',
      name: 'deliveryWaterServiceTips',
      desc: '',
      args: [],
    );
  }

  /// `部门`
  String get deliveryDept {
    return Intl.message('部门', name: 'deliveryDept', desc: '', args: []);
  }

  /// `按姓名搜索`
  String get deliverySearchPerson {
    return Intl.message(
      '按姓名搜索',
      name: 'deliverySearchPerson',
      desc: '',
      args: [],
    );
  }

  /// `全选/反选`
  String get selectAllOrDeselectAll {
    return Intl.message(
      '全选/反选',
      name: 'selectAllOrDeselectAll',
      desc: '',
      args: [],
    );
  }

  /// `工号`
  String get deliveryJobNumber {
    return Intl.message('工号', name: 'deliveryJobNumber', desc: '', args: []);
  }

  /// `部门名称`
  String get deliveryDeptName {
    return Intl.message('部门名称', name: 'deliveryDeptName', desc: '', args: []);
  }

  /// `图片上传中...`
  String get deliveryUploading {
    return Intl.message(
      '图片上传中...',
      name: 'deliveryUploading',
      desc: '',
      args: [],
    );
  }

  /// `订单已完成`
  String get deliveryOrderCompleted {
    return Intl.message(
      '订单已完成',
      name: 'deliveryOrderCompleted',
      desc: '',
      args: [],
    );
  }

  /// `订单提交失败`
  String get deliveryOrderSubmitFail {
    return Intl.message(
      '订单提交失败',
      name: 'deliveryOrderSubmitFail',
      desc: '',
      args: [],
    );
  }

  /// `加载中...`
  String get deliveryLoading {
    return Intl.message('加载中...', name: 'deliveryLoading', desc: '', args: []);
  }

  /// `查看人员`
  String get viewPerson {
    return Intl.message('查看人员', name: 'viewPerson', desc: '', args: []);
  }

  /// `修改人员`
  String get modifyPerson {
    return Intl.message('修改人员', name: 'modifyPerson', desc: '', args: []);
  }

  /// `人员列表`
  String get personList {
    return Intl.message('人员列表', name: 'personList', desc: '', args: []);
  }

  /// `共{count}人`
  String deliveryTotal(Object count) {
    return Intl.message(
      '共$count人',
      name: 'deliveryTotal',
      desc: '',
      args: [count],
    );
  }

  /// `暂无人员信息`
  String get noPersonInfo {
    return Intl.message('暂无人员信息', name: 'noPersonInfo', desc: '', args: []);
  }

  /// `未知姓名`
  String get unknownName {
    return Intl.message('未知姓名', name: 'unknownName', desc: '', args: []);
  }

  /// `联系电话`
  String get deliveryTel {
    return Intl.message('联系电话', name: 'deliveryTel', desc: '', args: []);
  }

  /// `邮箱`
  String get deliveryEmail {
    return Intl.message('邮箱', name: 'deliveryEmail', desc: '', args: []);
  }

  /// `职位`
  String get deliveryPost {
    return Intl.message('职位', name: 'deliveryPost', desc: '', args: []);
  }

  /// `未知`
  String get unknown {
    return Intl.message('未知', name: 'unknown', desc: '', args: []);
  }

  /// `关闭`
  String get close {
    return Intl.message('关闭', name: 'close', desc: '', args: []);
  }

  /// `订单列表`
  String get deliveryOrderList {
    return Intl.message('订单列表', name: 'deliveryOrderList', desc: '', args: []);
  }

  /// `通过配送地点或订单编号搜索`
  String get deliverySearchOrder {
    return Intl.message(
      '通过配送地点或订单编号搜索',
      name: 'deliverySearchOrder',
      desc: '',
      args: [],
    );
  }

  /// `正在处理扫码结果`
  String get processingScanResult {
    return Intl.message(
      '正在处理扫码结果',
      name: 'processingScanResult',
      desc: '',
      args: [],
    );
  }

  /// `处理异常`
  String get processingScanResultError {
    return Intl.message(
      '处理异常',
      name: 'processingScanResultError',
      desc: '',
      args: [],
    );
  }

  /// `取餐成功，剩余{count}份包裹未取`
  String mealDeliverySuccess(Object count) {
    return Intl.message(
      '取餐成功，剩余$count份包裹未取',
      name: 'mealDeliverySuccess',
      desc: '',
      args: [count],
    );
  }

  /// `订单已全部装车`
  String get orderAllLoaded {
    return Intl.message('订单已全部装车', name: 'orderAllLoaded', desc: '', args: []);
  }

  /// `未取订单`
  String get unreceivedOrder {
    return Intl.message('未取订单', name: 'unreceivedOrder', desc: '', args: []);
  }

  /// `未收`
  String get unreceived {
    return Intl.message('未收', name: 'unreceived', desc: '', args: []);
  }

  /// `没有查询到订单信息`
  String get orderNotFound {
    return Intl.message('没有查询到订单信息', name: 'orderNotFound', desc: '', args: []);
  }

  /// `订单已驳回`
  String get orderRejected {
    return Intl.message('订单已驳回', name: 'orderRejected', desc: '', args: []);
  }

  /// `非 (订单中心已确认 & 配餐中)`
  String get orderNotConfirmed {
    return Intl.message(
      '非 (订单中心已确认 & 配餐中)',
      name: 'orderNotConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `重复接收订单`
  String get duplicateOrderReception {
    return Intl.message(
      '重复接收订单',
      name: 'duplicateOrderReception',
      desc: '',
      args: [],
    );
  }

  /// `您没有取餐权限`
  String get permissionDenied {
    return Intl.message(
      '您没有取餐权限',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `餐次名称不匹配`
  String get foodNameChooseError {
    return Intl.message(
      '餐次名称不匹配',
      name: 'foodNameChooseError',
      desc: '',
      args: [],
    );
  }

  /// `盒装饭不需要接收`
  String get packageTypeError {
    return Intl.message(
      '盒装饭不需要接收',
      name: 'packageTypeError',
      desc: '',
      args: [],
    );
  }

  /// `手持机扫码接单`
  String get mealDeliveryAccept {
    return Intl.message(
      '手持机扫码接单',
      name: 'mealDeliveryAccept',
      desc: '',
      args: [],
    );
  }

  /// `扫码状态`
  String get scanStatus {
    return Intl.message('扫码状态', name: 'scanStatus', desc: '', args: []);
  }

  /// `处理中...`
  String get processing {
    return Intl.message('处理中...', name: 'processing', desc: '', args: []);
  }

  /// `最近扫码`
  String get recentlyScanned {
    return Intl.message('最近扫码', name: 'recentlyScanned', desc: '', args: []);
  }

  /// `等待扫码...`
  String get waitingForScan {
    return Intl.message('等待扫码...', name: 'waitingForScan', desc: '', args: []);
  }

  /// `扫码设置`
  String get scanSettings {
    return Intl.message('扫码设置', name: 'scanSettings', desc: '', args: []);
  }

  /// `选择对应的餐次和餐种`
  String get selectMealTimeAndFoodType {
    return Intl.message(
      '选择对应的餐次和餐种',
      name: 'selectMealTimeAndFoodType',
      desc: '',
      args: [],
    );
  }

  /// `点击确认按钮查看未接收订单`
  String get clickConfirmButtonToViewUnreceivedOrders {
    return Intl.message(
      '点击确认按钮查看未接收订单',
      name: 'clickConfirmButtonToViewUnreceivedOrders',
      desc: '',
      args: [],
    );
  }

  /// `使用说明`
  String get usageInstructions {
    return Intl.message('使用说明', name: 'usageInstructions', desc: '', args: []);
  }

  /// `使用手持机扫描条码`
  String get useHandheldScannerToScanBarcode {
    return Intl.message(
      '使用手持机扫描条码',
      name: 'useHandheldScannerToScanBarcode',
      desc: '',
      args: [],
    );
  }

  /// `订单送达成功！`
  String get deliverySuccess {
    return Intl.message('订单送达成功！', name: 'deliverySuccess', desc: '', args: []);
  }

  /// `订单送达失败！`
  String get deliveryFail {
    return Intl.message('订单送达失败！', name: 'deliveryFail', desc: '', args: []);
  }

  /// `图片上传失败！`
  String get deliveryUploadFailed {
    return Intl.message(
      '图片上传失败！',
      name: 'deliveryUploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `手持机扫码送达`
  String get deliveryDeliver {
    return Intl.message('手持机扫码送达', name: 'deliveryDeliver', desc: '', args: []);
  }

  /// `请将条形码放入框内，即可自动扫描`
  String get pleaseScanTheBarcode {
    return Intl.message(
      '请将条形码放入框内，即可自动扫描',
      name: 'pleaseScanTheBarcode',
      desc: '',
      args: [],
    );
  }

  /// `获取数据失败`
  String get getSystemDataError {
    return Intl.message(
      '获取数据失败',
      name: 'getSystemDataError',
      desc: '',
      args: [],
    );
  }

  /// `报餐送餐`
  String get mealDelivery {
    return Intl.message('报餐送餐', name: 'mealDelivery', desc: '', args: []);
  }

  /// `绑定报餐送餐账号，获取报餐送餐系统权限功能信息`
  String get bindMealDeliveryAccount {
    return Intl.message(
      '绑定报餐送餐账号，获取报餐送餐系统权限功能信息',
      name: 'bindMealDeliveryAccount',
      desc: '',
      args: [],
    );
  }

  /// `绑定{name}账号`
  String bindAccount(Object name) {
    return Intl.message(
      '绑定$name账号',
      name: 'bindAccount',
      desc: '',
      args: [name],
    );
  }

  /// `请输入{name}账号`
  String pleaseEnterAccount(Object name) {
    return Intl.message(
      '请输入$name账号',
      name: 'pleaseEnterAccount',
      desc: '',
      args: [name],
    );
  }

  /// `账号`
  String get account {
    return Intl.message('账号', name: 'account', desc: '', args: []);
  }

  /// `请输入{name}密码`
  String pleaseEnterPassword(Object name) {
    return Intl.message(
      '请输入$name密码',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [name],
    );
  }

  /// `绑定`
  String get bind {
    return Intl.message('绑定', name: 'bind', desc: '', args: []);
  }

  /// `确定要解除{name}账号的绑定吗？`
  String confirmToUnbind(Object name) {
    return Intl.message(
      '确定要解除$name账号的绑定吗？',
      name: 'confirmToUnbind',
      desc: '',
      args: [name],
    );
  }

  /// `解除绑定`
  String get unbind {
    return Intl.message('解除绑定', name: 'unbind', desc: '', args: []);
  }

  /// `绑定成功`
  String get bindSuccess {
    return Intl.message('绑定成功', name: 'bindSuccess', desc: '', args: []);
  }

  /// `绑定失败`
  String get bindFail {
    return Intl.message('绑定失败', name: 'bindFail', desc: '', args: []);
  }

  /// `解除绑定成功`
  String get unbindSuccess {
    return Intl.message('解除绑定成功', name: 'unbindSuccess', desc: '', args: []);
  }

  /// `解除绑定失败`
  String get unbindFail {
    return Intl.message('解除绑定失败', name: 'unbindFail', desc: '', args: []);
  }

  /// `当前绑定: `
  String get currentBound {
    return Intl.message('当前绑定: ', name: 'currentBound', desc: '', args: []);
  }

  /// `绑定第三方账号`
  String get bindThirdPartyAccount {
    return Intl.message(
      '绑定第三方账号',
      name: 'bindThirdPartyAccount',
      desc: '',
      args: [],
    );
  }

  /// `已绑定`
  String get bound {
    return Intl.message('已绑定', name: 'bound', desc: '', args: []);
  }

  /// `未绑定`
  String get unbound {
    return Intl.message('未绑定', name: 'unbound', desc: '', args: []);
  }

  /// `打包方式`
  String get deliveryPackageType {
    return Intl.message(
      '打包方式',
      name: 'deliveryPackageType',
      desc: '',
      args: [],
    );
  }

  /// `奖励细则`
  String get reward_details {
    return Intl.message('奖励细则', name: 'reward_details', desc: '', args: []);
  }

  /// `关联帐号`
  String get related_account {
    return Intl.message('关联帐号', name: 'related_account', desc: '', args: []);
  }

  /// `图书馆`
  String get library {
    return Intl.message('图书馆', name: 'library', desc: '', args: []);
  }

  /// `请输入图书名称查询`
  String get library_search {
    return Intl.message(
      '请输入图书名称查询',
      name: 'library_search',
      desc: '',
      args: [],
    );
  }

  /// `地点筛选：`
  String get library_location {
    return Intl.message('地点筛选：', name: 'library_location', desc: '', args: []);
  }

  /// `园区外借室`
  String get library_location_0 {
    return Intl.message(
      '园区外借室',
      name: 'library_location_0',
      desc: '',
      args: [],
    );
  }

  /// `李白外借室`
  String get library_location_1 {
    return Intl.message(
      '李白外借室',
      name: 'library_location_1',
      desc: '',
      args: [],
    );
  }

  /// `H区外借室`
  String get library_location_2 {
    return Intl.message(
      'H区外借室',
      name: 'library_location_2',
      desc: '',
      args: [],
    );
  }

  /// `外借室`
  String get library_location_3 {
    return Intl.message('外借室', name: 'library_location_3', desc: '', args: []);
  }

  /// `全部地点`
  String get library_location_all {
    return Intl.message(
      '全部地点',
      name: 'library_location_all',
      desc: '',
      args: [],
    );
  }

  /// `图书`
  String get library_book {
    return Intl.message('图书', name: 'library_book', desc: '', args: []);
  }

  /// `未知图书`
  String get library_book_unknown {
    return Intl.message(
      '未知图书',
      name: 'library_book_unknown',
      desc: '',
      args: [],
    );
  }

  /// `图书详情`
  String get library_book_detail {
    return Intl.message(
      '图书详情',
      name: 'library_book_detail',
      desc: '',
      args: [],
    );
  }

  /// `作者`
  String get author {
    return Intl.message('作者', name: 'author', desc: '', args: []);
  }

  /// `出版社`
  String get publisher {
    return Intl.message('出版社', name: 'publisher', desc: '', args: []);
  }

  /// `出版日期`
  String get publication_date {
    return Intl.message('出版日期', name: 'publication_date', desc: '', args: []);
  }

  /// `图书信息`
  String get library_book_info {
    return Intl.message('图书信息', name: 'library_book_info', desc: '', args: []);
  }

  /// `条形码`
  String get barcode {
    return Intl.message('条形码', name: 'barcode', desc: '', args: []);
  }

  /// `图书编号`
  String get library_book_no {
    return Intl.message('图书编号', name: 'library_book_no', desc: '', args: []);
  }

  /// `版本`
  String get version {
    return Intl.message('版本', name: 'version', desc: '', args: []);
  }

  /// `尺寸`
  String get size {
    return Intl.message('尺寸', name: 'size', desc: '', args: []);
  }

  /// `类型编号`
  String get type_no {
    return Intl.message('类型编号', name: 'type_no', desc: '', args: []);
  }

  /// `批次`
  String get batch {
    return Intl.message('批次', name: 'batch', desc: '', args: []);
  }

  /// `价格`
  String get price {
    return Intl.message('价格', name: 'price', desc: '', args: []);
  }

  /// `备注信息`
  String get remark_info {
    return Intl.message('备注信息', name: 'remark_info', desc: '', args: []);
  }

  /// `借阅信息`
  String get borrow_info {
    return Intl.message('借阅信息', name: 'borrow_info', desc: '', args: []);
  }

  /// `存放地点`
  String get book_location {
    return Intl.message('存放地点', name: 'book_location', desc: '', args: []);
  }

  /// `馆藏时间`
  String get museum_date {
    return Intl.message('馆藏时间', name: 'museum_date', desc: '', args: []);
  }

  /// `管理员`
  String get admin {
    return Intl.message('管理员', name: 'admin', desc: '', args: []);
  }

  /// `更新时间`
  String get update_time {
    return Intl.message('更新时间', name: 'update_time', desc: '', args: []);
  }

  /// `好人好事`
  String get good_deeds {
    return Intl.message('好人好事', name: 'good_deeds', desc: '', args: []);
  }

  /// `我的发布`
  String get my_good_deeds {
    return Intl.message('我的发布', name: 'my_good_deeds', desc: '', args: []);
  }

  /// `搜索好人好事...`
  String get search_good_deeds {
    return Intl.message(
      '搜索好人好事...',
      name: 'search_good_deeds',
      desc: '',
      args: [],
    );
  }

  /// `未知标题`
  String get unknown_title {
    return Intl.message('未知标题', name: 'unknown_title', desc: '', args: []);
  }

  /// `联系方式`
  String get contact_info {
    return Intl.message('联系方式', name: 'contact_info', desc: '', args: []);
  }

  /// `好人好事详情`
  String get good_deeds_detail {
    return Intl.message(
      '好人好事详情',
      name: 'good_deeds_detail',
      desc: '',
      args: [],
    );
  }

  /// `详细描述`
  String get detailed_description {
    return Intl.message(
      '详细描述',
      name: 'detailed_description',
      desc: '',
      args: [],
    );
  }

  /// `暂无描述`
  String get no_description {
    return Intl.message('暂无描述', name: 'no_description', desc: '', args: []);
  }

  /// `个人信息`
  String get personal_info {
    return Intl.message('个人信息', name: 'personal_info', desc: '', args: []);
  }

  /// `已点赞`
  String get liked {
    return Intl.message('已点赞', name: 'liked', desc: '', args: []);
  }

  /// `发布好人好事`
  String get publish_good_deeds {
    return Intl.message(
      '发布好人好事',
      name: 'publish_good_deeds',
      desc: '',
      args: [],
    );
  }

  /// `分享您的好人好事`
  String get share_your_good_deeds {
    return Intl.message(
      '分享您的好人好事',
      name: 'share_your_good_deeds',
      desc: '',
      args: [],
    );
  }

  /// `记录身边的温暖瞬间，传递正能量`
  String get record_the_warm_moments_around_you {
    return Intl.message(
      '记录身边的温暖瞬间，传递正能量',
      name: 'record_the_warm_moments_around_you',
      desc: '',
      args: [],
    );
  }

  /// `基本信息`
  String get basic_info {
    return Intl.message('基本信息', name: 'basic_info', desc: '', args: []);
  }

  /// `标题`
  String get title {
    return Intl.message('标题', name: 'title', desc: '', args: []);
  }

  /// `请输入好人好事标题`
  String get please_enter_good_deeds_title {
    return Intl.message(
      '请输入好人好事标题',
      name: 'please_enter_good_deeds_title',
      desc: '',
      args: [],
    );
  }

  /// `标题至少需要2个字符`
  String get title_at_least_2_characters {
    return Intl.message(
      '标题至少需要2个字符',
      name: 'title_at_least_2_characters',
      desc: '',
      args: [],
    );
  }

  /// `描述内容`
  String get description_content {
    return Intl.message(
      '描述内容',
      name: 'description_content',
      desc: '',
      args: [],
    );
  }

  /// `请输入详细描述`
  String get please_enter_good_deeds_description {
    return Intl.message(
      '请输入详细描述',
      name: 'please_enter_good_deeds_description',
      desc: '',
      args: [],
    );
  }

  /// `描述至少需要10个字符`
  String get description_at_least_10_characters {
    return Intl.message(
      '描述至少需要10个字符',
      name: 'description_at_least_10_characters',
      desc: '',
      args: [],
    );
  }

  /// `好人姓名`
  String get good_name {
    return Intl.message('好人姓名', name: 'good_name', desc: '', args: []);
  }

  /// `请输入好人姓名`
  String get please_enter_good_deeds_name {
    return Intl.message(
      '请输入好人姓名',
      name: 'please_enter_good_deeds_name',
      desc: '',
      args: [],
    );
  }

  /// `请输入联系方式`
  String get please_enter_good_deeds_contact_info {
    return Intl.message(
      '请输入联系方式',
      name: 'please_enter_good_deeds_contact_info',
      desc: '',
      args: [],
    );
  }

  /// `重置`
  String get reset {
    return Intl.message('重置', name: 'reset', desc: '', args: []);
  }

  /// `提交中...`
  String get submitting {
    return Intl.message('提交中...', name: 'submitting', desc: '', args: []);
  }

  /// `确认重置`
  String get confirm_reset {
    return Intl.message('确认重置', name: 'confirm_reset', desc: '', args: []);
  }

  /// `确定要清空所有输入内容吗？`
  String get confirm_empty_all_input {
    return Intl.message(
      '确定要清空所有输入内容吗？',
      name: 'confirm_empty_all_input',
      desc: '',
      args: [],
    );
  }

  /// `已重置`
  String get reset_success {
    return Intl.message('已重置', name: 'reset_success', desc: '', args: []);
  }

  /// `发布成功，等待审核`
  String get publish_success_wait_for_audit {
    return Intl.message(
      '发布成功，等待审核',
      name: 'publish_success_wait_for_audit',
      desc: '',
      args: [],
    );
  }

  /// `发布失败`
  String get publish_failed {
    return Intl.message('发布失败', name: 'publish_failed', desc: '', args: []);
  }

  /// `回复反馈`
  String get reply_to_feedback {
    return Intl.message('回复反馈', name: 'reply_to_feedback', desc: '', args: []);
  }

  /// `未填写`
  String get not_filled {
    return Intl.message('未填写', name: 'not_filled', desc: '', args: []);
  }

  /// `回复内容`
  String get reply_content {
    return Intl.message('回复内容', name: 'reply_content', desc: '', args: []);
  }

  /// `待回复`
  String get reply_status {
    return Intl.message('待回复', name: 'reply_status', desc: '', args: []);
  }

  /// `已回复`
  String get replied {
    return Intl.message('已回复', name: 'replied', desc: '', args: []);
  }

  /// `回复时间`
  String get reply_time {
    return Intl.message('回复时间', name: 'reply_time', desc: '', args: []);
  }

  /// `暂无内容`
  String get no_content {
    return Intl.message('暂无内容', name: 'no_content', desc: '', args: []);
  }

  /// `我想吃`
  String get i_want_to_eat {
    return Intl.message('我想吃', name: 'i_want_to_eat', desc: '', args: []);
  }

  /// `我想说`
  String get i_want_to_say {
    return Intl.message('我想说', name: 'i_want_to_say', desc: '', args: []);
  }

  /// `反馈详情`
  String get feedback_detail {
    return Intl.message('反馈详情', name: 'feedback_detail', desc: '', args: []);
  }

  /// `反馈内容`
  String get feedback_content {
    return Intl.message('反馈内容', name: 'feedback_content', desc: '', args: []);
  }

  /// `未知时间`
  String get unknown_time {
    return Intl.message('未知时间', name: 'unknown_time', desc: '', args: []);
  }

  /// `刚刚`
  String get just_now {
    return Intl.message('刚刚', name: 'just_now', desc: '', args: []);
  }

  /// `小时前`
  String get hours_ago {
    return Intl.message('小时前', name: 'hours_ago', desc: '', args: []);
  }

  /// `天前`
  String get days_ago {
    return Intl.message('天前', name: 'days_ago', desc: '', args: []);
  }

  /// `分钟前`
  String get minutes_ago {
    return Intl.message('分钟前', name: 'minutes_ago', desc: '', args: []);
  }

  /// `提交失败`
  String get submit_failed {
    return Intl.message('提交失败', name: 'submit_failed', desc: '', args: []);
  }

  /// `处理状态`
  String get processing_status {
    return Intl.message('处理状态', name: 'processing_status', desc: '', args: []);
  }

  /// `回复人`
  String get reply_person {
    return Intl.message('回复人', name: 'reply_person', desc: '', args: []);
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
