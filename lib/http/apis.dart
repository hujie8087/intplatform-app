///  apis.dart
///  description:  api管理

class APIs {
  /// url 前缀
  // 正式环境
  static const String apiPrefix =
      'https://api.iwipwedabay.com/api/intplatform/app';
  static const String imagePrefix =
      'https://web.iwipwedabay.com/static/intplatform';
  // 餐饮图片资源前缀
  static const String foodPrefix = 'https://web.iwipwedabay.com/static/';
  static const String imageOnlinePrefix =
      'https://web.iwipwedabay.com/static/intplatform';

  // 测试环境
  // static const String apiPrefix =
  //     'https://test.iwipwedabay.com/intplatform-stage-api'; // 外网
  // static const String imageOnlinePrefix =
  //     'http://192.168.90.30/static/intplatform';
  // static const String imagePrefix =
  //     'http://192.168.91.50:9000/intplatform/'; // 图片外网地址
  // static const String imagePrefix =
  //     'http://test.iwipwedabay.com/static/intplatform/'; // 图片外网地址
  static const String websocketFix = 'ws://10.40.10.18:10301/websocket/';
  // static const String websocketFix = 'ws://10.40.11.166:10301/websocket/';

  // 韩栋本地环境
  // static const String apiPrefix = 'http://10.40.10.18:10200'; // 外网

  // 垂豪本地环境
  // static const String apiPrefix = 'http://10.40.11.44:8081'; // 外网

  // 阿泽本地环境
  // static const String apiPrefix = 'http://10.40.11.26:10200'; // 外网

  // 黄丹虹本地环境
  // static const String apiPrefix = 'http://10.40.10.31:10200'; // 外网

  // 谢家豪本地环境
  // static const String apiPrefix = 'http://10.40.11.166:10200'; // 外网

  // 测试环境box
  // static const String apiPrefix = 'http://192.168.91.50:10200'; // 外网

  /// 注册接口
  static const String register = '/auth/register';

  /// 登录接口
  // static const String login = '/auth/appLogin';
  static const String login =
      'https://api.iwipwedabay.com/api/rain/iwip/home/sso/home/sso/login';

  // 刷新token
  // static const String updateToken = '/auth/refresh';
  static const String updateToken =
      'https://api.iwipwedabay.com/api/rain/iwip/home/sso/home/sso/refreshToken';

  // 忘记密码
  static const String forgetPassword = '/system/user/resetPwdByCard';

  // 退出登录
  static const String logout = '/auth/logout';

  // 获取用户信息
  static const String getUserInfo = '/system/user/getInfo';
  // 获取第三方用户信息
  static const String getThirdUserInfo =
      'https://api.iwipwedabay.com/api/rain/iwip/home/upms/home/user/findInfo';

  // 登录成功回调
  static const String putLoginUser = '/auth/putLoginUser';

  // 获取用户消费信息
  static const String getUserConsumeInfo = '/system/user/info/';

  // 编辑用户信息
  // static const String editUser = '/system/user/edit';
  static const String editUser =
      'https://api.iwipwedabay.com/api/rain/iwip/home/upms/home/user/put';

  // 储存用户设备token
  static const String addToken = '/system/user/addToken';

  /// 获取分页数据
  static const String getPage = '/mock/pages';

  /// 获取分页分组数据
  static const String getGroupPage = '/mock/groupPages';

  /// 获取固定数据
  static const String getSimpleDictList = '/mock/simpleDictList';

  /// 获取固定数据
  static const String getSimpleDict = '/mock/dict';

  // 用户修改密码
  // static const String updateUserPwd = '/system/user/profile/updatePwd';
  static const String updateUserPwd =
      'https://api.iwipwedabay.com/api/rain/iwip/home/upms/home/user/putUserPassword';

  // 用户第一次修改密码
  // static const String updateUserFirstPwd = '/system/user/firstEdit';
  static const String updateUserFirstPwd =
      'https://api.iwipwedabay.com/api/rain/iwip/home/sso/home/sso/resetFirstPassword';

  // 获取数据字典
  static const String getDictDataList = '/system/dict/data/type/';

  // 获取公共便利字典
  static const String getOtherDataList = '/other/show/list';

  // 获取新闻公共详情
  static const String getNoticeDetail = '/system/notice';

