import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class BindAccountPage extends StatefulWidget {
  const BindAccountPage({Key? key}) : super(key: key);

  @override
  _BindAccountPageState createState() => _BindAccountPageState();
}

class _BindAccountPageState extends State<BindAccountPage> {
  final List<ThirdPartySystem> _systems = [];
  bool _isLoading = true;
  UserInfoModel? userInfo;
  ThirdUserInfoModel? thirdUserInfo;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // 模拟异步数据获取
      var userInfoData = await SpUtils.getModel('userInfo');
      var thirdUserInfoData = await SpUtils.getModel('thirdUserInfo');
      // 更新状态
      setState(() {
        if (userInfoData != null) {
          userInfo = UserInfoModel.fromJson(userInfoData);
          _getSystems(userInfo!);
        }
        if (thirdUserInfoData != null) {
          thirdUserInfo = ThirdUserInfoModel.fromJson(thirdUserInfoData);
        }
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
      ProgressHUD.showError(S.current.getSystemDataError);
    }
  }

  // 获取系统列表
  void _getSystems(UserInfoModel userInfo) {
    if (userInfo.mealUser != null) {
      String username =
          (userInfo.mealUser!.sysUser?.nickName ?? '') +
          '(' +
          (userInfo.mealUser!.username ?? '') +
          ')';
      _systems.clear();
      _systems.addAll([
        ThirdPartySystem(
          id: '1',
          name: S.of(context).mealDelivery,
          icon: Icons.delivery_dining,
          iconColor: const Color(0xFF07C160),
          isBound: username.isNotEmpty,
          boundAccount: username,
          description: S.of(context).bindMealDeliveryAccount,
        ),
      ]);
    } else {
      _systems.clear();
      _systems.addAll([
        ThirdPartySystem(
          id: '1',
          name: S.of(context).mealDelivery,
          icon: Icons.delivery_dining,
          iconColor: const Color(0xFF07C160),
          isBound: false,
          boundAccount: '',
          description: S.of(context).bindMealDeliveryAccount,
        ),
      ]);
    }
  }

  void _showBindDialog(ThirdPartySystem system) {
    if (system.isBound) {
      _showUnbindDialog(system);
    } else {
      _showBindAccountDialog(system);
    }
  }

