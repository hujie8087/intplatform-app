import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';

import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/contact_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/pages/shopping/complaint_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

@AppRoute(path: 'complaint_hotline_page', name: '投诉热线')
class ComplaintHotlinePage extends StatefulWidget {
  const ComplaintHotlinePage({Key? key}) : super(key: key);

  @override
  State<ComplaintHotlinePage> createState() => _ComplaintHotlinePageState();
}

class _ComplaintHotlinePageState extends State<ComplaintHotlinePage> {
  // 加载状态
  bool _isLoading = false;
  List<ContactModel> _contactList = [];

  Future<void> _fetchData() async {
    DataUtils.getPageList(
      '/system/connect/list',
      {'pageNum': 1, 'pageSize': 100, 'souceType': 1},
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
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).complaint_hotline,
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _contactList.isEmpty
              ? EmptyView()
              : ListView.separated(
                padding: EdgeInsets.all(12.px),
                itemCount: _contactList.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.px),
                itemBuilder: (context, index) {
                  final item = _contactList[index];
                  return _buildContactCard(item, index);
                },
              ),
    );
  }

  Widget _buildContactCard(ContactModel item, int index) {
    final color = index % 2 == 0 ? secondaryColor : primaryColor;
    return InkWell(
      onTap: () {
        RouteUtils.push(context, ComplaintDetailPage(contact: item));
      },
      borderRadius: BorderRadius.circular(8.px),
      child: Ink(
        padding: EdgeInsets.all(16.px),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.px),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // Softer shadow
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 36.px,
                  height: 36.px,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (item.def1?.isNotEmpty == true)
                        ? item.def1!.substring(0, 1)
                        : '名',
                    style: TextStyle(
                      color: color,
                      fontSize: 16.px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.px),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? S.of(context).unknownName,
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.px),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 14.px, color: color),
                          SizedBox(width: 4.px),
                          Text(
                            item.tel ?? S.of(context).unknownTel,
                            style: TextStyle(
                              fontSize: 12.px,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.px,
                  color: Colors.grey[300],
                ),
              ],
            ),
            if ((item.def1 != null && item.def1!.isNotEmpty) ||
                (item.def2 != null && item.def2!.isNotEmpty)) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.px),
                child: Divider(height: 1, color: Colors.grey[300]),
              ),
              if (item.def1 != null && item.def1!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.px),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.px),
                        child: Icon(
                          Icons.assignment_ind_outlined,
                          size: 16.px,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 8.px),
                      Expanded(
                        child: Text(
                          item.def1!,
                          style: TextStyle(
                            fontSize: 12.px,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if (item.def2 != null && item.def2!.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.px),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 16.px,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8.px),
                    Expanded(
                      child: Text(
                        item.def2!,
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
