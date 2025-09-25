import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/good_deed_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

@AppRoute(path: 'good_deeds_detail_page', name: '好人好事详情页')
class GoodDeedsDetailPage extends StatefulWidget {
  const GoodDeedsDetailPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _GoodDeedsDetailPageState createState() => _GoodDeedsDetailPageState();
}

class _GoodDeedsDetailPageState extends State<GoodDeedsDetailPage> {
  GoodDeedModel? goodDeedModel;
  bool _isLiked = false;
  int _currentLikesCount = 0;

  @override
  void initState() {
    super.initState();
    getGoodDeedDetail();
  }

  Future<void> getGoodDeedDetail() async {
    DataUtils.getDetailById(
      '/other/deeds/' + widget.id,
      success: (data) {
        goodDeedModel = GoodDeedModel.fromJson(data['data']);
        _currentLikesCount =
            int.tryParse(goodDeedModel?.likesCount ?? '0') ?? 0;
        setState(() {});
      },
      fail: (error, message) {
        ProgressHUD.showError(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (goodDeedModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).good_deeds_detail,
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
          S.of(context).good_deeds_detail,
          style: TextStyle(fontSize: 16.px),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.darkText),
      ),
      body: Column(
        children: [
          // 内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12.px),
              child: Column(
                children: [
                  // 标题和状态
                  _buildHeaderSection(),

                  SizedBox(height: 8.px),

                  // 描述内容
                  _buildContentSection(),

                  SizedBox(height: 8.px),

                  // 个人信息
                  _buildPersonInfoSection(),

                  SizedBox(height: 20.px),
                ],
              ),
            ),
          ),

          // 底部点赞区域
          _buildBottomLikeSection(),
        ],
      ),
    );
  }

  // 构建头部区域
  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和状态
          Row(
            children: [
              Expanded(
                child: Text(
                  goodDeedModel?.title ?? S.of(context).unknown_title,
                  style: AppTheme.title.copyWith(
                    fontSize: 16.px,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6.px),
            ],
          ),

          SizedBox(height: 12.px),

          // 创建时间
          if (goodDeedModel?.createTime != null &&
              goodDeedModel!.createTime!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.access_time, size: 14.px, color: AppTheme.lightText),
                SizedBox(width: 6.px),
                Text(
                  goodDeedModel!.createTime!,
                  style: AppTheme.body2.copyWith(
                    fontSize: 12.px,
                    color: AppTheme.lightText,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // 构建内容区域
  Widget _buildContentSection() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).detailed_description,
            style: AppTheme.title.copyWith(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(height: 8.px),

          Text(
            goodDeedModel?.description ?? S.of(context).no_description,
            style: AppTheme.body2.copyWith(
              fontSize: 12.px,
              color: AppTheme.darkText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // 构建个人信息区域
  Widget _buildPersonInfoSection() {
    return Container(
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).personal_info,
            style: AppTheme.title.copyWith(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(height: 8.px),

          // 姓名
          if (goodDeedModel?.personName != null &&
              goodDeedModel!.personName!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.person,
              label: S.of(context).name,
              value: goodDeedModel!.personName!,
              color: Colors.blue.shade600,
            ),

          // 联系方式
          if (goodDeedModel?.contactInfo != null &&
              goodDeedModel!.contactInfo!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.phone,
              label: S.of(context).contact_info,
              value: goodDeedModel!.contactInfo!,
              color: Colors.green.shade600,
            ),

          // 备注
          if (goodDeedModel?.remark != null &&
              goodDeedModel!.remark!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.note,
              label: S.of(context).remark,
              value: goodDeedModel!.remark!,
              color: Colors.orange.shade600,
            ),
        ],
      ),
    );
  }

  // 构建底部点赞区域
  Widget _buildBottomLikeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 点赞按钮
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _handleLike,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isLiked ? Colors.red.shade400 : Colors.grey.shade200,
                foregroundColor: _isLiked ? Colors.white : Colors.grey.shade600,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12.px),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.px),
                ),
              ),
              icon: Icon(
                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 16.px,
              ),
              label: Text(
                _isLiked ? S.of(context).liked : S.of(context).like,
                style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          SizedBox(width: 12.px),

          // 点赞数量显示
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8.px),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 16.px, color: Colors.red.shade400),
                SizedBox(width: 4.px),
                Text(
                  '$_currentLikesCount',
                  style: TextStyle(
                    fontSize: 14.px,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建信息行
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.px, color: color),
          SizedBox(width: 8.px),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13.px,
              color: AppTheme.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.px,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 处理点赞
  void _handleLike() {
    if (!_isLiked) {
      DataUtils.likeGoodDeed(
        widget.id,
        success: (data) {
          _currentLikesCount++;
          ProgressHUD.showSuccess(S.of(context).likeSuccess);
          setState(() {
            _isLiked = true;
          });
        },
      );
    } else {
      ProgressHUD.showSuccess(S.of(context).liked);
    }
  }
}
