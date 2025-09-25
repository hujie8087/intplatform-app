import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/book_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

/// 图书卡片组件
/// 用于展示图书信息的卡片式组件
class BookCardWidget extends StatelessWidget {
  const BookCardWidget({
    Key? key,
    required this.bookData,
    this.onTap,
    this.showPrice = true,
    this.showStatus = true,
    this.cardHeight,
  }) : super(key: key);

  final BookModel bookData;
  final VoidCallback? onTap;
  final bool showPrice;
  final bool showStatus;
  final double? cardHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.px),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.px),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.px),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.px),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图书封面
                  _buildBookCover(context),
                  SizedBox(width: 12.px),

                  // 图书信息
                  Expanded(child: _buildBookInfo(context)),
                  SizedBox(width: 8.px),

                  // 状态和操作
                  if (showStatus) _buildBookStatus(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 构建图书封面
  Widget _buildBookCover(BuildContext context) {
    return Container(
      width: 60.px,
      height: 80.px,
      decoration: BoxDecoration(
        color: AppTheme.chipBackground,
        borderRadius: BorderRadius.circular(4.px),
        border: Border.all(color: AppTheme.spacer, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.px),
        child:
            bookData.bookName != null
                ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.nearlyBlue.withOpacity(0.1),
                        AppTheme.nearlyBlue.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book, size: 32.px, color: AppTheme.nearlyBlue),
                      SizedBox(height: 4.h),
                      Text(
                        S.of(context).library_book,
                        style: TextStyle(
                          fontSize: 10.px,
                          color: AppTheme.nearlyBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                : Icon(
                  Icons.image_not_supported,
                  size: 32.px,
                  color: AppTheme.lightText,
                ),
      ),
    );
  }

  // 构建图书信息
  Widget _buildBookInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 书名
        Text(
          bookData.bookName ?? S.of(context).library_book_unknown,
          style: AppTheme.title.copyWith(
            fontSize: 12.px,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.px),

        // 作者
        if (bookData.author != null && bookData.author!.isNotEmpty)
          _buildInfoRow(
            icon: Icons.person,
            text: bookData.author!,
            color: AppTheme.lightText,
          ),

        // 出版社
        if (bookData.publisher != null && bookData.publisher!.isNotEmpty)
          _buildInfoRow(
            icon: Icons.business,
            text: bookData.publisher!,
            color: AppTheme.lightText,
          ),

        // 出版日期
        if (bookData.publicationDate != null &&
            bookData.publicationDate!.isNotEmpty)
          _buildInfoRow(
            icon: Icons.calendar_today,
            text: bookData.publicationDate!,
            color: AppTheme.lightText,
          ),
      ],
    );
  }

  // 构建信息行
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.px),
      child: Row(
        children: [
          Icon(icon, size: 12.px, color: color),
          SizedBox(width: 6.px),
          Expanded(
            child: Text(
              text,
              style: AppTheme.body2.copyWith(fontSize: 10.px, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 构建图书状态
  Widget _buildBookStatus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 状态标签
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.px),
          ),
          child: Text(
            _getStatusText(context),
            style: TextStyle(
              fontSize: 8.px,
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 8.px),

        // 箭头图标
        Icon(Icons.chevron_right, size: 20.px, color: AppTheme.lightText),
      ],
    );
  }

  // 获取状态颜色
  Color _getStatusColor() {
    switch (bookData.rcode) {
      case '0':
        return Colors.green;
      case '1':
        return Colors.orange;
      case '2':
        return Colors.red;
      case '3':
        return Colors.blue;
      default:
        return AppTheme.lightText;
    }
  }

  // 获取地址文本
  String _getStatusText(BuildContext context) {
    switch (bookData.rcode) {
      case '0':
        return S.of(context).library_location_0;
      case '1':
        return S.of(context).library_location_1;
      case '2':
        return S.of(context).library_location_2;
      case '3':
        return S.of(context).library_location_3;
      default:
        return S.of(context).library_location_all;
    }
  }
}

/// 简化版图书卡片组件
/// 用于需要更紧凑布局的场景
class CompactBookCardWidget extends StatelessWidget {
  const CompactBookCardWidget({Key? key, required this.bookData, this.onTap})
    : super(key: key);

  final BookModel bookData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.px,
      margin: EdgeInsets.only(bottom: 8.px),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.px),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.px),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.px),
              border: Border.all(color: AppTheme.spacer, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.px),
              child: Row(
                children: [
                  // 小封面
                  Container(
                    width: 50.px,
                    height: 60.px,
                    decoration: BoxDecoration(
                      color: AppTheme.chipBackground,
                      borderRadius: BorderRadius.circular(6.px),
                    ),
                    child: Icon(
                      Icons.book,
                      size: 20.px,
                      color: AppTheme.nearlyBlue,
                    ),
                  ),
                  SizedBox(width: 12.px),

                  // 图书信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bookData.bookName ??
                              S.of(context).library_book_unknown,
                          style: AppTheme.title.copyWith(
                            fontSize: 14.px,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.px),
                        if (bookData.author != null &&
                            bookData.author!.isNotEmpty)
                          Text(
                            bookData.author!,
                            style: AppTheme.body2.copyWith(
                              fontSize: 12.px,
                              color: AppTheme.lightText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // 状态
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.px,
                      vertical: 2.px,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2.px),
                    ),
                    child: Text(
                      _getStatusText(context),
                      style: TextStyle(
                        fontSize: 9.px,
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (bookData.rcode) {
      case '0':
        return Colors.green;
      case '1':
        return Colors.orange;
      case '2':
        return Colors.red;
      case '3':
        return Colors.blue;
      default:
        return AppTheme.lightText;
    }
  }

  String _getStatusText(BuildContext context) {
    switch (bookData.rcode) {
      case '0':
        return S.of(context).library_location_0;
      case '1':
        return S.of(context).library_location_1;
      case '2':
        return S.of(context).library_location_2;
      case '3':
        return S.of(context).library_location_3;
      default:
        return S.of(context).library_location_all;
    }
  }
}