  void _showBindAccountDialog(ThirdPartySystem system) {
    final TextEditingController accountController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    DialogFactory.instance.showParentDialog(
      context: context,
      child: Container(
        width: 300.px,
        color: Colors.white,
        padding: EdgeInsets.all(20.px),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题
              Row(
                children: [
                  Icon(system.icon, color: system.iconColor, size: 24.px),
                  SizedBox(width: 12.px),
                  Text(
                    S.of(context).bindAccount(system.name),
                    style: AppTheme.title.copyWith(
                      fontSize: 18.px,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.px),

              // 账号输入框
              Container(
                height: 40.px,
                child: TextFormField(
                  style: TextStyle(fontSize: 14.px),
                  controller: accountController,
                  decoration: InputDecoration(
                    labelText: '${system.name}${S.of(context).account}',
                    hintText: S.of(context).pleaseEnterAccount(system.name),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.px),
                    ),
                    prefixIcon: Icon(Icons.person, size: 20.px),
                  ),
                ),
              ),
              SizedBox(height: 16.px),

              Container(
                height: 40.px,
                child: TextFormField(
                  controller: passwordController,
                  style: TextStyle(fontSize: 14.px),
                  decoration: InputDecoration(
                    isCollapsed: true, // 禁用多余的垂直 padding（包含错误提示空间）
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.px,
                    ), // 调整文字居中
                    labelText: '${system.name}${S.of(context).password}',
                    hintText: S.of(context).pleaseEnterPassword(system.name),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.px),
                    ),
                    prefixIcon: Icon(Icons.lock, size: 20.px),
                    errorStyle: const TextStyle(
                      height: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.px),

              // 按钮区域
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        maximumSize: Size(double.infinity, 40.px),
                        minimumSize: Size(double.infinity, 40.px),
                      ),
                      child: Text(
                        S.of(context).cancel,
                        style: TextStyle(fontSize: 14.px, color: AppTheme.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.px),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (accountController.text.isEmpty) {
                          ProgressHUD.showError(
                            S.of(context).pleaseEnterAccount(system.name),
                          );
                          return;
                        }

                        if (passwordController.text.isEmpty) {
                          ProgressHUD.showError(
                            S.of(context).pleaseEnterPassword(system.name),
                          );
                          return;
                        }
                        final result = await _bindAccount(
                          system,
                          accountController.text,
                          passwordController.text,
                        );
                        if (result) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: system.iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        maximumSize: Size(double.infinity, 40.px),
                        minimumSize: Size(double.infinity, 40.px),
                      ),
                      child: Text(
                        S.of(context).bind,
                        style: TextStyle(
                          fontSize: 14.px,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnbindDialog(ThirdPartySystem system) {
    DialogFactory.instance.showParentDialog(
      context: context,
      child: Container(
        width: 300.px,
        color: Colors.white,
        padding: EdgeInsets.all(20.px),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标和标题
            Icon(system.icon, color: system.iconColor, size: 48.px),
            SizedBox(height: 10.px),
            Text(
              S.of(context).unbind,
              style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.px),
            Text(
              S.of(context).confirmToUnbind(system.name),
              style: TextStyle(fontSize: 14.px, color: AppTheme.lightText),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.px),

            // 当前绑定信息
            Container(
              padding: EdgeInsets.all(12.px),
              decoration: BoxDecoration(
                color: AppTheme.chipBackground,
                borderRadius: BorderRadius.circular(8.px),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16.px,
                    color: AppTheme.lightText,
                  ),
                  SizedBox(width: 8.px),
                  Expanded(
                    child: Text(
                      '${S.of(context).currentBound}: ${system.boundAccount}',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: AppTheme.lightText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.px),

            // 按钮区域
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      maximumSize: Size(double.infinity, 40.px),
                      minimumSize: Size(double.infinity, 40.px),
                    ),
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(fontSize: 14.px, color: AppTheme.grey),
                    ),
                  ),
                ),
                SizedBox(width: 16.px),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await _unbindAccount();
                      if (result) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.px),
                      ),
                      maximumSize: Size(double.infinity, 40.px),
                      minimumSize: Size(double.infinity, 40.px),
                    ),

                    child: Text(
                      S.of(context).unbind,
                      style: TextStyle(
                        fontSize: 14.px,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _bindAccount(
    ThirdPartySystem system,
    String account,
    String password,
  ) async {
    final completer = Completer<bool>();
    DataUtils.bindMealDeliveryAccount(
      {
        'userId': thirdUserInfo?.id,
        'username': thirdUserInfo?.account,
        'mealName': account,
        'password': password,
      },
      success: (data) {
        ProgressHUD.showSuccess(S.of(context).bindSuccess);
        DataUtils.putLoginUser(
          {'username': thirdUserInfo?.account, 'password': ''},
          success: (res) {
            DataUtils.getUserInfo(
              success: (res) async {
                UserInfoModel userInfo = UserInfoModel.fromJson(res['data']);
                await SpUtils.saveModel('userInfo', userInfo);
                await SpUtils.saveModel(
                  Constants.SP_USER_PERMISSION,
                  userInfo.permissions ?? [],
                );
                completer.complete(true);
              },
              fail: (code, msg) {
                completer.complete(false);
              },
            );
          },
          fail: (code, msg) {
            completer.complete(false);
          },
        );
      },
    );
    return completer.future;
  }

  Future<bool> _unbindAccount() async {
    final completer = Completer<bool>();
    // 模拟解绑操作
    DataUtils.revokeMealDeliveryAccount(
      thirdUserInfo?.account,
      success: (data) {
        ProgressHUD.showSuccess(S.of(context).unbindSuccess);
        DataUtils.getUserInfo(
          success: (res) async {
            UserInfoModel userInfo = UserInfoModel.fromJson(res['data']);
            await SpUtils.saveModel('userInfo', userInfo);
            SpUtils.saveString(
              Constants.SP_USER_NAME,
              userInfo.user?.nickName ?? '',
            );
            SpUtils.saveString(
              Constants.SP_USER_DEPT,
              userInfo.user?.dept?.deptName ?? '',
            );
            setState(() {
              _getSystems(userInfo);
              completer.complete(true);
            });
          },
          fail: (code, msg) {
            ProgressHUD.showError(msg);
            completer.complete(false);
          },
        );
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          S.of(context).bindThirdPartyAccount,
          style: AppTheme.title.copyWith(color: Colors.white, fontSize: 16.px),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchData,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView.builder(
                  padding: EdgeInsets.all(10.px),
                  itemCount: _systems.length,
                  itemBuilder: (context, index) {
                    final system = _systems[index];
                    return _buildSystemItem(system);
                  },
                ),
              ),
    );
  }

  Widget _buildSystemItem(ThirdPartySystem system) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBindDialog(system),
          borderRadius: BorderRadius.circular(12.px),
          child: Padding(
            padding: EdgeInsets.all(10.px),
            child: Row(
              children: [
                // 系统图标
                Container(
                  width: 48.px,
                  height: 48.px,
                  decoration: BoxDecoration(
                    color: system.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.px),
                  ),
                  child: Icon(
                    system.icon,
                    color: system.iconColor,
                    size: 24.px,
                  ),
                ),
                SizedBox(width: 10.px),

                // 系统信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              system.name,
                              style: AppTheme.title.copyWith(
                                fontSize: 12.px,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.px),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.px,
                              vertical: 2.px,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  system.isBound
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.px),
                            ),
                            child: Text(
                              system.isBound
                                  ? S.of(context).bound
                                  : S.of(context).unbound,
                              style: TextStyle(
                                fontSize: 10.px,
                                color:
                                    system.isBound ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.px),
                      Text(
                        system.description,
                        style: TextStyle(
                          fontSize: 10.px,
                          color: AppTheme.lightText,
                        ),
                      ),
                      if (system.isBound && system.boundAccount.isNotEmpty) ...[
                        SizedBox(height: 4.px),
                        Text(
                          '${S.of(context).account}: ${system.boundAccount}',
                          style: TextStyle(
                            fontSize: 10.px,
                            color: AppTheme.deactivatedText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 箭头图标
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.lightText,
                  size: 20.px,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThirdPartySystem {
  final String id;
  final String name;
  final IconData icon;
  final Color iconColor;
  final bool isBound;
  final String boundAccount;
  final String description;

  ThirdPartySystem({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.isBound,
    required this.boundAccount,
    required this.description,
  });

  ThirdPartySystem copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? iconColor,
    bool? isBound,
    String? boundAccount,
    String? description,
  }) {
    return ThirdPartySystem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      isBound: isBound ?? this.isBound,
      boundAccount: boundAccount ?? this.boundAccount,
      description: description ?? this.description,
    );
  }
}
