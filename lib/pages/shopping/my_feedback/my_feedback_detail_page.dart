import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/complaint_message_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class MyFeedbackDetailPage extends StatefulWidget {
  final ComplaintMessageModel feedback;

  const MyFeedbackDetailPage({super.key, required this.feedback});

  @override
  State<MyFeedbackDetailPage> createState() => _MyFeedbackDetailPageState();
}

class _MyFeedbackDetailPageState extends State<MyFeedbackDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // 更柔和的背景色
      appBar: AppBar(
        title: Text(
          S.of(context).feedback_detail,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1D1D1F)),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.px),
            child: Column(
              children: [
                // 主要内容卡片
                _buildMainCard(),
                SizedBox(height: 12.px),

                // 回复卡片
                if (widget.feedback.processingStatus == 1 &&
                    widget.feedback.processingResults != null &&
                    widget.feedback.processingResults!.isNotEmpty)
                  _buildReplyCard(),

                SizedBox(height: 12.px),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.px,
            offset: Offset(0, 4.px),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部：类型 + 状态 + 时间
          Row(children: [_buildTypeTag(), Spacer(), _buildStatusTag()]),
          SizedBox(height: 12.px),

          // 用户信息
          Row(
            children: [
              Container(
                width: 40.px,
                height: 40.px,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F7FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 20.px,
                  color: Color(0xFF007AFF),
                ),
              ),
              SizedBox(width: 10.px),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feedback.contacts ?? S.of(context).not_filled,
                    style: TextStyle(
                      fontSize: 14.px,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                  SizedBox(height: 6.px),
                  Text(
                    _formatTime(widget.feedback.createTime),
                    style: TextStyle(fontSize: 11.px, color: Color(0xFF86868B)),
                  ),
                  SizedBox(height: 6.px),
                  if (widget.feedback.phone != null ||
                      widget.feedback.phone!.isNotEmpty)
                    Text(
                      widget.feedback.phone!,
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Color(0xFF86868B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.px),

          Divider(height: 1, color: Color(0xFFEBEDF0)),
          SizedBox(height: 16.px),

          // 反馈内容
          Text(
            widget.feedback.content ?? S.of(context).no_content,
            style: TextStyle(
              fontSize: 14.px,
              color: Color(0xFF333333),
              height: 1.6,
            ),
          ),
          if (widget.feedback.def4 != null &&
              widget.feedback.def4!.isNotEmpty) ...[
            SizedBox(height: 12.px),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.px),
              child: Image.network(
                APIs.imagePrefix + widget.feedback.def4!,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.px,
            offset: Offset(0, 4.px),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.px),
        child: Column(
          children: [
            // 回复标题栏
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
              decoration: BoxDecoration(
                color: Color(0xFFF2F9F5), // 浅绿色背景头
                border: Border(bottom: BorderSide(color: Color(0xFFE0F2E9))),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 18.px,
                    color: Color(0xFF34C759),
                  ),
                  SizedBox(width: 8.px),
                  Text(
                    S.of(context).reply_content, // "官方回复"
                    style: TextStyle(
                      fontSize: 14.px,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF34C759),
                    ),
                  ),
                  Spacer(),
                  if (widget.feedback.handleTime != null)
                    Text(
                      _formatTime(widget.feedback.handleTime),
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Color(0xFF34C759).withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),

            // 回复内容
            Padding(
              padding: EdgeInsets.all(16.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feedback.processingResults!,
                    style: TextStyle(
                      fontSize: 14.px,
                      color: Color(0xFF333333),
                      height: 1.6,
                    ),
                  ),
                  // 回复图片
                  if (widget.feedback.def3 != null &&
                      widget.feedback.def3!.isNotEmpty) ...[
                    SizedBox(height: 12.px),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.px),
                      child: Image.network(
                        APIs.imagePrefix + widget.feedback.def3!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],

                  SizedBox(height: 12.px),
                  if (widget.feedback.handleBy != null &&
                      widget.feedback.handleBy!.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${S.of(context).reply_person}: ${widget.feedback.handleBy}',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Color(0xFF86868B),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 4.px),
      decoration: BoxDecoration(
        color:
            widget.feedback.typeId == 1
                ? primaryColor.withOpacity(0.1)
                : secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.px),
      ),
      child: Text(
        widget.feedback.typeId == 1
            ? S.of(context).i_want_to_eat
            : S.of(context).i_want_to_say,
        style: TextStyle(
          fontSize: 12.px,
          fontWeight: FontWeight.w600,
          color: widget.feedback.typeId == 1 ? primaryColor : secondaryColor,
        ),
      ),
    );
  }

  Widget _buildStatusTag() {
    String text;
    Color textColor;
    Color bgColor;

    switch (widget.feedback.processingStatus) {
      case 0:
        text = S.of(context).reply_status;
        textColor = Color(0xFFFF9500);
        bgColor = Color(0xFFFFF4E5);
        break;
      case 1:
        text = S.of(context).replied;
        textColor = Color(0xFF007AFF);
        bgColor = Color(0xFFE5F1FF);
        break;
      default:
        text = S.of(context).unknown;
        textColor = Color(0xFF8E8E93);
        bgColor = Color(0xFFF2F2F7);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 4.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.px),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.px,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "";
    try {
      DateTime dateTime = DateTime.parse(timeStr);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour}:${dateTime.minute}";
    } catch (e) {
      return timeStr;
    }
  }
}
