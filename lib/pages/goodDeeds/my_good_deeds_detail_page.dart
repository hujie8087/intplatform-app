import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/good_deed_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

@AppRoute(path: 'good_deeds_detail_page', name: '好人好事详情页')
class MyGoodDeedsDetailPage extends StatefulWidget {
  const MyGoodDeedsDetailPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  _MyGoodDeedsDetailPageState createState() => _MyGoodDeedsDetailPageState();
}

class _MyGoodDeedsDetailPageState extends State<MyGoodDeedsDetailPage> {
  GoodDeedModel? goodDeedModel;

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
          title: Text('我的发布详情', style: TextStyle(fontSize: 16.px)),
          backgroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('我的发布详情', style: TextStyle(fontSize: 16.px)),
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

                  SizedBox(height: 8.px),

                  // 审核信息
                  if (goodDeedModel?.status != 0) _buildAuditSection(),

                  SizedBox(height: 20.px),
                ],
              ),
            ),
          ),
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
                  goodDeedModel?.title ?? '未知标题',
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
              _buildStatusTag(goodDeedModel?.status),
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
            '详细描述',
            style: AppTheme.title.copyWith(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(height: 8.px),

          Text(
            goodDeedModel?.description ?? '暂无描述',
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
            '个人信息',
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
              label: '姓名',
              value: goodDeedModel!.personName!,
              color: Colors.blue.shade600,
            ),

          // 联系方式
          if (goodDeedModel?.contactInfo != null &&
              goodDeedModel!.contactInfo!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.phone,
              label: '联系方式',
              value: goodDeedModel!.contactInfo!,
              color: Colors.green.shade600,
            ),

          // 备注
          if (goodDeedModel?.remark != null &&
              goodDeedModel!.remark!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.note,
              label: '备注',
              value: goodDeedModel!.remark!,
              color: Colors.orange.shade600,
            ),
        ],
      ),
    );
  }

  // 构建审核信息区域
  Widget _buildAuditSection() {
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
            '审核信息',
            style: AppTheme.title.copyWith(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(height: 8.px),

          // 审核时间
          if (goodDeedModel?.auditTime != null &&
              goodDeedModel!.auditTime!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.schedule,
              label: '审核时间',
              value: goodDeedModel!.auditTime!,
              color: Colors.purple.shade600,
            ),

          // 审核人
          if (goodDeedModel?.auditUser != null &&
              goodDeedModel!.auditUser!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.person_outline,
              label: '审核人',
              value: goodDeedModel!.auditUser!,
              color: Colors.teal.shade600,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16.px, color: color),
          SizedBox(width: 8.px),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12.px,
              color: AppTheme.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.px,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建状态标签
  Widget _buildStatusTag(int? status) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 0:
        statusColor = Colors.orange;
        statusText = '待审核';
        statusIcon = Icons.schedule;
        break;
      case 1:
        statusColor = Colors.green;
        statusText = '已通过';
        statusIcon = Icons.check_circle;
        break;
      case 2:
        statusColor = Colors.red;
        statusText = '已拒绝';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = '未知';
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 6.px),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14.px, color: statusColor),
          SizedBox(width: 4.px),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12.px,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
