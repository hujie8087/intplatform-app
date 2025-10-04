import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/complaint_message_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

/// 反馈卡片组件
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
      margin: margin ?? EdgeInsets.only(bottom: 12.px),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.px),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.px),
          child: Container(
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
            child: Padding(
              padding: EdgeInsets.all(16.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 头部信息：联系人和状态
                  _buildHeader(context),
                  SizedBox(height: 12.px),

                  // 反馈内容
                  _buildContent(context),
                  SizedBox(height: 12.px),

                  // 底部信息：时间和类型
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建头部信息
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // 联系人信息
        Expanded(
          child: Row(
            children: [
              // 联系人图标
              Container(
                width: 32.px,
                height: 32.px,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.px),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 18.px,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 8.px),

              // 联系人姓名和电话
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback.contacts ?? S.of(context).not_filled,
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    if (feedback.phone != null && feedback.phone!.isNotEmpty)
                      Text(
                        feedback.phone!,
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Color(0xFF666666),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 处理状态
        _buildStatusChip(context),
      ],
    );
  }

  /// 构建状态标签
  Widget _buildStatusChip(BuildContext context) {
    String statusText;
    Color statusColor;
    Color backgroundColor;

    switch (feedback.processingStatus) {
      case 0:
        statusText = S.of(context).reply_status;
        statusColor = Color(0xFFFF9500);
        backgroundColor = Color(0xFFFF9500).withOpacity(0.1);
        break;
      case 1:
        statusText = S.of(context).replied;
        statusColor = Color(0xFF007AFF);
        backgroundColor = Color(0xFF007AFF).withOpacity(0.1);
        break;
      default:
        statusText = S.of(context).unknown;
        statusColor = Color(0xFF8E8E93);
        backgroundColor = Color(0xFF8E8E93).withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11.px,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  /// 构建反馈内容
  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.px),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8.px),
      ),
      child: Text(
        feedback.content ?? S.of(context).no_content,
        style: TextStyle(
          fontSize: 12.px,
          color: Color(0xFF333333),
          height: 1.4,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 构建底部信息
  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // 反馈类型
        if (feedback.typeId != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.px, vertical: 2.px),
            decoration: BoxDecoration(
              color:
                  feedback.typeId == 1
                      ? primaryColor.withOpacity(0.1)
                      : secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.px),
            ),
            child: Text(
              feedback.typeId == 1
                  ? S.of(context).i_want_to_eat
                  : S.of(context).i_want_to_say,
              style: TextStyle(
                fontSize: 12.px,
                color: feedback.typeId == 1 ? primaryColor : secondaryColor,
              ),
            ),
          ),

        if (feedback.typeId != null) SizedBox(width: 8.px),

        // 创建时间
        Expanded(
          child: Text(
            _formatTime(feedback.createTime, context),
            style: TextStyle(fontSize: 12.px, color: Color(0xFF999999)),
          ),
        ),

        // 箭头图标
        Icon(Icons.chevron_right, size: 16.px, color: Color(0xFFCCCCCC)),
      ],
    );
  }

  /// 格式化时间
  String _formatTime(String? timeStr, BuildContext context) {
    if (timeStr == null || timeStr.isEmpty) return S.of(context).unknown_time;

    try {
      DateTime dateTime = DateTime.parse(timeStr);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inDays > 10) {
        return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      }

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
      return timeStr;
    }
  }
}
