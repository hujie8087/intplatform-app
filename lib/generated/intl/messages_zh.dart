// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(orderNo) => "报警单号：${orderNo}";

  static String m1(name) => "绑定${name}账号";

  static String m2(name) => "确定要解除${name}账号的绑定吗？";

  static String m3(title) => "删除${title}成功！";

  static String m4(count) => "共${count}人";

  static String m5(title) => "请输入${title}";

  static String m6(count) => "取餐成功，剩余${count}份包裹未取";

  static String m7(name) => "请输入${name}账号";

  static String m8(name) => "请输入${name}密码";

  static String m9(title) => "请填写${title}";

  static String m10(label) => "请输入${label}";

  static String m11(title) => "请选择${title}";

  static String m12(error) => "发送消息时出错: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "acceptOrder": MessageLookupByLibrary.simpleMessage("接单"),
        "acceptOrderFailed": MessageLookupByLibrary.simpleMessage("接单失败"),
        "acceptOrderSuccess": MessageLookupByLibrary.simpleMessage("接单成功"),
        "acceptTime": MessageLookupByLibrary.simpleMessage("接单时间"),
        "accommodationProcess": MessageLookupByLibrary.simpleMessage("住宿流程"),
        "account": MessageLookupByLibrary.simpleMessage("账号"),
        "actualPayment": MessageLookupByLibrary.simpleMessage("实付金额"),
        "addAddress": MessageLookupByLibrary.simpleMessage("新增地址"),
        "address": MessageLookupByLibrary.simpleMessage("地址"),
        "addressInfo": MessageLookupByLibrary.simpleMessage("地址信息"),
        "addressManagement": MessageLookupByLibrary.simpleMessage("地址管理"),
        "addressOutOfRange":
            MessageLookupByLibrary.simpleMessage("不在配送范围，请重新选择地址"),
        "admin": MessageLookupByLibrary.simpleMessage("管理员"),
        "alarm_failed": MessageLookupByLibrary.simpleMessage("报警失败"),
        "alarm_order_number": m0,
        "alarm_reported": MessageLookupByLibrary.simpleMessage("已报警"),
        "alarm_success": MessageLookupByLibrary.simpleMessage("报警成功"),
        "all": MessageLookupByLibrary.simpleMessage("全部"),
        "allRead": MessageLookupByLibrary.simpleMessage("全部已读"),
        "appTitle": MessageLookupByLibrary.simpleMessage("IWIP后勤综合服务"),
        "appVersion": MessageLookupByLibrary.simpleMessage("当前版本号"),
        "attachment": MessageLookupByLibrary.simpleMessage("附件"),
        "attention": MessageLookupByLibrary.simpleMessage("注意事项"),
        "auditRejected": MessageLookupByLibrary.simpleMessage("审核驳回"),
        "author": MessageLookupByLibrary.simpleMessage("作者"),
        "barcode": MessageLookupByLibrary.simpleMessage("条形码"),
        "basic_info": MessageLookupByLibrary.simpleMessage("基本信息"),
        "batch": MessageLookupByLibrary.simpleMessage("批次"),
        "bind": MessageLookupByLibrary.simpleMessage("绑定"),
        "bindAccount": m1,
        "bindFail": MessageLookupByLibrary.simpleMessage("绑定失败"),
        "bindMealDeliveryAccount":
            MessageLookupByLibrary.simpleMessage("绑定报餐送餐账号，获取报餐送餐系统权限功能信息"),
        "bindSuccess": MessageLookupByLibrary.simpleMessage("绑定成功"),
        "bindThirdPartyAccount":
            MessageLookupByLibrary.simpleMessage("绑定第三方账号"),
        "birthday": MessageLookupByLibrary.simpleMessage("生日"),
        "book_location": MessageLookupByLibrary.simpleMessage("存放地点"),
        "borrow_info": MessageLookupByLibrary.simpleMessage("借阅信息"),
        "bottleWater": MessageLookupByLibrary.simpleMessage("瓶装水"),
        "bound": MessageLookupByLibrary.simpleMessage("已绑定"),
        "breakfast": MessageLookupByLibrary.simpleMessage("早餐"),
        "busTimetable": MessageLookupByLibrary.simpleMessage("公交时刻表"),
        "busToday": MessageLookupByLibrary.simpleMessage("今日"),
        "businessHours": MessageLookupByLibrary.simpleMessage("营业时间"),
        "call_phone": MessageLookupByLibrary.simpleMessage("拨打电话"),
        "cameraPermissionDenied":
            MessageLookupByLibrary.simpleMessage("相机权限被永久拒绝，打开设置页面"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelDefault": MessageLookupByLibrary.simpleMessage("确定把该地址取消默认吗？"),
        "cancelOrder": MessageLookupByLibrary.simpleMessage("取消订单"),
        "cancelOrderFailed": MessageLookupByLibrary.simpleMessage("取消订单失败"),
        "cancelOrderSuccess": MessageLookupByLibrary.simpleMessage("取消订单成功"),
        "cardBalance": MessageLookupByLibrary.simpleMessage("卡余额"),
        "cardBill": MessageLookupByLibrary.simpleMessage("消费记录"),
        "cardDelete": MessageLookupByLibrary.simpleMessage("销卡"),
        "cardDep": MessageLookupByLibrary.simpleMessage("部门"),
        "cardFreeze": MessageLookupByLibrary.simpleMessage("冻结"),
        "cardInfo": MessageLookupByLibrary.simpleMessage("消费卡信息"),
        "cardLock": MessageLookupByLibrary.simpleMessage("锁卡"),
        "cardLockSuccess": MessageLookupByLibrary.simpleMessage("解锁成功"),
        "cardLoss": MessageLookupByLibrary.simpleMessage("挂失"),
        "cardLossSuccess": MessageLookupByLibrary.simpleMessage("挂失成功"),
        "cardName": MessageLookupByLibrary.simpleMessage("姓名"),
        "cardNumber": MessageLookupByLibrary.simpleMessage("卡号"),
        "cardPassword": MessageLookupByLibrary.simpleMessage("卡密码"),
        "cardPreDelete": MessageLookupByLibrary.simpleMessage("预销卡"),
        "cardStatus": MessageLookupByLibrary.simpleMessage("卡状态"),
        "cardType": MessageLookupByLibrary.simpleMessage("卡类型"),
        "cardValid": MessageLookupByLibrary.simpleMessage("有效"),
        "cart": MessageLookupByLibrary.simpleMessage("购物车"),
        "cartEmpty": MessageLookupByLibrary.simpleMessage("购物车是空的"),
        "changeAvatar": MessageLookupByLibrary.simpleMessage("点击更换头像"),
        "changeLanguage": MessageLookupByLibrary.simpleMessage("切换语言"),
        "changePassword": MessageLookupByLibrary.simpleMessage("修改密码"),
        "changeSuccess": MessageLookupByLibrary.simpleMessage("修改成功"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("切换主题"),
        "chat_sessions": MessageLookupByLibrary.simpleMessage("聊天会话"),
        "checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
        "checkout": MessageLookupByLibrary.simpleMessage("去结算"),
        "chineseFood": MessageLookupByLibrary.simpleMessage("中国餐"),
        "chooseRoute": MessageLookupByLibrary.simpleMessage("选择路线"),
        "cleaning_area": MessageLookupByLibrary.simpleMessage("清洁区域"),
        "cleaning_basic_info": MessageLookupByLibrary.simpleMessage("基本信息"),
        "cleaning_contacts": MessageLookupByLibrary.simpleMessage("联系人"),
        "cleaning_date": MessageLookupByLibrary.simpleMessage("预约日期"),
        "cleaning_deep_cleaning": MessageLookupByLibrary.simpleMessage("深度清洁"),
        "cleaning_evaluate": MessageLookupByLibrary.simpleMessage("评价"),
        "cleaning_loading": MessageLookupByLibrary.simpleMessage("加载中..."),
        "cleaning_order": MessageLookupByLibrary.simpleMessage("清洁订单"),
        "cleaning_order_create": MessageLookupByLibrary.simpleMessage("下单"),
        "cleaning_order_detail": MessageLookupByLibrary.simpleMessage("清洁订单详情"),
        "cleaning_order_evaluate": MessageLookupByLibrary.simpleMessage("评价订单"),
        "cleaning_order_evaluate_average":
            MessageLookupByLibrary.simpleMessage("一般"),
        "cleaning_order_evaluate_content":
            MessageLookupByLibrary.simpleMessage("评价内容"),
        "cleaning_order_evaluate_content_hint":
            MessageLookupByLibrary.simpleMessage("请输入您的评价内容（可选）"),
        "cleaning_order_evaluate_dissatisfied":
            MessageLookupByLibrary.simpleMessage("不满意"),
        "cleaning_order_evaluate_fail":
            MessageLookupByLibrary.simpleMessage("评价失败"),
        "cleaning_order_evaluate_satisfied":
            MessageLookupByLibrary.simpleMessage("满意"),
        "cleaning_order_evaluate_select_rating":
            MessageLookupByLibrary.simpleMessage("请选择评分"),
        "cleaning_order_evaluate_submit":
            MessageLookupByLibrary.simpleMessage("提交评价"),
        "cleaning_order_evaluate_success":
            MessageLookupByLibrary.simpleMessage("评价成功"),
        "cleaning_order_evaluate_title":
            MessageLookupByLibrary.simpleMessage("服务评分"),
        "cleaning_order_evaluate_very_dissatisfied":
            MessageLookupByLibrary.simpleMessage("非常不满意"),
        "cleaning_order_evaluate_very_satisfied":
            MessageLookupByLibrary.simpleMessage("非常满意"),
        "cleaning_order_handle": MessageLookupByLibrary.simpleMessage("处理"),
        "cleaning_order_number": MessageLookupByLibrary.simpleMessage("订单号"),
        "cleaning_order_pending": MessageLookupByLibrary.simpleMessage("待处理"),
        "cleaning_order_progress": MessageLookupByLibrary.simpleMessage("订单进度"),
        "cleaning_order_search":
            MessageLookupByLibrary.simpleMessage("请输入订单号或房间号查询"),
        "cleaning_order_status": MessageLookupByLibrary.simpleMessage("状态"),
        "cleaning_order_submit": MessageLookupByLibrary.simpleMessage("提交订单"),
        "cleaning_order_view": MessageLookupByLibrary.simpleMessage("查看"),
        "cleaning_other_info": MessageLookupByLibrary.simpleMessage("其他信息"),
        "cleaning_price": MessageLookupByLibrary.simpleMessage("价格"),
        "cleaning_project": MessageLookupByLibrary.simpleMessage("清洁项目"),
        "cleaning_remark": MessageLookupByLibrary.simpleMessage("备注"),
        "cleaning_remark_hint":
            MessageLookupByLibrary.simpleMessage("请输入特殊要求或备注信息（可选）"),
        "cleaning_room_number": MessageLookupByLibrary.simpleMessage("房间号"),
        "cleaning_search": MessageLookupByLibrary.simpleMessage("搜索"),
        "cleaning_select_address":
            MessageLookupByLibrary.simpleMessage("请选择清洁地址"),
        "cleaning_select_address_error":
            MessageLookupByLibrary.simpleMessage("清洁地址不在清洁项目对应的区域，请重新选择！"),
        "cleaning_select_cleaning_project":
            MessageLookupByLibrary.simpleMessage("选择清洁项目"),
        "cleaning_select_date": MessageLookupByLibrary.simpleMessage("请选择预约日期"),
        "cleaning_service_detail": MessageLookupByLibrary.simpleMessage("服务详情"),
        "cleaning_special_cleaning":
            MessageLookupByLibrary.simpleMessage("专项清洁"),
        "cleaning_submit": MessageLookupByLibrary.simpleMessage("提交清洁服务"),
        "cleaning_tel": MessageLookupByLibrary.simpleMessage("联系电话"),
        "clear": MessageLookupByLibrary.simpleMessage("清空"),
        "clearCart": MessageLookupByLibrary.simpleMessage("清空购物车"),
        "clearCartTips": MessageLookupByLibrary.simpleMessage("确定要清空购物车吗？"),
        "clickConfirmButtonToViewUnreceivedOrders":
            MessageLookupByLibrary.simpleMessage("点击确认按钮查看未接收订单"),
        "clickRetry": MessageLookupByLibrary.simpleMessage("点击重试"),
        "click_to_start_dialog": MessageLookupByLibrary.simpleMessage("点击开始对话"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "companyNews": MessageLookupByLibrary.simpleMessage("公司动态"),
        "completed": MessageLookupByLibrary.simpleMessage("已完结"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "confirmDelete": MessageLookupByLibrary.simpleMessage("确认删除"),
        "confirmDeleteContent":
            MessageLookupByLibrary.simpleMessage("确定删除该条信息吗？删除后无法恢复！"),
        "confirmDelivery": MessageLookupByLibrary.simpleMessage("确认收货"),
        "confirmDeliveryContent":
            MessageLookupByLibrary.simpleMessage("确认收货后，订单将无法修改，请确认是否收货？"),
        "confirmModify": MessageLookupByLibrary.simpleMessage("确认修改"),
        "confirmPassword": MessageLookupByLibrary.simpleMessage("请再次输入密码"),
        "confirmPublish": MessageLookupByLibrary.simpleMessage("确认发布"),
        "confirmReceive": MessageLookupByLibrary.simpleMessage("确认领取"),
        "confirmReceiveContent":
            MessageLookupByLibrary.simpleMessage("确定领取该物品吗？"),
        "confirmSubmit": MessageLookupByLibrary.simpleMessage("确认提交"),
        "confirmSubmitContent":
            MessageLookupByLibrary.simpleMessage("确定要提交订单吗？"),
        "confirmToUnbind": m2,
        "confirm_empty_all_input":
            MessageLookupByLibrary.simpleMessage("确定要清空所有输入内容吗？"),
        "confirm_end_alarm": MessageLookupByLibrary.simpleMessage("确定要结束报警吗？"),
        "confirm_reset": MessageLookupByLibrary.simpleMessage("确认重置"),
        "connecting_customer_service":
            MessageLookupByLibrary.simpleMessage("正在连接客服..."),
        "contact": MessageLookupByLibrary.simpleMessage("联系Ta"),
        "contactNumber": MessageLookupByLibrary.simpleMessage("联系电话"),
        "contactPerson": MessageLookupByLibrary.simpleMessage("联系人"),
        "contactPhone": MessageLookupByLibrary.simpleMessage("联系电话"),
        "contactPhoneNotEmpty":
            MessageLookupByLibrary.simpleMessage("联系电话不能为空"),
        "contactUs": MessageLookupByLibrary.simpleMessage("联系我们"),
        "contact_info": MessageLookupByLibrary.simpleMessage("联系方式"),
        "contentUpdating":
            MessageLookupByLibrary.simpleMessage("内容待更新，敬请期待..."),
        "copySuccess": MessageLookupByLibrary.simpleMessage("复制成功"),
        "coupleRoom": MessageLookupByLibrary.simpleMessage("客房"),
        "coupleRoom_feedback": MessageLookupByLibrary.simpleMessage("客房反馈"),
        "coupleRoom_feedback_content":
            MessageLookupByLibrary.simpleMessage("反馈内容"),
        "coupleRoom_feedback_other": MessageLookupByLibrary.simpleMessage("其他"),
        "coupleRoom_feedback_room":
            MessageLookupByLibrary.simpleMessage("房间问题"),
        "coupleRoom_feedback_submit":
            MessageLookupByLibrary.simpleMessage("提交"),
        "coupleRoom_feedback_submit_fail":
            MessageLookupByLibrary.simpleMessage("提交失败"),
        "coupleRoom_feedback_submit_success":
            MessageLookupByLibrary.simpleMessage("提交成功"),
        "coupleRoom_feedback_system":
            MessageLookupByLibrary.simpleMessage("系统问题"),
        "coupleRoom_feedback_type":
            MessageLookupByLibrary.simpleMessage("反馈类型"),
        "coupleRoom_room_all": MessageLookupByLibrary.simpleMessage("全部"),
        "coupleRoom_room_approved": MessageLookupByLibrary.simpleMessage("已通过"),
        "coupleRoom_room_audit_info":
            MessageLookupByLibrary.simpleMessage("审核信息"),
        "coupleRoom_room_audit_remark":
            MessageLookupByLibrary.simpleMessage("审核说明"),
        "coupleRoom_room_audit_staff":
            MessageLookupByLibrary.simpleMessage("审核人员"),
        "coupleRoom_room_audit_status":
            MessageLookupByLibrary.simpleMessage("审核状态"),
        "coupleRoom_room_audit_status_pass":
            MessageLookupByLibrary.simpleMessage("通过"),
        "coupleRoom_room_audit_status_reject":
            MessageLookupByLibrary.simpleMessage("拒绝"),
        "coupleRoom_room_audit_time":
            MessageLookupByLibrary.simpleMessage("审核时间"),
        "coupleRoom_room_available":
            MessageLookupByLibrary.simpleMessage("可预订"),
        "coupleRoom_room_available_days":
            MessageLookupByLibrary.simpleMessage("可预订天数"),
        "coupleRoom_room_booking": MessageLookupByLibrary.simpleMessage("客房预订"),
        "coupleRoom_room_booking_body":
            MessageLookupByLibrary.simpleMessage("您有新的客房预订，请及时确认订单"),
        "coupleRoom_room_booking_book":
            MessageLookupByLibrary.simpleMessage("预订"),
        "coupleRoom_room_booking_book_fail":
            MessageLookupByLibrary.simpleMessage("预订失败"),
        "coupleRoom_room_booking_book_success":
            MessageLookupByLibrary.simpleMessage("预订成功"),
        "coupleRoom_room_booking_confirm":
            MessageLookupByLibrary.simpleMessage("确定"),
        "coupleRoom_room_booking_remark":
            MessageLookupByLibrary.simpleMessage("备注"),
        "coupleRoom_room_booking_search":
            MessageLookupByLibrary.simpleMessage("请输入房间号查询"),
        "coupleRoom_room_booking_select_date":
            MessageLookupByLibrary.simpleMessage("请选择入住日期（可多选，必须连续）"),
        "coupleRoom_room_booking_submit":
            MessageLookupByLibrary.simpleMessage("提交"),
        "coupleRoom_room_booking_submit_fail":
            MessageLookupByLibrary.simpleMessage("提交失败"),
        "coupleRoom_room_booking_submit_success":
            MessageLookupByLibrary.simpleMessage("提交成功"),
        "coupleRoom_room_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "coupleRoom_room_cancel_order":
            MessageLookupByLibrary.simpleMessage("取消预约"),
        "coupleRoom_room_cancel_order_confirm":
            MessageLookupByLibrary.simpleMessage("确定取消预约吗？"),
        "coupleRoom_room_cancel_order_success":
            MessageLookupByLibrary.simpleMessage("取消预约成功"),
        "coupleRoom_room_canceled": MessageLookupByLibrary.simpleMessage("已取消"),
        "coupleRoom_room_check_in_date":
            MessageLookupByLibrary.simpleMessage("请选择入住日期"),
        "coupleRoom_room_check_in_time":
            MessageLookupByLibrary.simpleMessage("可入住时间"),
        "coupleRoom_room_check_out_time":
            MessageLookupByLibrary.simpleMessage("退房时间"),
        "coupleRoom_room_confirm_content":
            MessageLookupByLibrary.simpleMessage("确定确认订单吗？"),
        "coupleRoom_room_confirm_fail":
            MessageLookupByLibrary.simpleMessage("确认订单失败"),
        "coupleRoom_room_confirm_order":
            MessageLookupByLibrary.simpleMessage("确认订单"),
        "coupleRoom_room_confirm_success":
            MessageLookupByLibrary.simpleMessage("确认订单成功"),
        "coupleRoom_room_days": MessageLookupByLibrary.simpleMessage("天"),
        "coupleRoom_room_info": MessageLookupByLibrary.simpleMessage("客房信息"),
        "coupleRoom_room_number": MessageLookupByLibrary.simpleMessage("房间编号"),
        "coupleRoom_room_order": MessageLookupByLibrary.simpleMessage("客房订单"),
        "coupleRoom_room_order_cancel_fail":
            MessageLookupByLibrary.simpleMessage("取消预约失败"),
        "coupleRoom_room_order_cancel_success":
            MessageLookupByLibrary.simpleMessage("您的客房预订已取消，请重新预订"),
        "coupleRoom_room_order_create_time":
            MessageLookupByLibrary.simpleMessage("下单时间"),
        "coupleRoom_room_order_detail":
            MessageLookupByLibrary.simpleMessage("订单详情"),
        "coupleRoom_room_order_end_time":
            MessageLookupByLibrary.simpleMessage("退房时间"),
        "coupleRoom_room_order_price":
            MessageLookupByLibrary.simpleMessage("总费用"),
        "coupleRoom_room_order_search":
            MessageLookupByLibrary.simpleMessage("请输入房间号查询"),
        "coupleRoom_room_order_start_time":
            MessageLookupByLibrary.simpleMessage("入住时间"),
        "coupleRoom_room_pending": MessageLookupByLibrary.simpleMessage("待审核"),
        "coupleRoom_room_price": MessageLookupByLibrary.simpleMessage("单价"),
        "coupleRoom_room_price_unit":
            MessageLookupByLibrary.simpleMessage("KRP/天"),
        "coupleRoom_room_rejected": MessageLookupByLibrary.simpleMessage("已拒绝"),
        "coupleRoom_room_search": MessageLookupByLibrary.simpleMessage("搜索"),
        "coupleRoom_room_staff_dept":
            MessageLookupByLibrary.simpleMessage("部门"),
        "coupleRoom_room_staff_info":
            MessageLookupByLibrary.simpleMessage("员工信息"),
        "coupleRoom_room_staff_job":
            MessageLookupByLibrary.simpleMessage("岗位/服务"),
        "coupleRoom_room_staff_name":
            MessageLookupByLibrary.simpleMessage("姓名"),
        "coupleRoom_room_staff_sex": MessageLookupByLibrary.simpleMessage("性别"),
        "coupleRoom_room_staff_tel": MessageLookupByLibrary.simpleMessage("电话"),
        "coupleRoom_room_staff_username":
            MessageLookupByLibrary.simpleMessage("工号"),
        "coupleRoom_room_view": MessageLookupByLibrary.simpleMessage("查看"),
        "createTime": MessageLookupByLibrary.simpleMessage("下单时间"),
        "currentBound": MessageLookupByLibrary.simpleMessage("当前绑定: "),
        "currentVersionIsLatest":
            MessageLookupByLibrary.simpleMessage("当前版本已是最新版本"),
        "current_position": MessageLookupByLibrary.simpleMessage("当前位置"),
        "current_position_failed":
            MessageLookupByLibrary.simpleMessage("当前位置获取失败,请检查定位权限"),
        "customer_service": MessageLookupByLibrary.simpleMessage("客服"),
        "dangerPage": MessageLookupByLibrary.simpleMessage("发现隐患"),
        "days_ago": MessageLookupByLibrary.simpleMessage("天前"),
        "defaultValue": MessageLookupByLibrary.simpleMessage("默认"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteAddress": MessageLookupByLibrary.simpleMessage("确定删除地址吗？"),
        "deleteOrder": MessageLookupByLibrary.simpleMessage("删除订单"),
        "deleteRepair": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteRepairSuccess": MessageLookupByLibrary.simpleMessage("删除报修单成功"),
        "deleteRepairTips": MessageLookupByLibrary.simpleMessage("确认删除该报修单吗?"),
        "deleteSuccess": m3,
        "deliver": MessageLookupByLibrary.simpleMessage("送达"),
        "deliverFailed": MessageLookupByLibrary.simpleMessage("送达失败"),
        "deliverFailedTips":
            MessageLookupByLibrary.simpleMessage("确认取消送达该订单吗？"),
        "deliverSuccess": MessageLookupByLibrary.simpleMessage("送达成功"),
        "deliverSuccessTips": MessageLookupByLibrary.simpleMessage("您的订单已送达"),
        "deliverTime": MessageLookupByLibrary.simpleMessage("送达时间"),
        "delivered": MessageLookupByLibrary.simpleMessage("已送达"),
        "delivering": MessageLookupByLibrary.simpleMessage("配送中"),
        "delivery": MessageLookupByLibrary.simpleMessage("配送"),
        "deliveryAddress": MessageLookupByLibrary.simpleMessage("配送地址"),
        "deliveryAuditRejected": MessageLookupByLibrary.simpleMessage("审核驳回"),
        "deliveryAudited": MessageLookupByLibrary.simpleMessage("审核通过"),
        "deliveryBag": MessageLookupByLibrary.simpleMessage("打包袋"),
        "deliveryBindAccount": MessageLookupByLibrary.simpleMessage("绑定帐号"),
        "deliveryBoxedMeal": MessageLookupByLibrary.simpleMessage("盒装饭"),
        "deliveryBucket": MessageLookupByLibrary.simpleMessage("桶装"),
        "deliveryCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "deliveryCancelled": MessageLookupByLibrary.simpleMessage("已退单"),
        "deliveryConfirm": MessageLookupByLibrary.simpleMessage("确定"),
        "deliveryCooking": MessageLookupByLibrary.simpleMessage("配餐中"),
        "deliveryCreateOrder": MessageLookupByLibrary.simpleMessage("创建订单"),
        "deliveryDeliver": MessageLookupByLibrary.simpleMessage("手持机扫码送达"),
        "deliveryDeliverOrder": MessageLookupByLibrary.simpleMessage("开始配送"),
        "deliveryDeliverOrderFail":
            MessageLookupByLibrary.simpleMessage("开始配送失败"),
        "deliveryDelivered": MessageLookupByLibrary.simpleMessage("已送达"),
        "deliveryDelivering": MessageLookupByLibrary.simpleMessage("送餐中"),
        "deliveryDept": MessageLookupByLibrary.simpleMessage("部门"),
        "deliveryDeptName": MessageLookupByLibrary.simpleMessage("部门名称"),
        "deliveryEmail": MessageLookupByLibrary.simpleMessage("邮箱"),
        "deliveryException": MessageLookupByLibrary.simpleMessage("异常原因"),
        "deliveryFail": MessageLookupByLibrary.simpleMessage("订单送达失败！"),
        "deliveryFee": MessageLookupByLibrary.simpleMessage("配送费"),
        "deliveryGetMealPlace":
            MessageLookupByLibrary.simpleMessage("获取送餐地点数据中..."),
        "deliveryGetMealPlaceFail":
            MessageLookupByLibrary.simpleMessage("获取送餐地点数据失败"),
        "deliveryGetPersonList": MessageLookupByLibrary.simpleMessage("获取人员列表"),
        "deliveryGetPersonListFail":
            MessageLookupByLibrary.simpleMessage("获取人员列表失败"),
        "deliveryInfo": MessageLookupByLibrary.simpleMessage("查看配送信息"),
        "deliveryJobNumber": MessageLookupByLibrary.simpleMessage("工号"),
        "deliveryLoading": MessageLookupByLibrary.simpleMessage("加载中..."),
        "deliveryMealBox": MessageLookupByLibrary.simpleMessage("餐盒"),
        "deliveryName": MessageLookupByLibrary.simpleMessage("配送员"),
        "deliveryNotAudited": MessageLookupByLibrary.simpleMessage("未审核"),
        "deliveryNotStarted": MessageLookupByLibrary.simpleMessage("未开始配送"),
        "deliveryOrder": MessageLookupByLibrary.simpleMessage("配送订单"),
        "deliveryOrderAvailable":
            MessageLookupByLibrary.simpleMessage("今日可选餐次"),
        "deliveryOrderCompleted": MessageLookupByLibrary.simpleMessage("订单已完成"),
        "deliveryOrderDetail": MessageLookupByLibrary.simpleMessage("配送订单详情"),
        "deliveryOrderList": MessageLookupByLibrary.simpleMessage("订单列表"),
        "deliveryOrderNo": MessageLookupByLibrary.simpleMessage("配送单号"),
        "deliveryOrderNoPermission":
            MessageLookupByLibrary.simpleMessage("暂无订餐权限，联系部门文员"),
        "deliveryOrderNotAvailable":
            MessageLookupByLibrary.simpleMessage("当前时间不可预订"),
        "deliveryOrderNotBindAccount":
            MessageLookupByLibrary.simpleMessage("未绑定报餐送餐帐号，请先绑定帐号"),
        "deliveryOrderPlaced": MessageLookupByLibrary.simpleMessage("已下单"),
        "deliveryOrderStatus": MessageLookupByLibrary.simpleMessage("订单状态"),
        "deliveryOrderSubmit": MessageLookupByLibrary.simpleMessage("点击预订"),
        "deliveryOrderSubmitFail":
            MessageLookupByLibrary.simpleMessage("订单提交失败"),
        "deliveryOrderSuccess": MessageLookupByLibrary.simpleMessage("订单提交成功！"),
        "deliveryOrderTemporary":
            MessageLookupByLibrary.simpleMessage("临时人员订餐"),
        "deliveryOrderTips": MessageLookupByLibrary.simpleMessage(
            "温馨提示：请根据用餐时间选择合适的餐食类型，订单提交后不可更改"),
        "deliveryOrderTitle": MessageLookupByLibrary.simpleMessage("今日订餐"),
        "deliveryOrderType": MessageLookupByLibrary.simpleMessage("订单种类"),
        "deliveryPackOrderFail": MessageLookupByLibrary.simpleMessage("打包失败"),
        "deliveryPackage": MessageLookupByLibrary.simpleMessage("打包"),
        "deliveryPackageType": MessageLookupByLibrary.simpleMessage("打包方式"),
        "deliveryPacked": MessageLookupByLibrary.simpleMessage("已打包"),
        "deliveryPackedMeal": MessageLookupByLibrary.simpleMessage("打包饭"),
        "deliveryPhone": MessageLookupByLibrary.simpleMessage("配送电话"),
        "deliveryPhoto": MessageLookupByLibrary.simpleMessage("送达照片"),
        "deliveryPost": MessageLookupByLibrary.simpleMessage("职位"),
        "deliveryQuantity": MessageLookupByLibrary.simpleMessage("份数"),
        "deliveryReject": MessageLookupByLibrary.simpleMessage("驳回"),
        "deliveryRejectFail": MessageLookupByLibrary.simpleMessage("驳回失败"),
        "deliveryRejectReason": MessageLookupByLibrary.simpleMessage("驳回原因"),
        "deliveryRejectSuccess": MessageLookupByLibrary.simpleMessage("驳回成功"),
        "deliveryReset": MessageLookupByLibrary.simpleMessage("重置"),
        "deliveryReturnOrder": MessageLookupByLibrary.simpleMessage("退单"),
        "deliveryReturnOrderConfirm":
            MessageLookupByLibrary.simpleMessage("确定退单吗？"),
        "deliveryReturnOrderFail": MessageLookupByLibrary.simpleMessage("退单失败"),
        "deliveryReturnOrderSuccess":
            MessageLookupByLibrary.simpleMessage("退单成功"),
        "deliverySearchOrder":
            MessageLookupByLibrary.simpleMessage("通过配送地点或订单编号搜索"),
        "deliverySearchPerson": MessageLookupByLibrary.simpleMessage("按姓名搜索"),
        "deliverySelectMealType": MessageLookupByLibrary.simpleMessage("请选择餐种"),
        "deliverySelectPerson": MessageLookupByLibrary.simpleMessage("请选择人员"),
        "deliverySelectPlace": MessageLookupByLibrary.simpleMessage("请选择送餐地点"),
        "deliverySelectTeam": MessageLookupByLibrary.simpleMessage("选择车队"),
        "deliverySelectTeamFail":
            MessageLookupByLibrary.simpleMessage("获取车队失败"),
        "deliverySelectTime": MessageLookupByLibrary.simpleMessage("请选择送餐时间"),
        "deliverySelectedConditions":
            MessageLookupByLibrary.simpleMessage("已选条件:"),
        "deliverySelectedPeople": MessageLookupByLibrary.simpleMessage("已选择人员"),
        "deliveryStartDelivery": MessageLookupByLibrary.simpleMessage("开始配送"),
        "deliverySubmit": MessageLookupByLibrary.simpleMessage("提交"),
        "deliverySubmitOrder": MessageLookupByLibrary.simpleMessage("订餐配送"),
        "deliverySubmitOrderFail": MessageLookupByLibrary.simpleMessage("提交失败"),
        "deliverySubmitOrderSuccess":
            MessageLookupByLibrary.simpleMessage("提交成功"),
        "deliverySubmitStatus": MessageLookupByLibrary.simpleMessage("提交状态"),
        "deliverySuccess": MessageLookupByLibrary.simpleMessage("订单送达成功！"),
        "deliveryTel": MessageLookupByLibrary.simpleMessage("联系电话"),
        "deliveryTime": MessageLookupByLibrary.simpleMessage("配送时间"),
        "deliveryTotal": m4,
        "deliveryType": MessageLookupByLibrary.simpleMessage("配送方式"),
        "deliveryUploadFailed": MessageLookupByLibrary.simpleMessage("图片上传失败！"),
        "deliveryUploading": MessageLookupByLibrary.simpleMessage("图片上传中..."),
        "deliveryWaterService": MessageLookupByLibrary.simpleMessage("订水服务"),
        "deliveryWaterServiceTips":
            MessageLookupByLibrary.simpleMessage("选择配送站点和数量，我们将为您提供优质的饮用水服务"),
        "delivery_canteen": MessageLookupByLibrary.simpleMessage("配送食堂"),
        "delivery_site": MessageLookupByLibrary.simpleMessage("配送站点"),
        "delivery_site_search":
            MessageLookupByLibrary.simpleMessage("请输入配送站点名称查询"),
        "delivery_site_search_clear_confirm":
            MessageLookupByLibrary.simpleMessage("确定清除搜索内容吗？"),
        "delivery_site_search_not_found":
            MessageLookupByLibrary.simpleMessage("未找到匹配的配送站点"),
        "delivery_site_search_placeholder":
            MessageLookupByLibrary.simpleMessage("请输入配送站点名称查询"),
        "departmentSubmitted": MessageLookupByLibrary.simpleMessage("部门已提交"),
        "dept": MessageLookupByLibrary.simpleMessage("部门"),
        "description_at_least_10_characters":
            MessageLookupByLibrary.simpleMessage("描述至少需要10个字符"),
        "description_content": MessageLookupByLibrary.simpleMessage("描述内容"),
        "dessert": MessageLookupByLibrary.simpleMessage("点心"),
        "detailed_description": MessageLookupByLibrary.simpleMessage("详细描述"),
        "diningIn": MessageLookupByLibrary.simpleMessage("堂食"),
        "diningService": MessageLookupByLibrary.simpleMessage("订餐服务"),
        "diningTime": MessageLookupByLibrary.simpleMessage("订餐时间"),
        "dinner": MessageLookupByLibrary.simpleMessage("晚餐"),
        "direction": MessageLookupByLibrary.simpleMessage("方向"),
        "dishMethod": MessageLookupByLibrary.simpleMessage("菜的做法"),
        "dishName": MessageLookupByLibrary.simpleMessage("菜名"),
        "dishSuggestion": MessageLookupByLibrary.simpleMessage("菜品建议"),
        "dishes": MessageLookupByLibrary.simpleMessage("道菜"),
        "dragHereToRemove": MessageLookupByLibrary.simpleMessage("拖动此处删除"),
        "dragRemoveImage": MessageLookupByLibrary.simpleMessage("拖动删除图片"),
        "duplicateOrderReception":
            MessageLookupByLibrary.simpleMessage("重复接收订单"),
        "earlyTea": MessageLookupByLibrary.simpleMessage("早茶"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "editToBeAuditedMessage":
            MessageLookupByLibrary.simpleMessage("修改成功，等待审核"),
        "email": MessageLookupByLibrary.simpleMessage("邮箱"),
        "emergency_alarm_session":
            MessageLookupByLibrary.simpleMessage("紧急报警会话"),
        "emergency_alarm_system":
            MessageLookupByLibrary.simpleMessage("紧急报警系统"),
        "emergency_alarm_tips": MessageLookupByLibrary.simpleMessage(
            "遇到紧急情况请立即按下报警按钮\n安全团队将在第一时间为您提供帮助"),
        "emergency_chat": MessageLookupByLibrary.simpleMessage("紧急聊天"),
        "employeeNumber": MessageLookupByLibrary.simpleMessage("工号"),
        "en": MessageLookupByLibrary.simpleMessage("English"),
        "endDate": MessageLookupByLibrary.simpleMessage("结束日期"),
        "endOfList": MessageLookupByLibrary.simpleMessage("已经到底啦"),
        "endStation": MessageLookupByLibrary.simpleMessage("终点站"),
        "end_alarm": MessageLookupByLibrary.simpleMessage("结束报警"),
        "enterNewPasswordAgin":
            MessageLookupByLibrary.simpleMessage("请再次输入新密码"),
        "error_occurred_when_connecting_customer_service":
            MessageLookupByLibrary.simpleMessage("连接客服时发生错误"),
        "evaluate": MessageLookupByLibrary.simpleMessage("评价"),
        "evaluated": MessageLookupByLibrary.simpleMessage("已评价"),
        "evaluation": MessageLookupByLibrary.simpleMessage("评价"),
        "exceedStock": MessageLookupByLibrary.simpleMessage("超出库存"),
        "exception": MessageLookupByLibrary.simpleMessage("配送异常"),
        "exitManage": MessageLookupByLibrary.simpleMessage("退出管理"),
        "expenditure": MessageLookupByLibrary.simpleMessage("支出"),
        "faceCollection": MessageLookupByLibrary.simpleMessage("人脸采集"),
        "faceCollectionTips":
            MessageLookupByLibrary.simpleMessage("消费卡人脸识别可用于园区内刷脸消费。"),
        "faceCollectionTips1":
            MessageLookupByLibrary.simpleMessage("1. 人脸正面免冠照，露出眉毛和眼睛"),
        "faceCollectionTips2":
            MessageLookupByLibrary.simpleMessage("2. 照片白底、无逆光、无ps、无过渡美颜处理"),
        "faceCollectionTips3":
            MessageLookupByLibrary.simpleMessage("3. 建议用高清像素手机拍摄"),
        "faceCollectionTips4":
            MessageLookupByLibrary.simpleMessage("4. 图片大小:40k~200k"),
        "faceCollectionTips5": MessageLookupByLibrary.simpleMessage(
            "5. 多次上传未能通过照片审核的用户，可持工卡在工作时间到卡务柜台办理"),
        "faceCollectionTipsTitle":
            MessageLookupByLibrary.simpleMessage("采集标准要求说明"),
        "failed_to_create_chat_session":
            MessageLookupByLibrary.simpleMessage("无法创建聊天会话"),
        "failed_to_reconnect_to_server":
            MessageLookupByLibrary.simpleMessage("无法重新连接到服务器"),
        "feedback": MessageLookupByLibrary.simpleMessage("留言反馈"),
        "feedbackContent": MessageLookupByLibrary.simpleMessage("留言内容"),
        "feedbackTitle": MessageLookupByLibrary.simpleMessage("留言标题"),
        "feedback_content": MessageLookupByLibrary.simpleMessage("反馈内容"),
        "feedback_detail": MessageLookupByLibrary.simpleMessage("反馈详情"),
        "firstLoginTips":
            MessageLookupByLibrary.simpleMessage("为了您的资金安全，首次登录请您尽快修改密码！"),
        "firstTripTime": MessageLookupByLibrary.simpleMessage("首班车"),
        "fixed": MessageLookupByLibrary.simpleMessage("已修复"),
        "foodNameChooseError": MessageLookupByLibrary.simpleMessage("餐次名称不匹配"),
        "foodRecommend": MessageLookupByLibrary.simpleMessage("美食推荐"),
        "foodType": MessageLookupByLibrary.simpleMessage("餐种"),
        "food_menu": MessageLookupByLibrary.simpleMessage("今日菜谱"),
        "forgetPassword": MessageLookupByLibrary.simpleMessage("忘记密码？"),
        "found": MessageLookupByLibrary.simpleMessage("招领"),
        "foundItem": MessageLookupByLibrary.simpleMessage("招领"),
        "foundItemList": MessageLookupByLibrary.simpleMessage("招领列表"),
        "gender": MessageLookupByLibrary.simpleMessage("性别"),
        "getSystemDataError": MessageLookupByLibrary.simpleMessage("获取数据失败"),
        "goodHeartedColleague": MessageLookupByLibrary.simpleMessage("好心同事"),
        "good_deeds": MessageLookupByLibrary.simpleMessage("好人好事"),
        "good_deeds_detail": MessageLookupByLibrary.simpleMessage("好人好事详情"),
        "good_name": MessageLookupByLibrary.simpleMessage("好人姓名"),
        "goodsInfo": MessageLookupByLibrary.simpleMessage("商品信息"),
        "goodsTotal": MessageLookupByLibrary.simpleMessage("商品总额"),
        "groupNotSubmitted": MessageLookupByLibrary.simpleMessage("班组未提交"),
        "groupSubmitted": MessageLookupByLibrary.simpleMessage("班组已提交"),
        "hazard_description": MessageLookupByLibrary.simpleMessage("隐患描述"),
        "hazard_location": MessageLookupByLibrary.simpleMessage("发现地点"),
        "hazard_name": MessageLookupByLibrary.simpleMessage("隐患名称"),
        "hazard_photo": MessageLookupByLibrary.simpleMessage("隐患照片"),
        "hazard_submit": MessageLookupByLibrary.simpleMessage("提交"),
        "head": MessageLookupByLibrary.simpleMessage("负责人"),
        "hello": MessageLookupByLibrary.simpleMessage("你好"),
        "homePage": MessageLookupByLibrary.simpleMessage("首页"),
        "hour_response": MessageLookupByLibrary.simpleMessage("24小时响应"),
        "hours_ago": MessageLookupByLibrary.simpleMessage("小时前"),
        "iWantToEat": MessageLookupByLibrary.simpleMessage("我想吃"),
        "i_want_to_eat": MessageLookupByLibrary.simpleMessage("我想吃"),
        "i_want_to_say": MessageLookupByLibrary.simpleMessage("我想说"),
        "id": MessageLookupByLibrary.simpleMessage("Indonesia"),
        "idCard": MessageLookupByLibrary.simpleMessage("身份证号"),
        "idCardTips":
            MessageLookupByLibrary.simpleMessage("身份证号可用于找回密码，请尽快绑定！"),
        "imageUploading": MessageLookupByLibrary.simpleMessage("图片上传中..."),
        "images": MessageLookupByLibrary.simpleMessage("张图片"),
        "indonesianFood": MessageLookupByLibrary.simpleMessage("印尼餐"),
        "information": MessageLookupByLibrary.simpleMessage("资讯类"),
        "inputConfirmPassword":
            MessageLookupByLibrary.simpleMessage("请再次输入新密码"),
        "inputDifferentPassword":
            MessageLookupByLibrary.simpleMessage("输入的两次密码不同"),
        "inputIdCard": MessageLookupByLibrary.simpleMessage("请输入您的身份证号"),
        "inputMessage": m5,
        "inputNewPassword": MessageLookupByLibrary.simpleMessage("请输入新密码"),
        "inputOldPassword": MessageLookupByLibrary.simpleMessage("请输入旧密码"),
        "inputOrderName": MessageLookupByLibrary.simpleMessage("请输入订单姓名"),
        "inputOrderNo": MessageLookupByLibrary.simpleMessage("请输入订单编号"),
        "inputPasswordError": MessageLookupByLibrary.simpleMessage("请输入6位支付密码"),
        "inputWorkNumber": MessageLookupByLibrary.simpleMessage("请输入您的工号"),
        "isDefault": MessageLookupByLibrary.simpleMessage("是否默认"),
        "itemName": MessageLookupByLibrary.simpleMessage("物品名称"),
        "items": MessageLookupByLibrary.simpleMessage("件"),
        "just_now": MessageLookupByLibrary.simpleMessage("刚刚"),
        "kTimeDetail": MessageLookupByLibrary.simpleMessage("小K拾光详情"),
        "kTimeList": MessageLookupByLibrary.simpleMessage("小K拾光"),
        "lastTripTime": MessageLookupByLibrary.simpleMessage("末班车"),
        "latest_time": MessageLookupByLibrary.simpleMessage("最新时间"),
        "library": MessageLookupByLibrary.simpleMessage("图书馆"),
        "library_book": MessageLookupByLibrary.simpleMessage("图书"),
        "library_book_detail": MessageLookupByLibrary.simpleMessage("图书详情"),
        "library_book_info": MessageLookupByLibrary.simpleMessage("图书信息"),
        "library_book_no": MessageLookupByLibrary.simpleMessage("图书编号"),
        "library_book_unknown": MessageLookupByLibrary.simpleMessage("未知图书"),
        "library_location": MessageLookupByLibrary.simpleMessage("地点筛选："),
        "library_location_0": MessageLookupByLibrary.simpleMessage("园区外借室"),
        "library_location_1": MessageLookupByLibrary.simpleMessage("李白外借室"),
        "library_location_2": MessageLookupByLibrary.simpleMessage("H区外借室"),
        "library_location_3": MessageLookupByLibrary.simpleMessage("外借室"),
        "library_location_all": MessageLookupByLibrary.simpleMessage("全部地点"),
        "library_search": MessageLookupByLibrary.simpleMessage("请输入图书名称查询"),
        "like": MessageLookupByLibrary.simpleMessage("点赞"),
        "likeFailed": MessageLookupByLibrary.simpleMessage("点赞失败"),
        "likeSuccess": MessageLookupByLibrary.simpleMessage("点赞成功"),
        "liked": MessageLookupByLibrary.simpleMessage("已点赞"),
        "livingAreaDataLoading":
            MessageLookupByLibrary.simpleMessage("生活区数据加载中..."),
        "loadFailed": MessageLookupByLibrary.simpleMessage("加载失败"),
        "load_failed": MessageLookupByLibrary.simpleMessage("加载失败"),
        "loading": MessageLookupByLibrary.simpleMessage("数据加载中..."),
        "loading_food_menu":
            MessageLookupByLibrary.simpleMessage("正在加载今日菜谱..."),
        "loginBtn": MessageLookupByLibrary.simpleMessage("登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("登录失败"),
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登录成功"),
        "logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "logoutFailed": MessageLookupByLibrary.simpleMessage("退出登录失败"),
        "logoutSuccess": MessageLookupByLibrary.simpleMessage("退出登录成功"),
        "logoutTip": MessageLookupByLibrary.simpleMessage("确定要退出登录吗？"),
        "lost": MessageLookupByLibrary.simpleMessage("失物"),
        "lostAndFound": MessageLookupByLibrary.simpleMessage("失物招领"),
        "lostItem": MessageLookupByLibrary.simpleMessage("失物"),
        "lostItemColleague": MessageLookupByLibrary.simpleMessage("失物同事"),
        "lostItemList": MessageLookupByLibrary.simpleMessage("失物列表"),
        "lostPlace": MessageLookupByLibrary.simpleMessage("丢失地点"),
        "lostStatus": MessageLookupByLibrary.simpleMessage("丢失状态"),
        "lostTime": MessageLookupByLibrary.simpleMessage("丢失时间"),
        "lostType": MessageLookupByLibrary.simpleMessage("丢失类型"),
        "lunch": MessageLookupByLibrary.simpleMessage("午餐"),
        "man": MessageLookupByLibrary.simpleMessage("男"),
        "manage": MessageLookupByLibrary.simpleMessage("管理"),
        "mealDelivery": MessageLookupByLibrary.simpleMessage("报餐送餐"),
        "mealDeliveryAccept": MessageLookupByLibrary.simpleMessage("手持机扫码接单"),
        "mealDeliverySuccess": m6,
        "mealTime": MessageLookupByLibrary.simpleMessage("餐次"),
        "mealType": MessageLookupByLibrary.simpleMessage("餐别"),
        "message": MessageLookupByLibrary.simpleMessage("消息"),
        "mine": MessageLookupByLibrary.simpleMessage("我的"),
        "minePage": MessageLookupByLibrary.simpleMessage("我的"),
        "minutes_ago": MessageLookupByLibrary.simpleMessage("分钟前"),
        "modifyAddress": MessageLookupByLibrary.simpleMessage("修改地址"),
        "modifyPerson": MessageLookupByLibrary.simpleMessage("修改人员"),
        "monthly": MessageLookupByLibrary.simpleMessage("纬达贝月刊"),
        "monthlySales": MessageLookupByLibrary.simpleMessage("月销"),
        "moreFunction": MessageLookupByLibrary.simpleMessage("更多功能"),
        "museum_date": MessageLookupByLibrary.simpleMessage("馆藏时间"),
        "myAddress": MessageLookupByLibrary.simpleMessage("我的地址"),
        "myFeedback": MessageLookupByLibrary.simpleMessage("我的反馈"),
        "myOrder": MessageLookupByLibrary.simpleMessage("我的订单"),
        "myProcess": MessageLookupByLibrary.simpleMessage("我的流程"),
        "myRelease": MessageLookupByLibrary.simpleMessage("我的发布"),
        "myReleaseList": MessageLookupByLibrary.simpleMessage("我的发布列表"),
        "myRepair": MessageLookupByLibrary.simpleMessage("我的报修"),
        "my_good_deeds": MessageLookupByLibrary.simpleMessage("我的发布"),
        "myself": MessageLookupByLibrary.simpleMessage("我"),
        "name": MessageLookupByLibrary.simpleMessage("姓名"),
        "needCameraPermission":
            MessageLookupByLibrary.simpleMessage("需要相机权限才能扫码"),
        "needLogin": MessageLookupByLibrary.simpleMessage("请登录您的帐号"),
        "networkError": MessageLookupByLibrary.simpleMessage("网络连接错误"),
        "networkErrorTips":
            MessageLookupByLibrary.simpleMessage("网络不给力，点击重新加载"),
        "newPassword": MessageLookupByLibrary.simpleMessage("新密码"),
        "newPasswordNotEmpty": MessageLookupByLibrary.simpleMessage("新密码不能为空"),
        "newProductRecommend": MessageLookupByLibrary.simpleMessage("新品推荐"),
        "newVersion": MessageLookupByLibrary.simpleMessage("发现新版本"),
        "news": MessageLookupByLibrary.simpleMessage("公司新闻"),
        "nightSnack": MessageLookupByLibrary.simpleMessage("夜宵"),
        "noData": MessageLookupByLibrary.simpleMessage("暂无数据"),
        "noMoreData": MessageLookupByLibrary.simpleMessage("没有更多数据"),
        "noOrder": MessageLookupByLibrary.simpleMessage("暂无订单"),
        "noPersonInfo": MessageLookupByLibrary.simpleMessage("暂无人员信息"),
        "no_content": MessageLookupByLibrary.simpleMessage("暂无内容"),
        "no_description": MessageLookupByLibrary.simpleMessage("暂无描述"),
        "no_food_menu_info": MessageLookupByLibrary.simpleMessage("暂无菜谱信息"),
        "no_food_menu_info_tips":
            MessageLookupByLibrary.simpleMessage("该日期暂无菜谱安排"),
        "no_message": MessageLookupByLibrary.simpleMessage("暂无消息"),
        "no_more_info": MessageLookupByLibrary.simpleMessage("暂无详细信息"),
        "normalOrder": MessageLookupByLibrary.simpleMessage("正常订单"),
        "not_filled": MessageLookupByLibrary.simpleMessage("未填写"),
        "notice": MessageLookupByLibrary.simpleMessage("公告"),
        "notifications": MessageLookupByLibrary.simpleMessage("通知公告"),
        "oldPassword": MessageLookupByLibrary.simpleMessage("旧密码"),
        "oldPasswordNotEmpty": MessageLookupByLibrary.simpleMessage("旧密码不能为空"),
        "oneMonth": MessageLookupByLibrary.simpleMessage("一个月"),
        "oneWeek": MessageLookupByLibrary.simpleMessage("一周"),
        "oneYear": MessageLookupByLibrary.simpleMessage("一年"),
        "onlineApply": MessageLookupByLibrary.simpleMessage("在线申请"),
        "onlineDelivery": MessageLookupByLibrary.simpleMessage("在线接单"),
        "onlineDining": MessageLookupByLibrary.simpleMessage("在线订餐"),
        "online_customer_service": MessageLookupByLibrary.simpleMessage("在线客服"),
        "operator": MessageLookupByLibrary.simpleMessage("操作人"),
        "optional": MessageLookupByLibrary.simpleMessage("（可选）"),
        "order": MessageLookupByLibrary.simpleMessage("点餐"),
        "orderAllLoaded": MessageLookupByLibrary.simpleMessage("订单已全部装车"),
        "orderCenterConfirmed": MessageLookupByLibrary.simpleMessage("订单中心已确认"),
        "orderCompleted": MessageLookupByLibrary.simpleMessage("订单已完成"),
        "orderDetail": MessageLookupByLibrary.simpleMessage("订单详情"),
        "orderInfo": MessageLookupByLibrary.simpleMessage("订单信息"),
        "orderName": MessageLookupByLibrary.simpleMessage("订单姓名"),
        "orderNo": MessageLookupByLibrary.simpleMessage("订单号"),
        "orderNotConfirmed":
            MessageLookupByLibrary.simpleMessage("非 (订单中心已确认 & 配餐中)"),
        "orderNotFound": MessageLookupByLibrary.simpleMessage("没有查询到订单信息"),
        "orderNum": MessageLookupByLibrary.simpleMessage("订餐份数"),
        "orderNumUnit": MessageLookupByLibrary.simpleMessage("份"),
        "orderPlacedBy": MessageLookupByLibrary.simpleMessage("下单人"),
        "orderProgress": MessageLookupByLibrary.simpleMessage("订单进度"),
        "orderRejected": MessageLookupByLibrary.simpleMessage("订单已驳回"),
        "orderStatus": MessageLookupByLibrary.simpleMessage("订单状态"),
        "orderTime": MessageLookupByLibrary.simpleMessage("下单时间"),
        "other": MessageLookupByLibrary.simpleMessage("其他"),
        "packOrderSuccess": MessageLookupByLibrary.simpleMessage("打包处理成功"),
        "packageTypeError": MessageLookupByLibrary.simpleMessage("盒装饭不需要接收"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "passwordChangeFailed": MessageLookupByLibrary.simpleMessage("密码修改失败"),
        "passwordChangeSuccess": MessageLookupByLibrary.simpleMessage("密码修改成功"),
        "passwordLength": MessageLookupByLibrary.simpleMessage("密码长度为6-16位"),
        "passwordModifySuccess": MessageLookupByLibrary.simpleMessage("密码修改成功"),
        "passwordNotEmpty": MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "passwordNotSame": MessageLookupByLibrary.simpleMessage("两次密码不一致"),
        "passwordPlaceholder": MessageLookupByLibrary.simpleMessage("请输入您的密码"),
        "passwordTips": MessageLookupByLibrary.simpleMessage("密码由6位数字组成"),
        "payFail": MessageLookupByLibrary.simpleMessage("支付失败"),
        "paySuccess": MessageLookupByLibrary.simpleMessage("支付成功"),
        "paymentQRCode": MessageLookupByLibrary.simpleMessage("付款码"),
        "pending": MessageLookupByLibrary.simpleMessage("待维修"),
        "pendingOrder": MessageLookupByLibrary.simpleMessage("待接单"),
        "pendingRepair": MessageLookupByLibrary.simpleMessage("待返修"),
        "permissionDenied": MessageLookupByLibrary.simpleMessage("您没有取餐权限"),
        "personList": MessageLookupByLibrary.simpleMessage("人员列表"),
        "personalInfo": MessageLookupByLibrary.simpleMessage("个人信息"),
        "personal_info": MessageLookupByLibrary.simpleMessage("个人信息"),
        "phone": MessageLookupByLibrary.simpleMessage("手机号"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("联系电话"),
        "phone_number_empty": MessageLookupByLibrary.simpleMessage("电话号码为空"),
        "photoAlbum": MessageLookupByLibrary.simpleMessage("相册"),
        "pickupCode": MessageLookupByLibrary.simpleMessage("货架"),
        "pickupLimitTime": MessageLookupByLibrary.simpleMessage("取餐限定时间"),
        "pickupTime": MessageLookupByLibrary.simpleMessage("取餐时间"),
        "pickupType": MessageLookupByLibrary.simpleMessage("取餐方式"),
        "pleaseAcceptOrder": MessageLookupByLibrary.simpleMessage("请先接单"),
        "pleaseCancelOrder": MessageLookupByLibrary.simpleMessage("请先取消订单"),
        "pleaseEnterAccount": m7,
        "pleaseEnterPassword": m8,
        "pleaseFillIn": m9,
        "pleaseInput": m10,
        "pleaseScanTheBarcode":
            MessageLookupByLibrary.simpleMessage("请将条形码放入框内，即可自动扫描"),
        "pleaseSelect": m11,
        "please_enter_good_deeds_contact_info":
            MessageLookupByLibrary.simpleMessage("请输入联系方式"),
        "please_enter_good_deeds_description":
            MessageLookupByLibrary.simpleMessage("请输入详细描述"),
        "please_enter_good_deeds_name":
            MessageLookupByLibrary.simpleMessage("请输入好人姓名"),
        "please_enter_good_deeds_title":
            MessageLookupByLibrary.simpleMessage("请输入好人好事标题"),
        "please_enter_hazard_description":
            MessageLookupByLibrary.simpleMessage("请描述发现隐患"),
        "please_enter_hazard_location":
            MessageLookupByLibrary.simpleMessage("请输入发现地点"),
        "please_enter_hazard_name":
            MessageLookupByLibrary.simpleMessage("请输入隐患名称"),
        "please_enter_reporter_name":
            MessageLookupByLibrary.simpleMessage("请输入上报人姓名"),
        "please_enter_reporter_tel":
            MessageLookupByLibrary.simpleMessage("请输入联系电话"),
        "please_select_hazard_date":
            MessageLookupByLibrary.simpleMessage("请选择发现日期"),
        "please_select_hazard_time":
            MessageLookupByLibrary.simpleMessage("请选择发现时间"),
        "please_upload_hazard_photo":
            MessageLookupByLibrary.simpleMessage("请上传发现照片"),
        "please_upload_hazard_photo_tips":
            MessageLookupByLibrary.simpleMessage("请拍摄或选择隐患现场照片，最多选择6张"),
        "please_upload_hazard_video":
            MessageLookupByLibrary.simpleMessage("请上传发现视频"),
        "press_alarm": MessageLookupByLibrary.simpleMessage("按下报警"),
        "press_to_speak": MessageLookupByLibrary.simpleMessage("按住 说话"),
        "price": MessageLookupByLibrary.simpleMessage("价格"),
        "process": MessageLookupByLibrary.simpleMessage("处理"),
        "processDescription": MessageLookupByLibrary.simpleMessage("流程说明"),
        "processing": MessageLookupByLibrary.simpleMessage("处理中..."),
        "processingScanResult":
            MessageLookupByLibrary.simpleMessage("正在处理扫码结果"),
        "processingScanResultError":
            MessageLookupByLibrary.simpleMessage("处理异常"),
        "processing_status": MessageLookupByLibrary.simpleMessage("处理状态"),
        "promo": MessageLookupByLibrary.simpleMessage("宣传片"),
        "promoDetail": MessageLookupByLibrary.simpleMessage("宣传片详情"),
        "promoList": MessageLookupByLibrary.simpleMessage("宣传片列表"),
        "publicAddress": MessageLookupByLibrary.simpleMessage("详细地址"),
        "publicBusinessHours": MessageLookupByLibrary.simpleMessage("营业时间"),
        "publication_date": MessageLookupByLibrary.simpleMessage("出版日期"),
        "publish": MessageLookupByLibrary.simpleMessage("发布"),
        "publishInfo": MessageLookupByLibrary.simpleMessage("发布信息"),
        "publish_failed": MessageLookupByLibrary.simpleMessage("发布失败"),
        "publish_good_deeds": MessageLookupByLibrary.simpleMessage("发布好人好事"),
        "publish_success_wait_for_audit":
            MessageLookupByLibrary.simpleMessage("发布成功，等待审核"),
        "publisher": MessageLookupByLibrary.simpleMessage("出版社"),
        "pullUpLoadMore": MessageLookupByLibrary.simpleMessage("上拉加载更多"),
        "read": MessageLookupByLibrary.simpleMessage("已读"),
        "receive": MessageLookupByLibrary.simpleMessage("领取"),
        "receivePlace": MessageLookupByLibrary.simpleMessage("领取地址"),
        "receiveTime": MessageLookupByLibrary.simpleMessage("拾取时间"),
        "received": MessageLookupByLibrary.simpleMessage("已收货"),
        "recentlyScanned": MessageLookupByLibrary.simpleMessage("最近扫码"),
        "recommendPerson": MessageLookupByLibrary.simpleMessage("推荐人"),
        "recommendReason": MessageLookupByLibrary.simpleMessage("推荐理由"),
        "recommendTime": MessageLookupByLibrary.simpleMessage("推荐时间"),
        "reconnected_to_server":
            MessageLookupByLibrary.simpleMessage("已重新连接到服务器"),
        "record_the_warm_moments_around_you":
            MessageLookupByLibrary.simpleMessage("记录身边的温暖瞬间，传递正能量"),
        "recording_audio": MessageLookupByLibrary.simpleMessage("正在录音..."),
        "reduceOrder": MessageLookupByLibrary.simpleMessage("减餐"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "refreshComplete": MessageLookupByLibrary.simpleMessage("刷新完成"),
        "refreshFailed": MessageLookupByLibrary.simpleMessage("刷新失败"),
        "refresh_food_menu": MessageLookupByLibrary.simpleMessage("刷新菜谱"),
        "refreshing": MessageLookupByLibrary.simpleMessage("刷新中..."),
        "region": MessageLookupByLibrary.simpleMessage("所在区域"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "registerFailed": MessageLookupByLibrary.simpleMessage("注册失败"),
        "registerSuccess": MessageLookupByLibrary.simpleMessage("注册成功"),
        "registerText": MessageLookupByLibrary.simpleMessage("没有账号？立即注册"),
        "related_account": MessageLookupByLibrary.simpleMessage("关联帐号"),
        "releaseLoadMore": MessageLookupByLibrary.simpleMessage("释放加载更多"),
        "release_finger_to_cancel":
            MessageLookupByLibrary.simpleMessage("松开手指，取消发送"),
        "release_to_send": MessageLookupByLibrary.simpleMessage("松开 发送"),
        "reload": MessageLookupByLibrary.simpleMessage("重新加载"),
        "remaining": MessageLookupByLibrary.simpleMessage("剩余"),
        "remark": MessageLookupByLibrary.simpleMessage("备注"),
        "remark_info": MessageLookupByLibrary.simpleMessage("备注信息"),
        "rememberPassword": MessageLookupByLibrary.simpleMessage("记住密码"),
        "repairAddress": MessageLookupByLibrary.simpleMessage("报修地址"),
        "repairAddressNotEmpty":
            MessageLookupByLibrary.simpleMessage("报修地址不能为空"),
        "repairArea": MessageLookupByLibrary.simpleMessage("报修区域"),
        "repairContent": MessageLookupByLibrary.simpleMessage("报修内容"),
        "repairContentNotEmpty":
            MessageLookupByLibrary.simpleMessage("报修内容不能为空"),
        "repairDescription": MessageLookupByLibrary.simpleMessage("请填写维修说明"),
        "repairDetail": MessageLookupByLibrary.simpleMessage("报修详情"),
        "repairDirection": MessageLookupByLibrary.simpleMessage("维修说明"),
        "repairFeedback": MessageLookupByLibrary.simpleMessage("返修信息"),
        "repairFeedbackTip": MessageLookupByLibrary.simpleMessage("确认提交维修反馈吗？"),
        "repairImage": MessageLookupByLibrary.simpleMessage("报修图片"),
        "repairImages": MessageLookupByLibrary.simpleMessage("报修图片"),
        "repairMessage": MessageLookupByLibrary.simpleMessage("报修信息"),
        "repairNote": MessageLookupByLibrary.simpleMessage("处理结果"),
        "repairOnline": MessageLookupByLibrary.simpleMessage("在线报修"),
        "repairOrder": MessageLookupByLibrary.simpleMessage("报修订单"),
        "repairOrderManagement": MessageLookupByLibrary.simpleMessage("维修订单管理"),
        "repairOrderProcess": MessageLookupByLibrary.simpleMessage("维修单处理"),
        "repairOrderProcessed":
            MessageLookupByLibrary.simpleMessage("您的维修单已处理"),
        "repairPerson": MessageLookupByLibrary.simpleMessage("报修人"),
        "repairPersonNotEmpty": MessageLookupByLibrary.simpleMessage("报修人不能为空"),
        "repairResult": MessageLookupByLibrary.simpleMessage("维修结果"),
        "repairRoomNo": MessageLookupByLibrary.simpleMessage("报修房间号"),
        "repairService": MessageLookupByLibrary.simpleMessage("报修服务"),
        "repairServiceRate":
            MessageLookupByLibrary.simpleMessage("请给对本次维修的满意度打一个综合评分吧！"),
        "repairStatus": MessageLookupByLibrary.simpleMessage("维修状态"),
        "repairSubmitFailed": MessageLookupByLibrary.simpleMessage("报修提交失败"),
        "repairSubmitSuccess": MessageLookupByLibrary.simpleMessage("报修提交成功"),
        "repairSubmitTime": MessageLookupByLibrary.simpleMessage("报修时间"),
        "repairTel": MessageLookupByLibrary.simpleMessage("联系电话"),
        "repairTime": MessageLookupByLibrary.simpleMessage("维修时间"),
        "repairType": MessageLookupByLibrary.simpleMessage("维修类型"),
        "repaired": MessageLookupByLibrary.simpleMessage("已维修"),
        "replied": MessageLookupByLibrary.simpleMessage("已回复"),
        "reply_content": MessageLookupByLibrary.simpleMessage("回复内容"),
        "reply_person": MessageLookupByLibrary.simpleMessage("回复人"),
        "reply_status": MessageLookupByLibrary.simpleMessage("待回复"),
        "reply_time": MessageLookupByLibrary.simpleMessage("回复时间"),
        "reply_to_feedback": MessageLookupByLibrary.simpleMessage("回复反馈"),
        "report_hazard": MessageLookupByLibrary.simpleMessage("发现隐患"),
        "reporter": MessageLookupByLibrary.simpleMessage("上报人"),
        "reporter_name": MessageLookupByLibrary.simpleMessage("姓名"),
        "reporter_tel": MessageLookupByLibrary.simpleMessage("联系电话"),
        "reset": MessageLookupByLibrary.simpleMessage("重置"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("重置密码"),
        "reset_success": MessageLookupByLibrary.simpleMessage("已重置"),
        "restaurant": MessageLookupByLibrary.simpleMessage("餐厅"),
        "returnPending": MessageLookupByLibrary.simpleMessage("待返修"),
        "reward_details": MessageLookupByLibrary.simpleMessage("奖励细则"),
        "satisfaction": MessageLookupByLibrary.simpleMessage("满意度"),
        "saveAddress": MessageLookupByLibrary.simpleMessage("保存地址"),
        "saveAddressFail": MessageLookupByLibrary.simpleMessage("保存地址失败"),
        "saveAddressSuccess": MessageLookupByLibrary.simpleMessage("保存地址成功"),
        "scanQRCode": MessageLookupByLibrary.simpleMessage("扫描二维码"),
        "scanQRCodeTips":
            MessageLookupByLibrary.simpleMessage("将二维码放入框内，即可自动扫描"),
        "scanSettings": MessageLookupByLibrary.simpleMessage("扫码设置"),
        "scanStatus": MessageLookupByLibrary.simpleMessage("扫码状态"),
        "search": MessageLookupByLibrary.simpleMessage("查询"),
        "searchMessage": MessageLookupByLibrary.simpleMessage("搜索消息"),
        "searchMyOrder": MessageLookupByLibrary.simpleMessage("搜索我的订单"),
        "search_good_deeds": MessageLookupByLibrary.simpleMessage("搜索好人好事..."),
        "secret": MessageLookupByLibrary.simpleMessage("保密"),
        "selectAddress": MessageLookupByLibrary.simpleMessage("选择收货地址"),
        "selectAllOrDeselectAll": MessageLookupByLibrary.simpleMessage("全选/反选"),
        "selectByTime": MessageLookupByLibrary.simpleMessage("按时间选择"),
        "selectDate": MessageLookupByLibrary.simpleMessage("选择日期"),
        "selectMealTimeAndFoodType":
            MessageLookupByLibrary.simpleMessage("选择对应的餐次和餐种"),
        "selectRepairTime": MessageLookupByLibrary.simpleMessage("请选择维修时间"),
        "selectRepairType": MessageLookupByLibrary.simpleMessage("请选择维修类型"),
        "select_contact_method": MessageLookupByLibrary.simpleMessage("选择联系方式"),
        "select_date": MessageLookupByLibrary.simpleMessage("选择日期"),
        "select_discover_date": MessageLookupByLibrary.simpleMessage("请选择发现日期"),
        "select_discover_description":
            MessageLookupByLibrary.simpleMessage("请描述发现情况"),
        "select_discover_location":
            MessageLookupByLibrary.simpleMessage("请选择发现地点"),
        "select_discover_photo":
            MessageLookupByLibrary.simpleMessage("请上传发现照片"),
        "select_discover_time": MessageLookupByLibrary.simpleMessage("请选择发现时间"),
        "selected": MessageLookupByLibrary.simpleMessage("已选择"),
        "selfPickup": MessageLookupByLibrary.simpleMessage("自取"),
        "sendMessageError": m12,
        "serviceGuide": MessageLookupByLibrary.simpleMessage("服务指南"),
        "setDefault": MessageLookupByLibrary.simpleMessage("确定把该地址设置为默认吗？"),
        "share_your_good_deeds":
            MessageLookupByLibrary.simpleMessage("分享您的好人好事"),
        "shopWorkbench": MessageLookupByLibrary.simpleMessage("店铺工作台"),
        "size": MessageLookupByLibrary.simpleMessage("尺寸"),
        "sos": MessageLookupByLibrary.simpleMessage("SOS"),
        "sos_alarm_tips":
            MessageLookupByLibrary.simpleMessage("请勿滥用紧急报警功能，虚假报警将承担相应责任"),
        "sos_emergency_alarm": MessageLookupByLibrary.simpleMessage("SOS紧急报警"),
        "startDate": MessageLookupByLibrary.simpleMessage("开始日期"),
        "startLocation": MessageLookupByLibrary.simpleMessage("开始定位"),
        "startStation": MessageLookupByLibrary.simpleMessage("起点站"),
        "stationNumber": MessageLookupByLibrary.simpleMessage("站点数"),
        "stopList": MessageLookupByLibrary.simpleMessage("站点列表"),
        "stopLocation": MessageLookupByLibrary.simpleMessage("停止定位"),
        "submit": MessageLookupByLibrary.simpleMessage("提交"),
        "submitFail": MessageLookupByLibrary.simpleMessage("提交失败"),
        "submitOrder": MessageLookupByLibrary.simpleMessage("提交订单"),
        "submitSuccess": MessageLookupByLibrary.simpleMessage("提交成功"),
        "submit_failed": MessageLookupByLibrary.simpleMessage("提交失败"),
        "submit_hazard_report_content":
            MessageLookupByLibrary.simpleMessage("确定提交隐患报告吗？"),
        "submit_hazard_report_fail":
            MessageLookupByLibrary.simpleMessage("提交失败"),
        "submit_hazard_report_success":
            MessageLookupByLibrary.simpleMessage("提交成功"),
        "submitting": MessageLookupByLibrary.simpleMessage("提交中..."),
        "supplementOrder": MessageLookupByLibrary.simpleMessage("补餐"),
        "system": MessageLookupByLibrary.simpleMessage("系统"),
        "takePhoto": MessageLookupByLibrary.simpleMessage("拍摄"),
        "takeout": MessageLookupByLibrary.simpleMessage("打包"),
        "threeMonths": MessageLookupByLibrary.simpleMessage("三个月"),
        "timetable": MessageLookupByLibrary.simpleMessage("发车时间表"),
        "tip": MessageLookupByLibrary.simpleMessage("提示"),
        "title": MessageLookupByLibrary.simpleMessage("标题"),
        "title_at_least_2_characters":
            MessageLookupByLibrary.simpleMessage("标题至少需要2个字符"),
        "to": MessageLookupByLibrary.simpleMessage("至"),
        "toBeAudited": MessageLookupByLibrary.simpleMessage("待审核"),
        "toBeAuditedMessage": MessageLookupByLibrary.simpleMessage("提交成功，等待审核"),
        "toBeDelivered": MessageLookupByLibrary.simpleMessage("待配送"),
        "toBeFound": MessageLookupByLibrary.simpleMessage("待找回"),
        "toBePacked": MessageLookupByLibrary.simpleMessage("待打包"),
        "toBeReceived": MessageLookupByLibrary.simpleMessage("待领取"),
        "toBeReceivedSuccess": MessageLookupByLibrary.simpleMessage("已领取"),
        "toBeRejected": MessageLookupByLibrary.simpleMessage("已驳回"),
        "today": MessageLookupByLibrary.simpleMessage("今天"),
        "toolPage": MessageLookupByLibrary.simpleMessage("工具箱"),
        "total": MessageLookupByLibrary.simpleMessage("合计"),
        "triggering_emergency_alarm":
            MessageLookupByLibrary.simpleMessage("正在发起紧急报警..."),
        "tripNumber": MessageLookupByLibrary.simpleMessage("班次数"),
        "trying_to_reconnect":
            MessageLookupByLibrary.simpleMessage("正在尝试重新连接..."),
        "type": MessageLookupByLibrary.simpleMessage("类型"),
        "type_no": MessageLookupByLibrary.simpleMessage("类型编号"),
        "unbind": MessageLookupByLibrary.simpleMessage("解除绑定"),
        "unbindFail": MessageLookupByLibrary.simpleMessage("解除绑定失败"),
        "unbindSuccess": MessageLookupByLibrary.simpleMessage("解除绑定成功"),
        "unbound": MessageLookupByLibrary.simpleMessage("未绑定"),
        "unfixed": MessageLookupByLibrary.simpleMessage("未修复"),
        "unfixedReason": MessageLookupByLibrary.simpleMessage("请填写未修复原因"),
        "unknown": MessageLookupByLibrary.simpleMessage("未知"),
        "unknownName": MessageLookupByLibrary.simpleMessage("未知姓名"),
        "unknownStatus": MessageLookupByLibrary.simpleMessage("未知状态"),
        "unknown_dish": MessageLookupByLibrary.simpleMessage("未知菜品"),
        "unknown_error": MessageLookupByLibrary.simpleMessage("未知错误"),
        "unknown_status": MessageLookupByLibrary.simpleMessage("未知状态"),
        "unknown_time": MessageLookupByLibrary.simpleMessage("未知时间"),
        "unknown_title": MessageLookupByLibrary.simpleMessage("未知标题"),
        "unlike": MessageLookupByLibrary.simpleMessage("取消点赞"),
        "unread": MessageLookupByLibrary.simpleMessage("未读"),
        "unreceived": MessageLookupByLibrary.simpleMessage("未收"),
        "unreceivedOrder": MessageLookupByLibrary.simpleMessage("未取订单"),
        "unsupported_file_type":
            MessageLookupByLibrary.simpleMessage("不支持的文件类型"),
        "update": MessageLookupByLibrary.simpleMessage("更新"),
        "updateAddressData": MessageLookupByLibrary.simpleMessage("更新区域数据"),
        "updateAppStore":
            MessageLookupByLibrary.simpleMessage("请前往APPStore下载最新版"),
        "updateNow": MessageLookupByLibrary.simpleMessage("立即更新"),
        "updatePaymentPassword": MessageLookupByLibrary.simpleMessage("修改支付密码"),
        "updateTime": MessageLookupByLibrary.simpleMessage("处理时间"),
        "update_time": MessageLookupByLibrary.simpleMessage("更新时间"),
        "uploadFacePhoto": MessageLookupByLibrary.simpleMessage("请上传人脸照片"),
        "uploadImageFailed": MessageLookupByLibrary.simpleMessage("图片上传失败"),
        "uploadImages": MessageLookupByLibrary.simpleMessage("上传图片"),
        "uploadNewFacePhoto": MessageLookupByLibrary.simpleMessage("上传新证件照"),
        "upload_images_failed":
            MessageLookupByLibrary.simpleMessage("图片上传失败，请重试"),
        "uploading_file": MessageLookupByLibrary.simpleMessage("正在上传文件..."),
        "usageInstructions": MessageLookupByLibrary.simpleMessage("使用说明"),
        "useHandheldScannerToScanBarcode":
            MessageLookupByLibrary.simpleMessage("使用手持机扫描条码"),
        "userFeedback": MessageLookupByLibrary.simpleMessage("用户反馈"),
        "userInfo": MessageLookupByLibrary.simpleMessage("个人信息"),
        "userName": MessageLookupByLibrary.simpleMessage("账号"),
        "userNamePlaceholder": MessageLookupByLibrary.simpleMessage("请输入您的账号"),
        "usernamePlaceholder": MessageLookupByLibrary.simpleMessage("请输入您的工号"),
        "version": MessageLookupByLibrary.simpleMessage("版本"),
        "video_preview": MessageLookupByLibrary.simpleMessage("视频预览"),
        "viewOrder": MessageLookupByLibrary.simpleMessage("查看订单"),
        "viewPerson": MessageLookupByLibrary.simpleMessage("查看人员"),
        "viewed": MessageLookupByLibrary.simpleMessage("已查看"),
        "waitingForScan": MessageLookupByLibrary.simpleMessage("等待扫码..."),
        "warningPage": MessageLookupByLibrary.simpleMessage("SOS报警"),
        "waterService": MessageLookupByLibrary.simpleMessage("20L"),
        "welcome": MessageLookupByLibrary.simpleMessage("欢迎来到IWIP后勤综合服务APP"),
        "woman": MessageLookupByLibrary.simpleMessage("女"),
        "workNo": MessageLookupByLibrary.simpleMessage("工号"),
        "yesterday": MessageLookupByLibrary.simpleMessage("昨天"),
        "zh": MessageLookupByLibrary.simpleMessage("中文")
      };
}
