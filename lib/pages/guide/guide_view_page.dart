import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';

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
            style: TextStyle(fontSize: 16),
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
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guideDetail?.title ?? '',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(guideDetail?.createTime ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10),
                child: Html(data: guideDetail?.content ?? ''),
              ))
            ],
          ),
        )));
  }
}
