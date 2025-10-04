import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/book_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

@AppRoute(path: 'library_detail_page', name: '图书馆详情页')
class LibraryDetailPage extends StatefulWidget {
  const LibraryDetailPage({Key? key, required this.noticeId}) : super(key: key);

  final String noticeId;

  @override
  _LibraryDetailPageState createState() => _LibraryDetailPageState();
}

class _LibraryDetailPageState extends State<LibraryDetailPage> {
  BookModel? bookModel;

  @override
  void initState() {
    super.initState();
    getNoticeDetail();
  }

  Future<void> getNoticeDetail() async {
    DataUtils.getDetailById(
      '/other/books/' + widget.noticeId,
      success: (data) {
        bookModel = BookModel.fromJson(data['data']);
        setState(() {});
      },
      fail: (error, message) {
        ProgressHUD.showError(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bookModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).library_book_detail,
            style: TextStyle(fontSize: 16.px),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).library_book_detail,
          style: TextStyle(fontSize: 16.px),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.darkText),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.px),
        child: Column(
          children: [
            // 图书封面和基本信息
            _buildBookHeader(),

            // 图书详细信息
            _buildBookDetails(),

            // 借阅信息
            _buildBorrowInfo(),

            SizedBox(height: 20.px),
          ],
        ),
      ),
    );
  }

  // 构建图书头部信息
  Widget _buildBookHeader() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图书封面
          _buildBookCover(),

          SizedBox(width: 16.px),

          // 图书基本信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 书名
                Text(
                  bookModel?.bookName ?? S.of(context).library_book_unknown,
                  style: AppTheme.title.copyWith(
                    fontSize: 16.px,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 8.px),

                // 作者
                if (bookModel?.author != null && bookModel!.author!.isNotEmpty)
                  _buildInfoRow(
                    icon: Icons.person,
                    label: S.of(context).author,
                    value: bookModel!.author!,
                  ),

                // 出版社
                if (bookModel?.publisher != null &&
                    bookModel!.publisher!.isNotEmpty)
                  _buildInfoRow(
                    icon: Icons.business,
                    label: S.of(context).publisher,
                    value: bookModel!.publisher!,
                  ),

                // 出版日期
                if (bookModel?.publicationDate != null &&
                    bookModel!.publicationDate!.isNotEmpty)
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: S.of(context).publication_date,
                    value: bookModel!.publicationDate!,
                  ),

                SizedBox(height: 12.px),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建图书封面
  Widget _buildBookCover() {
    return Container(
      width: 100.px,
      height: 140.px,
      decoration: BoxDecoration(
        color: AppTheme.chipBackground,
        borderRadius: BorderRadius.circular(8.px),
        border: Border.all(color: AppTheme.spacer, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.px),
        child: Container(
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
              Icon(Icons.book, size: 40.px, color: AppTheme.nearlyBlue),
              SizedBox(height: 8.px),
              Text(
                S.of(context).library_book,
                style: TextStyle(
                  fontSize: 12.px,
                  color: AppTheme.nearlyBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建信息行
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.px),
      child: Row(
        children: [
          Icon(icon, size: 14.px, color: AppTheme.lightText),
          SizedBox(width: 6.px),
          Text(
            '$label: ',
            style: AppTheme.body2.copyWith(
              fontSize: 12.px,
              color: AppTheme.lightText,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.body2.copyWith(
                fontSize: 12.px,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 构建图书详细信息
  Widget _buildBookDetails() {
    return Container(
      margin: EdgeInsets.only(top: 12.px),
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).library_book_info,
            style: AppTheme.title.copyWith(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(height: 16.px),
          // 条形码
          if (bookModel?.code != null && bookModel!.code!.isNotEmpty)
            _buildDetailRow(S.of(context).barcode, bookModel!.code!),

          // 图书编号
          if (bookModel?.bookNo != null && bookModel!.bookNo!.isNotEmpty)
            _buildDetailRow(S.of(context).library_book_no, bookModel!.bookNo!),

          // 版本
          if (bookModel?.edition != null && bookModel!.edition!.isNotEmpty)
            _buildDetailRow(S.of(context).version, bookModel!.edition!),

          // 尺寸
          if (bookModel?.size != null && bookModel!.size!.isNotEmpty)
            _buildDetailRow(S.of(context).size, bookModel!.size!),

          // 类型编号
          if (bookModel?.typeNo != null && bookModel!.typeNo!.isNotEmpty)
            _buildDetailRow(S.of(context).type_no, bookModel!.typeNo!),

          // 价格信息
          if (bookModel?.originalPrice != null ||
              bookModel?.discountedPrice != null)
            _buildPriceRow(),

          // 备注信息
          if (bookModel?.remark != null && bookModel!.remark!.isNotEmpty)
            _buildDescriptionRow(),
        ],
      ),
    );
  }

  // 构建详细信息行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.px,
            child: Text(
              label,
              style: AppTheme.body2.copyWith(
                fontSize: 12.px,
                color: AppTheme.lightText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.body2.copyWith(
                fontSize: 12.px,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建价格信息行
  Widget _buildPriceRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.px,
            child: Text(
              S.of(context).price,
              style: AppTheme.body2.copyWith(
                fontSize: 12.px,
                color: AppTheme.lightText,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (bookModel?.discountedPrice != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.px,
                      vertical: 2.px,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.px),
                    ),
                    child: Text(
                      '¥${bookModel!.discountedPrice}',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (bookModel?.originalPrice != null &&
                    bookModel!.originalPrice != bookModel?.discountedPrice)
                  Padding(
                    padding: EdgeInsets.only(left: 8.px),
                    child: Text(
                      '¥${bookModel!.originalPrice}',
                      style: TextStyle(
                        fontSize: 10.px,
                        color: AppTheme.deactivatedText,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建描述信息行
  Widget _buildDescriptionRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).remark_info,
            style: AppTheme.body2.copyWith(
              fontSize: 12.px,
              color: AppTheme.lightText,
            ),
          ),
          SizedBox(height: 8.px),
          Text(
            bookModel!.remark!,
            style: AppTheme.body2.copyWith(
              fontSize: 12.px,
              color: AppTheme.darkText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // 构建借阅信息
  Widget _buildBorrowInfo() {
    return Container(
      margin: EdgeInsets.only(top: 12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
      ),
      padding: EdgeInsets.all(12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).borrow_info,
            style: AppTheme.title.copyWith(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(height: 16.px),

          // 存放地点
          _buildDetailRow(
            S.of(context).book_location,
            _getLocationText(context),
          ),

          // 创建时间
          if (bookModel?.museumDate != null &&
              bookModel!.museumDate!.isNotEmpty)
            _buildDetailRow(S.of(context).museum_date, bookModel!.museumDate!),

          // 批次
          if (bookModel?.batch != null && bookModel!.batch!.isNotEmpty)
            _buildDetailRow(S.of(context).batch, bookModel!.batch!),

          // 创建人
          if (bookModel?.createBy != null && bookModel!.createBy!.isNotEmpty)
            _buildDetailRow(S.of(context).admin, bookModel!.createBy!),

          // 更新时间
          if (bookModel?.updateTime != null &&
              bookModel!.updateTime!.isNotEmpty)
            _buildDetailRow(S.of(context).update_time, bookModel!.updateTime!),
        ],
      ),
    );
  }

  // 获取地点文本
  String _getLocationText(BuildContext context) {
    switch (bookModel?.rcode) {
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
