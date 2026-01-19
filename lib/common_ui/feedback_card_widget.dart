import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/complaint_message_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

/// 反馈卡片组件 - 重新设计版
class FeedbackCardWidget extends StatelessWidget {
  final ComplaintMessageModel feedback;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const FeedbackCardWidget({
    Key? key,
    required this.feedback,
    this.onTap,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 16.px, left: 4.px, right: 4.px),
      child: Material(
        color: Colors.transparent,
        shadowColor: Color(0xFFE0E0E0).withOpacity(0.5),
        elevation: 8,
        borderRadius: BorderRadius.circular(12.px),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.px),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.px),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部：用户信息 + 状态 + 未读红点
                  _buildTopRow(context),
                  SizedBox(height: 16.px),

                  // 中间：内容
                  _buildContent(context),
                  SizedBox(height: 16.px),

                  // 底部：类型 + 时间
                  _buildBottomRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        // 头像容器
        Container(
          width: 40.px,
          height: 40.px,
          decoration: BoxDecoration(
            color: Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(12.px),
          ),
          child: Icon(Icons.person, size: 22.px, color: Color(0xFF007AFF)),
        ),
        SizedBox(width: 12.px),

        // 名字和电话
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feedback.contacts?.isNotEmpty == true
                    ? feedback.contacts!
                    : S.of(context).not_filled,
                style: TextStyle(
                  fontSize: 15.px,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1D1F),
                ),
              ),
              if (feedback.phone?.isNotEmpty == true)
                Padding(
                  padding: EdgeInsets.only(top: 2.px),
                  child: Text(
                    feedback.phone!,
                    style: TextStyle(fontSize: 12.px, color: Color(0xFF86868B)),
                  ),
                ),
            ],
          ),
        ),

        // 状态标签
        _buildStatusTag(context),

        // 未读红点
        if (feedback.isRead == 1)
          Container(
            margin: EdgeInsets.only(left: 8.px),
            width: 8.px,
            height: 8.px,
            decoration: BoxDecoration(
              color: Color(0xFFFF3B30),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusTag(BuildContext context) {
    String text;
    Color textColor;
    Color bgColor;

    switch (feedback.processingStatus) {
      case 0: // 待回复
        text = S.of(context).reply_status;
        textColor = Color(0xFFFF9500);
        bgColor = Color(0xFFFFF4E5);
        break;
      case 1: // 已回复
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
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.px),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.px,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      feedback.content ?? S.of(context).no_content,
      style: TextStyle(fontSize: 14.px, color: Color(0xFF333333), height: 1.5),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        // 类型标签
        if (feedback.typeId != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 3.px),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    feedback.typeId == 1
                        ? primaryColor.withOpacity(0.3)
                        : secondaryColor.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(6.px),
            ),
            child: Text(
              feedback.typeId == 1
                  ? S.of(context).i_want_to_eat
                  : feedback.typeId == 2
                  ? S.of(context).i_want_to_say
                  : S.of(context).coupleRoom_feedback,
              style: TextStyle(
                fontSize: 11.px,
                color: feedback.typeId == 1 ? primaryColor : secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        Spacer(),

        // 时间
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 12.px, color: Color(0xFF98989D)),
            SizedBox(width: 4.px),
            Text(
              _formatTime(feedback.createTime, context),
              style: TextStyle(fontSize: 12.px, color: Color(0xFF98989D)),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(String? timeStr, BuildContext context) {
    if (timeStr == null || timeStr.isEmpty) return S.of(context).unknown_time;
    try {
      DateTime dateTime = DateTime.parse(timeStr);
      DateTime now = DateTime.now();
      Duration diff = now.difference(dateTime);

      if (diff.inDays > 7) {
        return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      } else if (diff.inDays > 0) {
        return '${diff.inDays}${S.of(context).days_ago}';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}${S.of(context).hours_ago}';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}${S.of(context).minutes_ago}';
      } else {
        return S.of(context).just_now;
      }
    } catch (e) {
      return timeStr;
    }
  }
}
