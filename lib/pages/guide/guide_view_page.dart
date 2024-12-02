import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class GuideViewPage extends StatefulWidget {
  const GuideViewPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _GuideViewPageState createState() => _GuideViewPageState();
}

class _GuideViewPageState extends State<GuideViewPage> {
  GuideViewModel? guideDetail;

  void _fetchData() async {
    DataUtils.getDetailById(
      APIs.guideUrl + '/' + widget.id.toString(),
      success: (data) {
        guideDetail = GuideViewModel.fromJson(data['data']);
        setState(() {});
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
          backgroundColor: Colors.transparent,
          title: Text(
            guideDetail?.title ?? '',
            style: TextStyle(fontSize: 16.px),
          ),
        ),
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/guide_bg.png'),
            fit: BoxFit.fill,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guideDetail?.title ?? '',
                      style: TextStyle(
                          fontSize: 14.px, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.px,
                    ),
                    Text(guideDetail?.createTime ?? '',
                        style: TextStyle(
                          fontSize: 10.px,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8.px),
                child: Html(
                  data: guideDetail?.content ?? '',
                  style: {
                    'body': Style(
                      fontSize: FontSize(12.px), // 全局文字大小
                    ),
                  },
                ),
              ))
            ],
          ),
        )));
  }
}
