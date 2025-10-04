import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
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
      begin: const Offset(0, 0.3),
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 状态卡片
                _buildStatusCard(),
                SizedBox(height: 12.px),

                // 反馈内容卡片
                _buildContentCard(),
                SizedBox(height: 12.px),

                // 联系人信息卡片
                _buildContactCard(),
                SizedBox(height: 12.px),

                // 回复内容卡片（如果有回复）
                if (widget.feedback.processingStatus == 1 &&
                    widget.feedback.processingResults != null &&
                    widget.feedback.processingResults!.isNotEmpty)
                  _buildReplyCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).feedback_detail,
        style: TextStyle(fontSize: 16.px),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16.px,
                color: const Color(0xFF007AFF),
              ),
              SizedBox(width: 2.px),
              Text(
                S.of(context).processing_status,
                style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.px),
          Row(
            children: [
              _buildStatusChip(),
              const Spacer(),
              Text(
                _formatTime(widget.feedback.createTime),
                style: TextStyle(
                  fontSize: 10.px,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    String statusText;
    Color statusColor;
    Color backgroundColor;

    switch (widget.feedback.processingStatus) {
      case 0:
        statusText = S.of(context).reply_status;
        statusColor = const Color(0xFFFF9500);
        backgroundColor = const Color(0xFFFF9500).withOpacity(0.1);
        break;
      case 1:
        statusText = S.of(context).replied;
        statusColor = const Color(0xFF34C759);
        backgroundColor = const Color(0xFF34C759).withOpacity(0.1);
        break;
      default:
        statusText = S.of(context).unknown;
        statusColor = const Color(0xFF8E8E93);
        backgroundColor = const Color(0xFF8E8E93).withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.px, vertical: 2.px),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.px),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.px,
            height: 2.px,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.px),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12.px,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.message_outlined,
                size: 16.px,
                color: const Color(0xFF007AFF),
              ),
              SizedBox(width: 2.px),
              Text(
                S.of(context).feedback_content,
                style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              const Spacer(),
              if (widget.feedback.typeId != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.px,
                    vertical: 4.px,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.feedback.typeId == 1
                            ? primaryColor.withOpacity(0.1)
                            : secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.px),
                  ),
                  child: Text(
                    widget.feedback.typeId == 1
                        ? S.of(context).i_want_to_eat
                        : S.of(context).i_want_to_say,
                    style: TextStyle(
                      fontSize: 12.px,
                      color:
                          widget.feedback.typeId == 1
                              ? primaryColor
                              : secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.px),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.px),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(2.px),
              border: Border.all(color: const Color(0xFFE9ECEF), width: 1.px),
            ),
            child: Text(
              widget.feedback.content ?? S.of(context).no_content,
              style: TextStyle(
                fontSize: 12.px,
                color: const Color(0xFF333333),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16.px,
                color: const Color(0xFF007AFF),
              ),
              SizedBox(width: 2.px),
              Text(
                S.of(context).contact_info,
                style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.px),
          _buildContactItem(
            icon: Icons.person,
            label: S.of(context).contact_info,
            value: widget.feedback.contacts ?? S.of(context).not_filled,
          ),
          SizedBox(height: 6.px),
          _buildContactItem(
            icon: Icons.phone,
            label: S.of(context).phone,
            value: widget.feedback.phone ?? S.of(context).not_filled,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 28.px,
          height: 28.px,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(2.px),
          ),
          child: Icon(icon, size: 16.px, color: const Color(0xFF6C757D)),
        ),
        SizedBox(width: 6.px),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10.px, color: const Color(0xFF999999)),
            ),
            SizedBox(height: 2.px),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.px,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReplyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.reply_outlined,
                size: 12.px,
                color: const Color(0xFF34C759),
              ),
              SizedBox(width: 2.px),
              Text(
                S.of(context).reply_content,
                style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              const Spacer(),
              if (widget.feedback.handleBy != null &&
                  widget.feedback.handleBy!.isNotEmpty)
                Text(
                  '${S.of(context).reply_person}: ${widget.feedback.handleBy}',
                  style: TextStyle(
                    fontSize: 12.px,
                    color: const Color(0xFF007AFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (widget.feedback.handleBy != null &&
                  widget.feedback.handleBy!.isNotEmpty)
                SizedBox(width: 8.px),
              if (widget.feedback.handleTime != null)
                Text(
                  _formatTime(widget.feedback.handleTime),
                  style: TextStyle(
                    fontSize: 12.px,
                    color: const Color(0xFF999999),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.px),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.px),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(2.px),
              border: Border.all(
                color: const Color(0xFF34C759).withOpacity(0.2),
                width: 1.px,
              ),
            ),
            child: Text(
              widget.feedback.processingResults!,
              style: TextStyle(
                fontSize: 12.px,
                color: const Color(0xFF333333),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return S.of(context).unknown_time;

    try {
      DateTime dateTime = DateTime.parse(timeStr);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} ${S.of(context).days_ago}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${S.of(context).hours_ago}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${S.of(context).minutes_ago}';
      } else {
        return S.of(context).just_now;
      }
    } catch (e) {
      return S.of(context).unknown_time;
    }
  }
}
