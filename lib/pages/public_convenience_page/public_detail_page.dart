import 'package:flutter/material.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class PublicDetailPage extends StatefulWidget {
  final dynamic listData;

  const PublicDetailPage({Key? key, required this.listData}) : super(key: key);

  @override
  _PublicDetailPageState createState() => _PublicDetailPageState();
}

class _PublicDetailPageState extends State<PublicDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listData.showTitle ?? '',
            style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            if (widget.listData.image != null)
              Container(
                width: double.infinity,
                height: 200.px,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        NetworkImage(APIs.imagePrefix + widget.listData.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    widget.listData.showTitle ?? '',
                    style: TextStyle(
                      fontSize: 16.px,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.px),
                  // 信息列表
                  _buildInfoItem(
                      Icons.location_on, '所在区域', widget.listData.region),
                  _buildInfoItem(
                      Icons.access_time, '营业时间', widget.listData.businessHours),
                  _buildInfoItem(Icons.person, '负责人', widget.listData.head),
                  _buildInfoItem(
                      Icons.phone, '联系电话', widget.listData.telephone),
                  _buildInfoItem(Icons.home, '详细地址', widget.listData.address),

                  // 内容
                  if (widget.listData.details != null &&
                      widget.listData.details.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.px),
                        Text(
                          '详细内容',
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.px),
                        Text(
                          widget.listData.details ?? '',
                          style: TextStyle(
                            fontSize: 10.px,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  // 备注
                  if (widget.listData.remark != null &&
                      widget.listData.remark.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.px),
                        Text(
                          '备注',
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.px),
                        Text(
                          widget.listData.remark ?? '',
                          style: TextStyle(
                            fontSize: 10.px,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.px),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.px, color: primaryColor),
          SizedBox(width: 8.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.px,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2.px),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.px,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