  // 获取APP最新版本
  // static const String getAppLastVersion = '/other/app/getNewApp';
  static const String getAppLastVersion =
      'https://api.iwipwedabay.com/api/rain/iwip/home/portal/home/clientVersion/check';

  // 获取区域楼栋最新版本
  static const String getBuildingVersion = '/maintenance/building/version';

  // 新增我的地址
  static const String addMyAddress = '/other/address';

  // 获取我的地址列表
  static const String getMyAddressList = '/other/address/list';

  // 获取我的地址详情
  static const String getMyAddressDetail = '/other/address';

  // 服务指南类型列表
  static const String guideTypeList = '/other/guideType/list';

  // 服务指南类型详情
  static const String guideTypeUrl = '/other/guideType';

  // 服务指南内容列表
  static const String guideList = '/other/guideArticle/list';

  // 服务指南内容详情
  static const String guideUrl = '/other/guideArticle';

  // 获取餐厅列表
  static const String getRestaurantList =
      '/productdisplay/marketCanteen/appList';

  // 获取热门菜品
  static const String getHotFoodList = '/productdisplay/commodity/chart';

  // 获取餐厅详情
  static const String getRestaurantDetail = '/productdisplay/marketCanteen';

  // 获取餐厅菜品列表
  static const String getRestaurantMenuList =
      '/productdisplay/category/getCategoryByCanteenId';

  // 获取餐厅取餐类型列表
  static const String getRestaurantPickTypeList =
      '/productdisplay/pickupType/list';

  // 获取我的订单列表
  static const String getOrderList = '/productdisplay/food/order/listApp';

  // 获取我的订单详情
  static const String getOrderDetail = '/productdisplay/food/order/selectByNo';

  // 获取门店配送时间
  static const String getRestaurantDeliveryTime =
      '/productdisplay/food/fee/find-delivery-time';

  // 获取门店配送费用
  static const String getRestaurantDeliveryFee =
      '/productdisplay/food/fee/find-delivery-fee';

  // 获取餐厅配送方式
  static const String getCanteenPickupType = '/productdisplay/pickupType/list';

  // 获取所有配送方式
  static const String getAllPickupType = '/productdisplay/pickupType/list';

  // 获取卡信息
  static const String getCardInfo = '/productdisplay/card/getCardInfo';

  // 挂失卡
  static const String disableCard = '/productdisplay/card/reportLoss';

  // 解挂卡
  static const String enableCard = '/productdisplay/card/recover';

  // 验证支付密码
  static const String verifyPayPassword = '/productdisplay/card/verifyPassword';

  // 修改支付密码
  static const String updatePayPassword = '/productdisplay/card/updatePassword';

  // 获取支付二维码
  static const String getPayQrCode = '/productdisplay/card/getqrcode';

  // 解析支付二维码
  static const String parsePayQrCode = '/productdisplay/card/analysisQrcod';

  // 二维码付款
  static const String pay = '/productdisplay/card/merchanQrcodePay';

  // 查询账单
  static const String getBill = '/productdisplay/card/selectFlows';

  /// 修改支付密码
  static const String modifyPaymentPassword =
      '/productdisplay/card/updatePassword';

  // 提交订单
  static const String submitOrder = '/productdisplay/food/order';

  // 提交留言
  static const String submitMessage = '/other/ComplaintMessage';

  // 删除订单
  static const String deleteOrder = '/productdisplay/food/order';

  // 获取住宿列表
  static const String getAccommodationList = '/other/accommodation/list';

  // 获取住宿流程
  static const String getAccommodationProcessList =
      '/other/accommodationProcess';

  // 获取配送订单列表
  static const String getDeliveryOrderList = '/delivery/order/appList';

  // 获取配送订单详情
  static const String getDeliveryOrderDetail = '/delivery/order';

  // 获取在线接单列表
  static const String getOnlineOrderList = '/delivery/acceptOrder';

  // 接单
  static const String acceptOrder = '/delivery/acceptOrder';

  // 发送消息通知
  static const String sendOneMessage = '/system/sendMessage/sendOne';

  // 点赞
  static const String addCount = '/productdisplay/commodity/andOne';

  // 获取美食推荐
  static const String getFoodRecommend = '/productdisplay/recommend/list';

  // 获取今日菜谱
  static const String getTodayMenu = '/other/daily/menu/list';
}
