import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_model.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_submit_page.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_form/meal_delivery_water_page.dart';
import 'package:logistics_app/pages/mine_page/bind_account_page/bind_account_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';

class MealDeliveryIndexPage extends StatefulWidget {
  const MealDeliveryIndexPage({super.key});

  @override
  State<MealDeliveryIndexPage> createState() => _MealDeliveryIndexPageState();
}

class _MealDeliveryIndexPageState extends State<MealDeliveryIndexPage>
    with TickerProviderStateMixin {
  MealDeliveryModel mealDeliveryModel = MealDeliveryModel();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String languageCode = 'zh';

  @override
  void initState() {
    super.initState();
    mealDeliveryModel.onFetchUserInfo();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    getLanguageCode();

    _animationController.forward();
  }

  Future<void> getLanguageCode() async {
    String language = await SpUtils.getString('locale') ?? 'zh';
    setState(() {
      languageCode = language;
    });
  }

  // 获取icon
  IconData getIcon(String type) {
    switch (type) {
      case '0':
        return Icons.breakfast_dining;
      case '1':
        return Icons.lunch_dining;
      case '2':
        return Icons.dinner_dining;
      // 夜宵
      case '3':
        return Icons.nightlight_round;
      // 订水
      case '4':
        return Icons.water_drop;
      // 点心
      case '5':
        return Icons.cake;
      // 凌晨餐
      case '6':
        return Icons.bedtime;
      default:
        return Icons.restaurant_menu;
    }
  }

  void _navigateToSubmitPage(String tType) {
    if (tType == '99') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MealDeliverySubmitPage(foodName: tType);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 300),
        ),
      );
    } else {
      mealDeliveryModel.checkCanOrderTime(tType).then((value) {
        if (value) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return MealDeliverySubmitPage(foodName: tType);
              },
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;

                var tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 300),
            ),
          ).then((result) {
            // 处理返回结果
            if (result != null) {
              // 可以在这里处理提交成功后的逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).deliveryOrderSuccess),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        } else {
          ProgressHUD.showError(S.of(context).deliveryOrderNotAvailable);
        }
      });
    }
  }

  void _navigateToWaterPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return MealDeliveryWaterPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    ).then((result) {
      // 处理返回结果
      if (result != null) {
        // 可以在这里处理提交成功后的逻辑
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).deliveryOrderSuccess),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: mealDeliveryModel,
      child: Consumer<MealDeliveryModel>(
        builder: (context, mealDeliveryModel, child) {
          final isLeader =
              mealDeliveryModel.userInfo.mealUser?.roles?.contains('leader') ??
              false;
          final waterOrderTime = mealDeliveryModel.canOrderTimeList.firstWhere(
            (element) => element.tType == '4',
            orElse: () => MealDeliveryTimeListModel(),
          );
          bool waterIsAvailable = _isMealTypeAvailable(
            waterOrderTime,
            isLeader,
          );
          final isTemporaryOrder =
              mealDeliveryModel.userInfo.mealUser?.roles?.contains(
                'temporaryorder',
              ) ??
              false;
          print(
            '1isDriver: ${mealDeliveryModel.isDriver},isCanOrder: ${mealDeliveryModel.isCanOrder},isBindAccount: ${mealDeliveryModel.isBindAccount}',
          );
          return Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            appBar: AppBar(
              title: Text(
                S.of(context).deliveryOrderTitle,
                style: TextStyle(fontSize: 16.px),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            body:
                !mealDeliveryModel.isBindAccount
                    ? Container(
                      padding: EdgeInsets.only(
                        left: 15.px,
                        right: 15.px,
                        top: 15.px,
                        bottom: 15.px,
                      ),
                      width: double.infinity,
                      height: 110.px,
                      margin: EdgeInsets.symmetric(
                        vertical: 50.px,
                        horizontal: 30.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.px),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.px,
                        ),
                      ),
                      // 未绑定帐号权限，请先绑定帐号
                      child: Column(
                        children: [
                          Text(
                            S.of(context).deliveryOrderNotBindAccount,
                            style: TextStyle(
                              fontSize: 14.px,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 10.px),
                          // 绑定帐号
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.px),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.px,
                                  vertical: 5.px,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BindAccountPage(),
                                  ),
                                ).then((result) {
                                  if (result != null) {
                                    mealDeliveryModel.onFetchUserInfo();
                                  }
                                });
                              },
                              child: Text(
                                S.of(context).deliveryBindAccount,
                                style: TextStyle(
                                  fontSize: 12.px,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : mealDeliveryModel.isCanOrder
                    ? FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 欢迎标题
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10.px),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.px),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.restaurant_menu,
                                          color: primaryColor,
                                          size: 24.px,
                                        ),
                                        SizedBox(width: 10.px),
                                        Text(
                                          S.of(context).deliveryOrderTitle,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 18.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.px),
                              // 临时订餐
                              if (isTemporaryOrder)
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 15.px),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.px),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFFFF9800,
                                        ).withOpacity(0.3),
                                        blurRadius: 10.px,
                                        offset: Offset(0, 5.px),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFF9800),
                                        Color(0xFFFF5722),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                        15.px,
                                      ),
                                      onTap: () {
                                        _navigateToSubmitPage('99');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15.px),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // 标题
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .deliveryOrderTemporary,
                                                    style: TextStyle(
                                                      fontSize: 14.px,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 8.px),
                                                  // 时间范围
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8.px,
                                                          vertical: 4.px,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6.px,
                                                          ),
                                                    ),
                                                    child: Text(''),
                                                  ),
                                                  SizedBox(height: 10.px),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8.px,
                                                          vertical: 4.px,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6.px,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .deliveryOrderSubmit,
                                                      style: TextStyle(
                                                        fontSize: 10.px,
                                                        color: Color(
                                                          0xFFFF9800,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 20.px),
                                            // 图标容器
                                            Container(
                                              width: 50.px,
                                              height: 50.px,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      12.px,
                                                    ),
                                              ),
                                              child: Icon(
                                                Icons.person_add,
                                                color: Colors.white,
                                                size: 24.px,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // 订水服务
                              if (mealDeliveryModel.userInfo.mealUser?.roles
                                      ?.contains('orderwater') ??
                                  false)
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 15.px),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.px),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFF4FC3F7,
                                        ).withOpacity(0.3),
                                        blurRadius: 10.px,
                                        offset: Offset(0, 5.px),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4FC3F7),
                                        Color(0xFF29B6F6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                        15.px,
                                      ),
                                      onTap: () {
                                        _navigateToWaterPage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(15.px),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // 标题
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .deliveryWaterService,
                                                    style: TextStyle(
                                                      fontSize: 14.px,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 8.px),
                                                  // 时间范围
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8.px,
                                                          vertical: 4.px,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6.px,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      isLeader
                                                          ? '${waterOrderTime.deptBeginTime} - ${waterOrderTime.deptEndTime}'
                                                          : '${waterOrderTime.beginTime} - ${waterOrderTime.endTime}',
                                                      style: TextStyle(
                                                        fontSize: 11.px,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.px),
                                                  // 描述
                                                  if (!waterIsAvailable)
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .deliveryOrderNotAvailable,
                                                      style: TextStyle(
                                                        fontSize: 10.px,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  else
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8.px,
                                                            vertical: 4.px,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6.px,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .deliveryOrderSubmit,
                                                        style: TextStyle(
                                                          fontSize: 10.px,
                                                          color: Color(
                                                            0xFF4FC3F7,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(width: 20.px),
                                            // 图标容器
                                            Container(
                                              width: 50.px,
                                              height: 50.px,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      12.px,
                                                    ),
                                              ),
                                              child: Icon(
                                                getIcon('4'),
                                                color: Colors.white,
                                                size: 24.px,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // 餐食类型网格
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.px,
                                      mainAxisSpacing: 12.px,
                                      childAspectRatio: 1.1,
                                    ),
                                itemCount:
                                    mealDeliveryModel.foodTypeList.length,
                                itemBuilder: (context, index) {
                                  return _buildMealTypeCard(
                                    mealDeliveryModel.canOrderTimeList,
                                    mealDeliveryModel.foodTypeList[index],
                                    index,
                                    isLeader,
                                  );
                                },
                              ),

                              SizedBox(height: 20.px),

                              // 温馨提示
                              Container(
                                padding: EdgeInsets.all(15.px),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.px),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                    width: 1.px,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.orange,
                                      size: 20.px,
                                    ),
                                    SizedBox(width: 10.px),
                                    Expanded(
                                      child: Text(
                                        S.of(context).deliveryOrderTips,
                                        style: TextStyle(
                                          color: Colors.orange[700],
                                          fontSize: 12.px,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    : Container(
                      padding: EdgeInsets.only(
                        left: 15.px,
                        right: 15.px,
                        top: 15.px,
                        bottom: 15.px,
                      ),
                      width: double.infinity,
                      height: 110.px,
                      margin: EdgeInsets.symmetric(
                        vertical: 50.px,
                        horizontal: 30.px,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.px),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.px,
                        ),
                      ),
                      // 未绑定帐号权限，请先绑定帐号
                      child: Center(
                        child: Text(
                          S.of(context).deliveryOrderNoPermission,
                          style: TextStyle(fontSize: 14.px, color: Colors.grey),
                        ),
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildMealTypeCard(
    List<MealDeliveryTimeListModel> mealTypes,
    DictModel foodType,
    int index,
    bool isLeader,
  ) {
    final mealType = mealTypes.firstWhere(
      (element) => element.tType == foodType.dictValue,
      orElse: () => MealDeliveryTimeListModel(),
    );
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.1;
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, delay + 0.3, curve: Curves.easeOutBack),
          ),
        );

        // 检查当前时间是否在可预订范围内
        final isAvailable = _isMealTypeAvailable(mealType, isLeader);
        return Transform.scale(
          scale: animation.value,
          child: Container(
            decoration: BoxDecoration(
              color: isAvailable ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(15.px),
              boxShadow: [
                BoxShadow(
                  color:
                      isAvailable
                          ? primaryColor.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                  blurRadius: 10.px,
                  offset: Offset(0, 5.px),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15.px),
                onTap:
                    isAvailable
                        ? () {
                          _navigateToSubmitPage(foodType.dictValue ?? '');
                        }
                        : null,
                child: Container(
                  padding: EdgeInsets.all(8.px),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 图标容器
                      Container(
                        width: 50.px,
                        height: 50.px,
                        decoration: BoxDecoration(
                          color:
                              isAvailable
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.px),
                        ),
                        child: Icon(
                          getIcon(foodType.dictValue ?? ''),
                          color: isAvailable ? primaryColor : Colors.grey,
                          size: 24.px,
                        ),
                      ),
                      SizedBox(height: 6.px),

                      // 标题
                      Text(
                        languageCode == 'zh'
                            ? foodType.dictLabel ?? ''
                            : languageCode == 'id'
                            ? foodType.dictLabelId ?? ''
                            : foodType.dictLabelEn ?? '',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? Colors.black87 : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.px),

                      // 时间范围
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.px,
                          vertical: 4.px,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isAvailable
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.px),
                        ),
                        child: Text(
                          isLeader
                              ? '${mealType.deptBeginTime} - ${mealType.deptEndTime}'
                              : '${mealType.beginTime} - ${mealType.endTime}',
                          style: TextStyle(
                            fontSize: 10.px,
                            color: isAvailable ? primaryColor : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.px),

                      // 描述
                      Text(
                        isAvailable
                            ? ''
                            : S.of(context).deliveryOrderNotAvailable,
                        style: TextStyle(
                          fontSize: 10.px,
                          color: isAvailable ? Colors.grey[600] : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isMealTypeAvailable(MealDeliveryTimeListModel mealType, bool isLeader) {
    final now = DateTime.now();
    var startParts = mealType.beginTime?.split(':') ?? [];
    var endParts = mealType.endTime?.split(':') ?? [];

    // 解析起始和结束时间
    if (isLeader) {
      startParts = mealType.deptBeginTime?.split(':') ?? [];
      endParts = mealType.deptEndTime?.split(':') ?? [];
    }

    // 安全检查：确保时间格式正确
    if (startParts.length < 2 || endParts.length < 2) {
      return false;
    }

    try {
      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      final startTime = DateTime(
        now.year,
        now.month,
        now.day,
        startHour,
        startMinute,
      );

      final endTime = DateTime(
        now.year,
        now.month,
        now.day,
        endHour,
        endMinute,
      );

      if (endTime.isAfter(startTime)) {
        // 情况 1：起止在同一天内（如 06:00 - 16:00）
        return now.isAfter(startTime) && now.isBefore(endTime);
      } else {
        // 情况 2：跨天的时间段（如 22:00 - 06:00）
        return now.isAfter(startTime) || now.isBefore(endTime);
      }
    } catch (e) {
      // 如果时间解析失败，返回false
      print('时间解析错误: $e');
      return false;
    }
  }
}
