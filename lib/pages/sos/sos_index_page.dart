import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/pages/sos/chat_list_page.dart';
import 'package:logistics_app/pages/sos/models/chat_list_model.dart';
import 'package:logistics_app/pages/sos/widgets/contact_options.dart';
import 'package:logistics_app/pages/sos/widgets/info_card.dart';
import 'package:logistics_app/pages/sos/widgets/sos_button.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:provider/provider.dart';

class SosIndexPage extends StatefulWidget {
  const SosIndexPage({Key? key}) : super(key: key);

  @override
  _SosIndexPage createState() => _SosIndexPage();
}

class _SosIndexPage extends State<SosIndexPage> with TickerProviderStateMixin {
  ChatListModel chatListModel = ChatListModel();

  @override
  void initState() {
    super.initState();
    chatListModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.sos_emergency_alarm,
          style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListPage()),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 12.px),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.chat_bubble_outline, size: 16.px),
                SizedBox(width: 3.px),
                Text('记录', style: TextStyle(fontSize: 12.px)),
              ],
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [secondaryColor, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: ChangeNotifierProvider.value(
          value: chatListModel,
          child: Consumer<ChatListModel>(
            builder: (context, chatListModel, child) {
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                      Color(0xFF0f3460),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(16.px),
                      height: MediaQuery.of(context).size.height - 100.px,
                      child: Column(
                        children: [
                          if (!chatListModel.isAlarmTriggered) InfoCard(),

                          SOSButton(
                            onPressed:
                                () => chatListModel.triggerEmergencyAlarm(
                                  context,
                                ),
                            isDisabled: chatListModel.isAlarmTriggered,
                          ),

                          SizedBox(height: 10.px),

                          // 动画切换部分
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, 0.3.px),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child:
                                chatListModel.isAlarmTriggered
                                    ? ContactOptions(
                                      key: const ValueKey('contact-options'),
                                      onPhoneCall:
                                          () => {
                                            if (chatListModel
                                                    .contactList
                                                    .length >
                                                1)
                                              {
                                                // 显示联系人选择弹窗
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    final contactCount =
                                                        chatListModel
                                                            .contactList
                                                            .length;
                                                    final screenHeight =
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height;
                                                    final safeAreaBottom =
                                                        MediaQuery.of(
                                                          context,
                                                        ).padding.bottom;
                                                    final maxHeight =
                                                        screenHeight * 0.85;
                                                    final itemHeight = 60.0;
                                                    final headerHeight = 65.0;
                                                    final calculatedHeight =
                                                        (contactCount *
                                                                    itemHeight +
                                                                headerHeight +
                                                                safeAreaBottom)
                                                            .clamp(
                                                              0.0,
                                                              maxHeight,
                                                            );

                                                    return Container(
                                                      height:
                                                          calculatedHeight +
                                                          20.px,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    20.px,
                                                                  ),
                                                              topRight:
                                                                  Radius.circular(
                                                                    20.px,
                                                                  ),
                                                            ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // 拖拽指示器
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                  top: 8.px,
                                                                  bottom: 6.px,
                                                                ),
                                                            width: 40.px,
                                                            height: 4.px,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors
                                                                      .grey[300],
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    2.px,
                                                                  ),
                                                            ),
                                                          ),
                                                          // 标题
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      16.px,
                                                                  vertical:
                                                                      12.px,
                                                                ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .phone_outlined,
                                                                  size: 18.px,
                                                                  color:
                                                                      Colors
                                                                          .grey[700],
                                                                ),
                                                                SizedBox(
                                                                  width: 6.px,
                                                                ),
                                                                Text(
                                                                  S
                                                                      .current
                                                                      .select_contact_method,
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        16.px,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        Colors
                                                                            .grey[900],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 1,
                                                            thickness: 1,
                                                            color:
                                                                Colors
                                                                    .grey[200],
                                                          ),
                                                          // 联系人列表
                                                          Flexible(
                                                            child: ListView.separated(
                                                              shrinkWrap: true,
                                                              padding:
                                                                  EdgeInsets.only(
                                                                    bottom:
                                                                        safeAreaBottom,
                                                                  ),
                                                              itemCount:
                                                                  contactCount,
                                                              separatorBuilder:
                                                                  (
                                                                    context,
                                                                    index,
                                                                  ) => Divider(
                                                                    height: 1,
                                                                    thickness:
                                                                        1,
                                                                    indent:
                                                                        60.px,
                                                                    color:
                                                                        Colors
                                                                            .grey[100],
                                                                  ),
                                                              itemBuilder: (
                                                                context,
                                                                index,
                                                              ) {
                                                                final contact =
                                                                    chatListModel
                                                                        .contactList[index];
                                                                return InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    chatListModel
                                                                        .makePhoneCall(
                                                                          contact
                                                                              .tel,
                                                                        );
                                                                  },
                                                                  child: Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16.px,
                                                                      vertical:
                                                                          12.px,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        // 头像/图标
                                                                        Container(
                                                                          width:
                                                                              40.px,
                                                                          height:
                                                                              40.px,
                                                                          decoration: BoxDecoration(
                                                                            color: secondaryColor.withOpacity(
                                                                              0.1,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                          child: Icon(
                                                                            Icons.person,
                                                                            color:
                                                                                secondaryColor,
                                                                            size:
                                                                                20.px,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              12.px,
                                                                        ),
                                                                        // 联系人信息
                                                                        Expanded(
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                contact.name ??
                                                                                    '未知联系人',
                                                                                style: TextStyle(
                                                                                  fontSize:
                                                                                      15.px,
                                                                                  fontWeight:
                                                                                      FontWeight.w600,
                                                                                  color:
                                                                                      Colors.grey[900],
                                                                                ),
                                                                                maxLines:
                                                                                    1,
                                                                                overflow:
                                                                                    TextOverflow.ellipsis,
                                                                              ),
                                                                              SizedBox(
                                                                                height:
                                                                                    3.px,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.phone,
                                                                                    size:
                                                                                        12.px,
                                                                                    color:
                                                                                        Colors.grey[600],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width:
                                                                                        4.px,
                                                                                  ),
                                                                                  Text(
                                                                                    contact.tel ??
                                                                                        '',
                                                                                    style: TextStyle(
                                                                                      fontSize:
                                                                                          13.px,
                                                                                      color:
                                                                                          Colors.grey[600],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        // 箭头图标
                                                                        Icon(
                                                                          Icons
                                                                              .chevron_right,
                                                                          color:
                                                                              Colors.grey[400],
                                                                          size:
                                                                              20.px,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.px,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              }
                                            else
                                              {
                                                chatListModel.makePhoneCall(
                                                  chatListModel
                                                      .contactList
                                                      .first
                                                      .tel,
                                                ),
                                              },
                                          },
                                      onChat:
                                          () => {
                                            chatListModel.enterChat(
                                              context,
                                              chatListModel.currentSessionId ??
                                                  '',
                                            ),
                                          },
                                      onVoiceMessage: () => {},
                                    )
                                    : const SizedBox(key: ValueKey('empty')),
                          ),
                          SizedBox(height: 10.px),
                          // 当已经报警时，可以结束报警状态
                          if (chatListModel.isAlarmTriggered)
                            ElevatedButton(
                              onPressed:
                                  () => {
                                    // 弹窗确认框
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text(S.current.end_alarm),
                                            content: Text(
                                              S.current.confirm_end_alarm,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text(S.current.cancel),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => {
                                                      chatListModel
                                                              .isAlarmTriggered =
                                                          false,
                                                      SpUtils.saveBool(
                                                        'isAlarmTriggered',
                                                        false,
                                                      ),
                                                      chatListModel
                                                              .currentSessionId =
                                                          null,
                                                      SpUtils.remove(
                                                        'currentSessionId',
                                                      ),
                                                      Navigator.pop(context),
                                                      // 刷新当前页面
                                                      RouteUtils.refreshCurrentPage(),
                                                    },
                                                child: Text(S.current.confirm),
                                              ),
                                            ],
                                          ),
                                    ),
                                  },
                              child: Text('结束报警'),
                            ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(12.px),
                            margin: EdgeInsets.only(bottom: 70.px),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14.px),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 16.px,
                                ),
                                SizedBox(width: 8.px, height: 8.px),
                                Expanded(
                                  child: Text(
                                    S.current.sos_alarm_tips,
                                    style: TextStyle(
                                      fontSize: 12.px,
                                      color: Colors.white.withOpacity(0.8),
                                      height: 1.4,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //
}
