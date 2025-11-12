import 'package:flutter/material.dart';
import 'package:logistics_app/pages/sos/chat_list_page.dart';
import 'package:logistics_app/pages/sos/models/chat_list_model.dart';
import 'package:logistics_app/pages/sos/widgets/info_card.dart';
import 'package:logistics_app/pages/sos/widgets/sos_button.dart';
import 'package:logistics_app/pages/sos/widgets/contact_options.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
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

  // 上传图片
  // Future<void> _uploadImage() async {
  //   // final result = await HJBottomSheet.wxPicker(context, [], 1);
  //   final result = await Picker.assetsCamera(context: context);
  //   print('result: $result');
  //   if (result != null) {
  //     ProgressHUD.showLoadingText('上传图片...');
  //     try {
  //       final fileUrl = await uploadMealDeliveryFile([result]);
  //       ProgressHUD.hide();
  //       if (fileUrl.isNotEmpty) {
  //         chatListModel.reportImage = fileUrl[0];
  //         setState(() {});
  //       }
  //     } catch (e) {
  //       ProgressHUD.showError('上传图片失败: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS紧急报警',
          style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListPage()),
                ),
            tooltip: '聊天列表',
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
      body: ChangeNotifierProvider.value(
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
                              () =>
                                  chatListModel.triggerEmergencyAlarm(context),
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
                                        () =>
                                            chatListModel.makePhoneCall('110'),
                                    onChat:
                                        () => chatListModel.startEmergencyChat(
                                          context,
                                        ),
                                    onVoiceMessage: () => {},
                                  )
                                  : const SizedBox(key: ValueKey('empty')),
                        ),
                        SizedBox(height: 10.px),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(16.px),
                          margin: EdgeInsets.only(bottom: 30.px),
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
                                  '请勿滥用紧急报警功能，虚假报警将承担相应责任',
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
    );
  }
}
