import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/guide_type_view_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class GuideTypePage extends StatefulWidget {
  const GuideTypePage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _GuideTypePageState createState() => _GuideTypePageState();
}

class _GuideTypePageState extends State<GuideTypePage> {
  GuideTypeViewModel? guideTypeDetail;

  void _fetchData() async {
    DataUtils.getDetailById(
      APIs.guideTypeUrl + '/' + widget.id.toString(),
      success: (data) {
        guideTypeDetail = GuideTypeViewModel.fromJson(data['data']);
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
            guideTypeDetail?.title ?? '',
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
                      guideTypeDetail?.title ?? '',
                      style: TextStyle(
                          fontSize: 18.px, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.px,
                    ),
                    Text(guideTypeDetail?.createTime ?? '',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10.px),
                child: Html(data: guideTypeDetail?.content ?? ''),
              ))
            ],
          ),
        )));
  }
}
