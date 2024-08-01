import 'package:flutter/material.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/other_view_model.dart';
import 'package:logistics_app/pages/public_convenience_page/other_content_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/picker.dart';

class PublicConvenienceListPage extends StatefulWidget {
  @override
  _PublicConvenienceListPage createState() => _PublicConvenienceListPage();
}

class _PublicConvenienceListPage extends State<PublicConvenienceListPage> {
  List<DictModel> typeOptions = [];
  List<OtherViewModel> otherDataList = [];
  DictModel? typeCheck;

  @override
  void initState() {
    super.initState();
    _fetchDictData();
  }

  Future<void> _fetchDictData() async {
    // 模拟异步数据获取
    DataUtils.getDictDataList(
      'public_common_type',
      success: (data) {
        BaseListModel<DictModel> response =
            BaseListModel.fromJson(data, (json) => DictModel.fromJson(json));

        setState(() {
          typeOptions = response.data ?? [];
        });
      },
    );
    // 更新状态
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '公共便利',
          style: TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.left,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(36.0),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Picker.showModalSheet(context,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (final type in typeOptions)
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context, type);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 50,
                                        child: Text(type.dictLabel ?? ''),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )).then((value) {
                      if (value != null) {
                        typeCheck = value;
                        setState(() {});
                      }
                    });
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            typeCheck?.dictLabel ?? '请选择设施类型',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 18,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '请选择区域',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          size: 18,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: OtherContentPage(
                souceType: typeCheck?.dictValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
