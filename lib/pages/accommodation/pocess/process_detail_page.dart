import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/accommodation_process_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ProcessDetailPage extends StatefulWidget {
  final AccommodationProcessModel model;

  const ProcessDetailPage({Key? key, required this.model}) : super(key: key);

  @override
  _ProcessDetailPageState createState() => _ProcessDetailPageState();
}

class _ProcessDetailPageState extends State<ProcessDetailPage> {
  final String imagePrefix = APIs.imagePrefix;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部图片和返回按钮
          SliverAppBar(
            title: Text(
              widget.model.title ?? '',
              style: TextStyle(fontSize: 16.px),
            ),
            expandedHeight: 200.px,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.model.img != null
                  ? Image.network(
                      imagePrefix + widget.model.img!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/empty/空.png'),
                    )
                  : Image.asset('assets/images/empty/空.png'),
            ),
          ),

          // 内容区域
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.px),
                  topRight: Radius.circular(20.px),
                ),
              ),
              transform: Matrix4.translationValues(0, -20.px, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题部分
                  Padding(
                    padding: EdgeInsets.all(16.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.title ?? '',
                          style: TextStyle(
                            fontSize: 16.px,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.px),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14.px, color: Colors.grey[400]),
                            SizedBox(width: 4.px),
                            Text(
                              widget.model.createTime ?? '',
                              style: TextStyle(
                                fontSize: 12.px,
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(width: 20.px),
                            Icon(Icons.remove_red_eye,
                                size: 14.px, color: Colors.grey[400]),
                            SizedBox(width: 4.px),
                            Text(
                              '${widget.model.views ?? 0}',
                              style: TextStyle(
                                  fontSize: 12.px, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 分割线
                  Divider(height: 1.px, color: Colors.grey[200]),

                  // 详细内容
                  if (widget.model.content != null &&
                      widget.model.content!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(16.px),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 流程说明
                          if (widget.model.content != null &&
                              widget.model.content!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).processDescription,
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.px),
                                Text(
                                  widget.model.content!,
                                  style: TextStyle(
                                    fontSize: 12.px,
                                    color: Colors.grey[800],
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 20.px),

                          // 注意事项
                          if (widget.model.requirements != null &&
                              widget.model.requirements!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).attention,
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.px),
                                Text(
                                  widget.model.requirements!,
                                  style: TextStyle(
                                    fontSize: 12.px,
                                    color: Colors.grey[800],
                                    height: 1.6,
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
          ),
        ],
      ),
    );
  }
}
