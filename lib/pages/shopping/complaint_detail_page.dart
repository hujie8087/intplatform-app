import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/contact_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintDetailPage extends StatelessWidget {
  final ContactModel contact;

  const ComplaintDetailPage({Key? key, required this.contact})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).complaint_detail,
          style: TextStyle(fontSize: 16.px),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.px),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.px),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.px),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.08),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72.px,
                    height: 72.px,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (contact.def1?.isNotEmpty == true)
                          ? contact.def1!.substring(0, 1)
                          : '名',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 32.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.px),
                  Text(
                    contact.name ?? S.of(context).unknownName,
                    style: TextStyle(
                      fontSize: 22.px,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.px),
            _buildInfoCard([
              _buildInfoRow(
                Icons.phone_iphone,
                S.of(context).phone,
                contact.tel,
                isPhone: true,
              ),
              _buildInfoRow(
                Icons.email_outlined,
                S.of(context).email,
                contact.email,
              ),
              _buildInfoRow(
                Icons.access_time,
                S.of(context).workTime,
                contact.workTime,
              ),
            ]),
            SizedBox(height: 16.px),
            _buildInfoCard([
              _buildInfoRow(
                Icons.assignment_ind_outlined,
                S.of(context).dutyScope,
                contact.def1,
              ),
              _buildInfoRow(
                Icons.location_on_outlined,
                S.of(context).officeLocation,
                contact.def2,
              ),
              _buildInfoRow(
                Icons.note_alt_outlined,
                S.of(context).remark,
                contact.remark,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String? value, {
    bool isPhone = false,
  }) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.px, color: Colors.blueGrey[300]),
          SizedBox(width: 12.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.px, color: Colors.grey[500]),
                ),
                SizedBox(height: 4.px),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.px,
                    color: isPhone ? Colors.blue : Colors.black87,
                    fontWeight: isPhone ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isPhone)
            InkWell(
              onTap: () async {
                // 调用电话
                final Uri phoneUri = Uri(scheme: 'tel', path: contact.tel);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  ProgressHUD.showError('无法拨打电话');
                }
              },
              child: Container(
                padding: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.phone, size: 18.px, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
