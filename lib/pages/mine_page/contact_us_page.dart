import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/contact_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:url_launcher/url_launcher.dart';

@AppRoute(path: 'contact_us_page', name: '联系我们')
class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  List<ContactModel> _contactList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    DataUtils.getPageList(
      '/system/connect/list',
      {'pageNum': 1, 'pageSize': 100},
      success: (data) {
        setState(() {
          var contactList = data['rows'] as List;
          _contactList =
              contactList.map((e) => ContactModel.fromJson(e)).toList();
          _isLoading = false;
        });
      },
      fail: (code, msg) {
        setState(() {
          _isLoading = false;
        });
        ProgressHUD.showError(msg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).contactUs, style: TextStyle(fontSize: 16.px)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.darkText),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.all(14.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 页面说明
                      _buildPageDescription(),

                      SizedBox(height: 18.px),

                      // 联系方式列表
                      _buildContactList(),

                      SizedBox(height: 18.px),
                    ],
                  ),
                ),
      ),
    );
  }

  // 构建页面说明
  Widget _buildPageDescription() {
    return Container(
      padding: EdgeInsets.all(14.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.px),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.px),
            ),
            child: Icon(
              Icons.contact_support,
              color: primaryColor,
              size: 18.px,
            ),
          ),
          SizedBox(width: 10.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '联系我们',
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                SizedBox(height: 2.px),
                Text(
                  '如有问题，请联系相关负责人',
                  style: TextStyle(fontSize: 10.px, color: AppTheme.lightText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建联系方式列表
  Widget _buildContactList() {
    if (_contactList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(30.px),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.contact_phone,
                size: 46.px,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 14.px),
              Text(
                '暂无联系方式',
                style: TextStyle(fontSize: 12.px, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '负责人联系方式',
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkText,
          ),
        ),
        SizedBox(height: 10.px),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _contactList.length,
          itemBuilder: (context, index) {
            return _buildContactCard(_contactList[index]);
          },
        ),
      ],
    );
  }

  // 构建联系人卡片
  Widget _buildContactCard(ContactModel contact) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.px),
      padding: EdgeInsets.all(14.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.px),
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
          // 负责人姓名和职位
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.px),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.px),
                ),
                child: Icon(Icons.person, color: primaryColor, size: 16.px),
              ),
              SizedBox(width: 10.px),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name ?? '未知负责人',
                      style: TextStyle(
                        fontSize: 14.px,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    if (contact.details != null && contact.details!.isNotEmpty)
                      Text(
                        contact.details!,
                        style: TextStyle(
                          fontSize: 10.px,
                          color: AppTheme.lightText,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.px),

          // 联系方式
          if (contact.tel != null && contact.tel!.isNotEmpty)
            _buildContactItem(
              icon: Icons.phone,
              label: '电话',
              value: contact.tel!,
              onTap: () => _makePhoneCall(contact.tel!),
              color: Colors.green.shade600,
            ),

          if (contact.email != null && contact.email!.isNotEmpty)
            _buildContactItem(
              icon: Icons.email,
              label: '邮箱',
              value: contact.email!,
              onTap: () => _sendEmail(contact.email!),
              color: Colors.blue.shade600,
            ),

          if (contact.workTime != null && contact.workTime!.isNotEmpty)
            _buildContactItem(
              icon: Icons.schedule,
              label: '工作时间',
              value: contact.workTime!,
              color: Colors.orange.shade600,
            ),

          if (contact.remark != null && contact.remark!.isNotEmpty)
            _buildContactItem(
              icon: Icons.note,
              label: '备注',
              value: contact.remark!,
              color: Colors.purple.shade600,
            ),
        ],
      ),
    );
  }

  // 构建联系方式项
  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.px),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.px),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 6.px),
          decoration: BoxDecoration(
            color: onTap != null ? color.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.px),
            border:
                onTap != null
                    ? Border.all(color: color.withOpacity(0.2))
                    : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 14.px, color: color),
              SizedBox(width: 6.px),
              Text(
                '$label：',
                style: TextStyle(
                  fontSize: 10.px,
                  color: AppTheme.lightText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 10.px,
                    color: onTap != null ? color : AppTheme.darkText,
                    fontWeight:
                        onTap != null ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              if (onTap != null)
                Icon(Icons.arrow_forward_ios, size: 10.px, color: color),
            ],
          ),
        ),
      ),
    );
  }

  // 拨打电话
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ProgressHUD.showError('无法拨打电话');
    }
  }

  // 发送邮件
  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=咨询&body=您好，我想咨询...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ProgressHUD.showError('无法发送邮件');
    }
  }
}
